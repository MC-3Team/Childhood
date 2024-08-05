//
//  Inject.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<T> {
    private let container: Container

    init(container: Container = .AppContainer) {
        self.container = container
    }

    var wrappedValue: T {
        get {
            let resolved = container.resolve(T.self)
            assert(resolved != nil, "Dependency not found: \(String(describing: T.self))")
            return resolved!
        }
    }
}
