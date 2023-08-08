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

    var movieList: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self

        callRequest()
    }

    func callRequest() {
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20230806"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let title = item["movieNm"].stringValue
                    let release = item["openDt"].stringValue

                    let movie = Movie(title: title, release: release)

                    self.movieList.append(movie)
                }

                self.tableView.reloadData()

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
