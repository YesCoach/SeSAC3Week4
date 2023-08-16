//
//  AsyncViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    @IBOutlet var first: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var third: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        first.backgroundColor = .black

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.first.layer.cornerRadius = self.first.frame.width / 2
        }
    }

    // sync async serial concurrent
    // UI Freezing

    @IBAction func didButtonTouched(_ sender: UIButton) {

        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!

        DispatchQueue.global().async { [weak self] in
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)

            DispatchQueue.main.async {
                self?.first.image = image
            }
        }
    }

}
