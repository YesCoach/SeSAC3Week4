//
//  UserDefaultsHelper.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/11.
//

import Foundation

class UserDefaultsHelper {

    let userDefaults = UserDefaults.standard

    enum Key: String { // 컴파일 최적화
        case nickname, age
    }

    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.nickname.rawValue)
        }
    }

    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.age.rawValue)
        }
    }

}
