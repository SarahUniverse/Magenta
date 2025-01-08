//
//  SpeechRecognizer.swift
//  Magenta
//
//  Created by Sarah Clark on 8/23/24.
//

import Speech

class SpeechRecognizer: ObservableObject {
    @Published var transcribedText: String = ""
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) // or whatever locale you need
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    func startRecording() throws {
        // Request speech recognition authorization
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    do {
                        try self.startSpeechRecognition()
                    } catch {
                        print("Error starting speech recognition: \(error.localizedDescription)")
                    }
                } else {
                    print("Speech recognition authorization denied or not determined")
                }
            }
        }
    }

    private func startSpeechRecognition() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                }
            } else if let error = error {
                print("Recognition error: \(error)")
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
    }
}
