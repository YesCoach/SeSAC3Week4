//
//  TranslateAPIManager.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

final class TranslateAPIManager {

    static let shared = TranslateAPIManager()

    private init() { }

    private let header: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.naverId,
        "X-Naver-Client-Secret": APIKey.naverSecret
    ]
}

extension TranslateAPIManager {

    func callRequest(param: Parameters, completionHandler: @escaping (String) -> ()) {

        let url = "https://openapi.naver.com/v1/papago/n2mt"

        AF.request(url, method: .post, parameters: param, headers: header)
            .validate()
            .responseJSON { response in
                print(url)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let text = json["message"]["result"]["translatedText"].stringValue
                    completionHandler(text)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
