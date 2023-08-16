//
//  BeerViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

final class BeerViewController: UIViewController {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var beerButton: UIButton!

    private var beer: Beer? {
        didSet {
            if let beer {
                let url = URL(string: beer.imageURL ?? "")
                imageView.kf.setImage(with: url)
                nameLabel.text = beer.name
                descriptionLabel.text = beer.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }

    @IBAction func didRandomBeerButtonTouched(_ sender: UIButton) {
        fetchData()
    }

    @IBAction func didRightBarButtonTouched(_ sender: UIBarButtonItem) {
        guard let viewController = storyboard?.instantiateViewController(
            withIdentifier: BeerListViewController.identifier
        ) as? BeerListViewController
        else { return }

        navigationController?.pushViewController(viewController, animated: true)
    }

}

private extension BeerViewController {

    func configureUI() {
        headerLabel.text = "오늘은 이 맥주를 추천합니다!"
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerLabel.textAlignment = .center

        imageView.contentMode = .scaleAspectFit

        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        nameLabel.textAlignment = .center

        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        var config = UIButton.Configuration.plain()

        config.title = "다른 맥주 추천받기"
        config.image = .init(systemName: "star.bubble")
        config.imagePadding = 8.0
        config.imagePlacement = .leading
        config.baseForegroundColor = .systemOrange

        beerButton.configuration = config

        navigationItem.backButtonTitle = ""
    }

    func fetchData() {

        let url = "https://api.punkapi.com/v2/beers/random"

        AF.request(
            url,
            method: .get
        )
        .validate()
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                self?.beer = Beer(
                    id: json[0]["id"].intValue,
                    name: json[0]["name"].stringValue,
                    imageURL: json[0]["image_url"].stringValue,
                    description: json[0]["description"].stringValue
                )

            case .failure(let error):
                print(error)
            }
        }

    }
}
