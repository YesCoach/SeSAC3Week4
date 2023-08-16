//
//  BeerTableViewCell.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    override func prepareForReuse() {
        beerImageView.image = nil
    }

}

extension BeerTableViewCell {

    func configure(with beer: Beer) {
        if let url = URL(string: beer.imageURL ?? "") {
            beerImageView.kf.setImage(with: url)
        } else {
            beerImageView.image = .init(systemName: "questionmark")
        }
        nameLabel.text = beer.name
        descriptionLabel.text = beer.description
    }

}

private extension BeerTableViewCell {

    func configureUI() {
        beerImageView.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

}
