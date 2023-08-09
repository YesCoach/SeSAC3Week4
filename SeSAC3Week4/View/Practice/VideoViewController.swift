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

    var contents: String {
        return "\(author) | \(playtime)회\n\(datetime)"
    }
}

final class VideoViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    var videoList: [Video] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var pageNumber = 1
    private var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.prefetchDataSource = self
        searchBar.delegate = self
    }

    func callRequest(query: String, page: Int) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=30&page=\(page)"
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

                    var result: [Video] = []
                    self.isEnd = json["meta"]["is_end"].boolValue

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

                        result.append(data)
                    }

                    self.videoList.append(contentsOf: result)

                } else {
                    print("문제가 발생했어요. 잠시 후 다시 시도해주세요!!")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

// UITableViewDataSourcePrefetching: iOS 10 이상 사용 가능한 프로토콜, cellForRowAt 메서드가 호출되기 전에 미리 호출됨

extension VideoViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VideoTableViewCell.identifier,
            for: indexPath
        ) as? VideoTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contents
        if let url = URL(string: videoList[indexPath.row].thumbnail) {
            cell.thumbnailImageView.kf.setImage(with: URL(string: videoList[indexPath.row].thumbnail))
        }
        return cell
    }

    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    // videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    // page count

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        for indexpath in indexPaths {
            if videoList.count - 1 == indexpath.row && pageNumber < 15 && !isEnd {
                pageNumber += 1
                callRequest(query: searchBar.text!, page: pageNumber)
            }
        }
    }

    // 취소 기능: 직접 취소하는 기능을 구현해주어야 함!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("====취소: \(indexPaths)")

    }
}

extension VideoViewController: UISearchBarDelegate {

    // 새로 검색할 경우 페이지 초기화
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        pageNumber = 1
        videoList = []
        callRequest(query: searchBar.text!, page: pageNumber)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        return true
    }

}
