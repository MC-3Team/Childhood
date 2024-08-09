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
    private var storedValue: T?

    init(container: Container = .AppContainer) {
        self.container = container
        self.storedValue = container.resolve(T.self)
    }

    var wrappedValue: T {
        get {
            let resolved = storedValue ?? container.resolve(T.self)
            assert(resolved != nil, "Dependency not found: \(String(describing: T.self))")
            return resolved!
        }
        set {
            storedValue = newValue
        }
    }
}
