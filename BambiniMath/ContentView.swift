//
//  ContentView.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

//struct ContentView: View {
//    
//    @StateObject private var viewModel = HomeViewModel()
//    
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Button(action: {viewModel.printHello()}, label: {
//                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//            })
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}



struct ContentView: View {
    private enum Constans {
        static let recognizeButtonSide: CGFloat = 100
    }
    
    @ObservedObject private var speechAnalyzer = HomeViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text(speechAnalyzer.isSuccess.0 ?? "Tap to begin")
                .padding()
            
            Button {
                toggleSpeechRecognition()
            } label: {
                Image(systemName: speechAnalyzer.isProcessing ? "waveform.circle.fill" : "waveform.circle")
                    .resizable()
                    .frame(width: Constans.recognizeButtonSide,
                           height: Constans.recognizeButtonSide,
                           alignment: .center)
                    .foregroundColor(speechAnalyzer.isProcessing ? .red : .gray)
                    .aspectRatio(contentMode: .fit)
            }
            .padding()
        }
    }
}

private extension ContentView {
    func toggleSpeechRecognition() {
        if speechAnalyzer.isProcessing {
            speechAnalyzer.stopRecognition()
        } else {
            speechAnalyzer.startRecognition()
        }
    }
}
