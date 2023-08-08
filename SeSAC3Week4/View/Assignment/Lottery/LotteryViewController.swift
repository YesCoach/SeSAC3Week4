//
//  LotteryViewController.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

final class LotteryViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var textField: UITextField!

    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()

    private var lotteryData: Lottery? {
        didSet {
            titleLabel.text = lotteryData?.date
            resultLabel.text = lotteryData?.resultText
        }
    }
    private let list: [Int] = Array(1...1079).reversed()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData(with: 1079)
    }
}

private extension LotteryViewController {
    func configureUI() {
        textField.inputView = pickerView
        resultLabel.textAlignment = .center
    }

    func fetchData(with drwNo: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
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

                self?.lotteryData = Lottery(
                    date: json["drwNoDate"].stringValue,
                    no1: json["drwtNo1"].intValue,
                    no2: json["drwtNo2"].intValue,
                    no3: json["drwtNo3"].intValue,
                    no4: json["drwtNo4"].intValue,
                    no5: json["drwtNo5"].intValue,
                    no6: json["drwtNo6"].intValue,
                    bonusNo: json["bnusNo"].intValue
                )

            case .failure(let error):
                print(error)
            }
        }
    }
}

extension LotteryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
}

extension LotteryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = "\(list[row])"
        fetchData(with: list[row])
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row])회차"
    }
}
