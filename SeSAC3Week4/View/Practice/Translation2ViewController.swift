//
//  Translation2ViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

enum LangCode: String, CaseIterable {
    case auto, ko, ja, en, es, hi, fr, de, pt, vi, id, fa, ar, mm, th, ru, it

    var description: String {
        switch self {
        case .auto: return "자동감지"
        case .ko: return "한국어"
        case .ja: return "일본어"
        case .en: return "영어"
        case .es: return "스페인어"
        case .hi: return "힌두어"
        case .fr: return "프랑스어"
        case .de: return "독일어"
        case .pt: return "포르투갈어"
        case .vi: return "베트남어"
        case .id: return "인도네시아어"
        case .fa: return "페르시아어"
        case .ar: return "아랍어"
        case .mm: return "미얀마어"
        case .th: return "태국어"
        case .ru: return "러시아어"
        case .it: return "이탈리아어"
        }
    }
}

class Translation2ViewController: UIViewController {

    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var targetCodeTextField: UITextField!
    @IBOutlet var sourceCodeTextField: UITextField!

    private lazy var targetPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 2
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private lazy var sourcePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 1
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private var targetCode: LangCode?
    private var sourceCode: LangCode?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBAction func didRequestButtonTouched(_ sender: UIButton) {
        guard let sourceCode, let targetCode else { return }
        if sourceCode == .auto {
            fetchLanguageData()
        } else {
            fetchTranslationData()
        }
    }

}

private extension Translation2ViewController {

    func configureUI() {
        originalTextView.text = nil
        translateTextView.text = nil
        translateTextView.isEditable = false

        targetCodeTextField.inputView = targetPickerView
        sourceCodeTextField.inputView = sourcePickerView
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
                 self?.sourceCode = .init(rawValue: langCode) ?? .en
                 self?.fetchTranslationData()
             case .failure(let error):
                 print(error)
             }
         }
    }

    func fetchTranslationData() {
        guard let sourceCode, let targetCode else { return }

        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        let param: Parameters = [
            "source": sourceCode.rawValue,
            "target": targetCode.rawValue,
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

extension Translation2ViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LangCode.allCases.count
    }

}

extension Translation2ViewController: UIPickerViewDelegate {

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return LangCode.allCases[row].description
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        if pickerView.tag == 1 {
            sourceCode = LangCode.allCases[row]
        } else {
            targetCode = LangCode.allCases[row]
        }
    }

}
