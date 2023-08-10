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

    private var languageCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBAction func didRequestButtonTouched(_ sender: UIButton) {
        fetchLanguageData()
    }

}

private extension TranslationViewController {

    func configureUI() {
        originalTextView.text = nil
        translateTextView.text = nil
        translateTextView.isEditable = false
    }

    func fetchLanguageData() {
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        let param: Parameters = [
            "query": originalTextView.text!
        ]
        AF.request(url, method: .post, parameters: param, headers: header)
            .validate()
            .responseJSON { [weak self] response in
             switch response.result {
             case .success(let value):
                 let json = JSON(value)
                 let langCode = json["langCode"].stringValue
                 self?.languageCode = langCode
                 self?.fetchTranslationData(with: langCode)
             case .failure(let error):
                 print(error)
             }
         }
    }

    func fetchTranslationData(with langCode: String) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        let param: Parameters = [
            "source": langCode,
            "target": "ko",
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
