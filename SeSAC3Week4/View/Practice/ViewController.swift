//
//  ViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    var release: String
}

final class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!

    var movieList: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        indicatorView.isHidden = true
    }

    func callRequest(date: String) {

        indicatorView.isHidden = false
        indicatorView.startAnimating()

        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"

        AF.request(url, method: .get).validate().responseJSON { [weak self] response in

            self?.indicatorView.isHidden = true
            self?.indicatorView.stopAnimating()

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let title = item["movieNm"].stringValue
                    let release = item["openDt"].stringValue

                    let movie = Movie(title: title, release: release)

                    self?.movieList.append(movie)
                }

                self?.tableView.reloadData()

            case .failure(let error):
                print(error)
            }
        }
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = movieList[indexPath.row].release

        return cell
    }

}

extension ViewController: UITableViewDelegate {

}


extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        // 20220101 > 1. 8글자 2. 20233333 올바른 날짜 3. 날짜의 범위에 해당하는지

        callRequest(date: searchBar.text!)

    }

}
