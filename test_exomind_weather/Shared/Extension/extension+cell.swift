//
//  extension+cell.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import UIKit
extension UITableViewCell: XIBIdentifiable {}
protocol XIBIdentifiable {
    /// id of class UI
    static var id: String { get }

    ///nib of class UI
    static var nib: UINib { get }
}

extension XIBIdentifiable {
    static var id: String {
        String(describing: Self.self)
    }

    static var nib: UINib {
        UINib(nibName: id, bundle: nil)
    }
}
