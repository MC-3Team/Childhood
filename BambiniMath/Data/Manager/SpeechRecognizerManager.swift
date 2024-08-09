//
//  SpeechRecognizerManager.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Speech
import RxSwift

class SpeechRecognitionManager: NSObject, SpeechRecognizerService, SFSpeechRecognizerDelegate {
        private let audioEngine = AVAudioEngine()
        private var inputNode: AVAudioInputNode?
        private var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
        private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        private var recognitionTask: SFSpeechRecognitionTask?
        private var audioSession: AVAudioSession?
        
        func startRecognition() -> Observable<(String?, Bool)> {
            let subject = PublishSubject<(String?, Bool)>()
            
            audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Couldn't configure the audio session properly")
                subject.onError(error)
                return subject
            }
            
            inputNode = audioEngine.inputNode
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id_ID"))
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
            
            guard let speechRecognizer = speechRecognizer,
                  speechRecognizer.isAvailable,
                  let recognitionRequest = recognitionRequest,
                  let inputNode = inputNode
            else {
                assertionFailure("Unable to start the speech recognition!")
                subject.onCompleted()
                return subject
            }
            
            speechRecognizer.delegate = self
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                recognitionRequest.append(buffer)
            }

            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                        if let result = result {
                            let transcription = result.bestTranscription.formattedString
                            subject.onNext((transcription, true))
                        } else if let error = error {
                            subject.onError(error)
                        } else {
                            subject.onNext((nil, false))
                        }
                        subject.onCompleted()
                        self?.stopRecognition()
                    }

            audioEngine.prepare()
            
            do {
                try audioEngine.start()
            } catch {
                print("Couldn't start audio engine!")
                subject.onError(error)
                stopRecognition()
            }
            
            return subject
        }
        
        func stopRecognition() {
            recognitionTask?.cancel()
            
            audioEngine.stop()
            
            inputNode?.removeTap(onBus: 0)
            try? audioSession?.setActive(false)
            audioSession = nil
            inputNode = nil
            
            recognitionRequest = nil
            recognitionTask = nil
            speechRecognizer = nil
        }
}
