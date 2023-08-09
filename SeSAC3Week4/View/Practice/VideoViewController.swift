//
//  VideoViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Video {
    let author: String
    let datetime: String
    let playtime: Int
    let thumbnail: String
    let title: String
    let url: String
}

final class VideoViewController: UIViewController {

    var videoList: [Video] = []

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
    .validate(statusCode: 200...500)
    .responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)

            print(response.response?.statusCode)

            let statusCode = response.response?.statusCode ?? 500

            if statusCode == 200 {
                for item in json["documents"].arrayValue {
                    let author = item["author"].stringValue
                    let date = item["datetime"].stringValue
                    let time = item["play_time"].intValue
                    let thumbnail = item["thumbnail"].stringValue
                    let title = item["title"].stringValue
                    let link = item["url"].stringValue

                    let data = Video(
                        author: author,
                        datetime: date,
                        playtime: time,
                        thumbnail: thumbnail,
                        title: title,
                        url: link
                    )


                    self.videoList.append(data)
                }

                print(self.videoList)

            } else {
                print("문제가 발생했어요. 잠시 후 다시 시도해주세요!!")
            }
        case .failure(let error):
            print(error)
        }
    }
}
}
