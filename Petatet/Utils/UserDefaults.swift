//
//  UserDefaults.swift
//  Petatet
//
//  Created by Nikita Ivanov on 25/06/2024.
//

import Foundation

extension UserDefaults {
    struct Key<Value> {
        var name: String
    }

    subscript<T>(key: Key<T>) -> T? {
        get {
            return value(forKey: key.name) as? T
        }
        set {
            setValue(newValue, forKey: key.name)
        }
    }
}

extension UserDefaults.Key {
    static var uid: UserDefaults.Key<String> {
        return .init(name: "uid")
    }

    static var token: UserDefaults.Key<String> {
        return .init(name: "token")
    }
}

