//
//  ReusableViewProtocol.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/11.
//

import UIKit

protocol ReusableViewProtocol {

    static var identifier: String { get }

}

extension UITableViewCell: ReusableViewProtocol {

    static var identifier: String {
        return String(describing: self)
    }

}

extension UIViewController: ReusableViewProtocol {

    static var identifier: String {
        return String(describing: self)
    }

}
