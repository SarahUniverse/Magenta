//
//  SpeechRecognizer.swift
//  Magenta
//
//  Created by Sarah Clark on 8/23/24.
//

import Speech

final class SpeechRecognizer: ObservableObject {
    @Published var transcribedText: String = ""
    @Published var isRecording: Bool = false

    var transcribedTextHandler: ((String) -> Void)?
    var errorHandler: ((SpeechRecognizerError) -> Void)?

    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    deinit {
        stopRecording()
    }

    // TODO: Add code to make a noise to indicate it's started to record
    func startRecording() throws {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    do {
                        try self?.startSpeechRecognition()
                    } catch {
                        self?.errorHandler?(.recognitionFailed(error))
                    }
                } else {
                    self?.errorHandler?(.notAuthorized)
                }
            }
        }
    }

    private func startSpeechRecognition() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechRecognizerError.noRecognitionRequest
        }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.transcribedText = transcribedText
                    self.transcribedTextHandler?(transcribedText)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.errorHandler?(.recognitionFailed(error))
                }
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            self?.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        DispatchQueue.main.async {
            self.isRecording = true
        }
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        DispatchQueue.main.async {
            self.isRecording = false
        }
    }

}
