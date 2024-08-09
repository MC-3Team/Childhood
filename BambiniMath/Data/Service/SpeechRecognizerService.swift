//
//  SpeechRecognizerService.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift

protocol SpeechRecognizerService {
    func startRecognition() -> Observable<(String?, Bool)>
    func stopRecognition()
}
