//
//  HomeViewModel.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation

class HomeViewModel : ObservableObject {
    @Inject var service : DataService
    
    func printHello() {
        service.printHello()
    }
}
