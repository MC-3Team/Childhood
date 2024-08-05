//
//  AppContainer.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Swinject

extension Container {
    static var AppContainer : Container {
        let container = Container()
        
        container.register(DataService.self) { _ in
            CoreDataManager.shared
                }
        
        return container
    }
}
