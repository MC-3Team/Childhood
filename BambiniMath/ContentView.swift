//
//  ContentView.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button(action: {viewModel.printHello()}, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
