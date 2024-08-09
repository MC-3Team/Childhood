//
//  HomeViewModel.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift
import Speech

class HomeViewModel : ObservableObject {
    @Inject var service : DataService
    @Inject private var speechRecognitionService: SpeechRecognizerService
    
    @Published var isProcessing: Bool = false
    @Published var isSuccess: (String?, Bool) = (nil, false)
    @Published var isFailed: Bool = false
    
    private let disposeBag = DisposeBag()
    
    func startRecognition() {
        speechRecognitionService.startRecognition()
            .do(onSubscribe: { [weak self] in
                print("sampe sini")
                self?.isProcessing = true
                self?.isFailed = false
                self?.isSuccess = (nil, false)
            })
            .subscribe(onNext: { [weak self] (text, success) in
                self?.isSuccess = (text, success)
                self?.isProcessing = false
            }, onError: { [weak self] error in
                self?.isFailed = true
                self?.isProcessing = false
            })
            .disposed(by: disposeBag)
    }
    
    func stopRecognition() {
        speechRecognitionService.stopRecognition()
        isProcessing = false
        isSuccess = (nil, false)
        isFailed = false
    }
    func printHello() {
        service.printHello()
    }
}

final class SpeechAnalyzer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?
    
    @Published var recognizedText: String?
    @Published var isProcessing: Bool = false

    func start() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
        
        inputNode = audioEngine.inputNode
        
        speechRecognizer = SFSpeechRecognizer()
        print("Supports on device recognition: \(speechRecognizer?.supportsOnDeviceRecognition == true ? "✅" : "🔴")")

        // Force specified locale
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id_ID"))
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Disable partial results
        // recognitionRequest?.shouldReportPartialResults = false
        
        // Enable on-device recognition
        // recognitionRequest?.requiresOnDeviceRecognition = true

        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode
        else {
            assertionFailure("Unable to start the speech recognition!")
            return
        }
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }
        
        print(speechRecognizer)

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            self?.recognizedText = result?.bestTranscription.formattedString
            
            guard error != nil || result?.isFinal == true else { return }
            self?.stop()
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            print("Coudn't start audio engine!")
            stop()
        }
    }
    
    func stop() {
        recognitionTask?.cancel()
        
        audioEngine.stop()
        
        inputNode?.removeTap(onBus: 0)
        try? audioSession?.setActive(false)
        audioSession = nil
        inputNode = nil
        
        isProcessing = false
        
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("✅ Available")
        } else {
            print("🔴 Unavailable")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
    }
}

