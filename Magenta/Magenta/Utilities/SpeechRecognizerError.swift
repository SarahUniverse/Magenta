//
//  SpeechRecognizerError.swift
//  Magenta
//
//  Created by Sarah Clark on 1/14/25.
//

enum SpeechRecognizerError: Error {
    case notAuthorized
    case noRecognitionRequest
    case audioEngineFailed
    case recognitionFailed(Error)
}
