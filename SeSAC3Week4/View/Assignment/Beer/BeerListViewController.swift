//
//  BeerListViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

final class BeerListViewController: UIViewController {

    static let identifier = "BeerListViewController"

    @IBOutlet var tableView: UITableView!

    private var dataList: [Beer] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }
}

private extension BeerListViewController {

    func configureUI() {
        let nib = UINib(nibName: BeerTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BeerTableViewCell.identifier)
        tableView.dataSource = self
        tableView.rowHeight = 80.0
    }

    func fetchData() {
        let url = "https://api.punkapi.com/v2/beers/"
        AF.request(url, method: .get).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                self?.dataList = json.map({ (str, json) in
                    let beer = Beer(
                        id: json["id"].intValue,
                        name: json["name"].stringValue,
                        imageURL: json["image_url"].stringValue,
                        description: json["description"].stringValue
                    )
                    return beer
                })
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension BeerListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BeerTableViewCell.identifier,
            for: indexPath
        ) as? BeerTableViewCell
        else { return UITableViewCell() }

        cell.configure(with: dataList[indexPath.row])

        return cell
    }

}
