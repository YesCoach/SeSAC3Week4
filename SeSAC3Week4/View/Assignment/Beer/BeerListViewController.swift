//
//  BeerListViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit

final class BeerListViewController: UIViewController {

    static let identifier = "BeerListViewController"

    @IBOutlet var tableView: UITableView!

    private var dataList: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension BeerListViewController {

    func configureUI() {
        let nib = UINib(nibName: BeerTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BeerTableViewCell.identifier)
        tableView.dataSource = self
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
