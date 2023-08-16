//
//  KakaoAPIManger.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/11.
//

import Foundation
import Alamofire

final class KakaoAPIManger {

    static let shared = KakaoAPIManger()

    private init() { }

    private let header: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakaoKey)"]
}

extension KakaoAPIManger {

    func callRequest<T: Codable>(
        type: Endpoint,
        query: String,
        completionHandler: @escaping (T) -> ()
    ) {

        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.requestURL + text

        AF.request(
            url,
            method: .get,
            headers: header
        )
        .validate(statusCode: 200...299)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
