//
//  TranslationViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController {

    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBAction func didRequestButtonTouched(_ sender: UIButton) {

        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        let param: Parameters = [
            "source": "ko",
            "target": "ja",
            "text": originalTextView.text!
        ]

        AF.request(url, method: .post, parameters: param, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                self.translateTextView.text = json["message"]["result"]["translatedText"].stringValue
            case .failure(let error):
                print(error)
            }
        }
    }

}

private extension TranslationViewController {

    func configureUI() {
        originalTextView.text = nil
        translateTextView.text = nil
        translateTextView.isEditable = false
    }

}
