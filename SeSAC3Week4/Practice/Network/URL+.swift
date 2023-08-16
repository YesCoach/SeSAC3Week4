//
//  URL+.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/11.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"

    // endpoint를 통해 url을 반환하는 메서드
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
