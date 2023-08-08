//
//  VideoViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

final class VideoViewController: UIViewController {

    var videoList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        callRequest()
    }

    func callRequest() {
        let text = "엔믹스".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)"
        let header: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakaoKey)"]

        AF.request(
            url,
            method: .get,
            headers: header
        )
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                for item in json["documents"].arrayValue {
                    let title = item["title"].stringValue
                    self.videoList.append(title)
                }

                print(self.videoList)

            case .failure(let error):
                print(error)
            }
        }
    }
}
