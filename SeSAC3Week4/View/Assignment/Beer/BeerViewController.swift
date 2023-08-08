//
//  BeerViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit

final class BeerViewController: UIViewController {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var beerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

}

private extension BeerViewController {
    func configureUI() {
        headerLabel.text = "오늘은 이 맥주를 추천합니다!"
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)

        imageView.contentMode = .scaleAspectFill

        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)

        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 0

        beerButton.setTitle("다른 맥주 추천받기", for: .normal)
        beerButton.setImage(.init(systemName: "star.bubble"), for: .normal)
        beerButton.tintColor = .systemOrange

    }
}
