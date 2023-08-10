//
//  CustomTextField.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/10.
//

import UIKit

final class CustomTextField: UITextField {

    var isPasteBlocked: Bool = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if isPasteBlocked && action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
}
