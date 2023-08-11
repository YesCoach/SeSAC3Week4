//
//  CustomTextField.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/10.
//

import UIKit

final class CustomTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.copy(_:))
        {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
}
