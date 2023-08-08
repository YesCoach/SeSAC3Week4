//
//  Lottery.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import Foundation

struct Lottery {
    let date: String
    let no1: Int
    let no2: Int
    let no3: Int
    let no4: Int
    let no5: Int
    let no6: Int
    let bonusNo: Int
}

extension Lottery {
    var resultText: String {
        return "\(no1) - \(no2) - \(no3) - \(no4) - \(no5) - \(no6) - \(bonusNo)"
    }
}
