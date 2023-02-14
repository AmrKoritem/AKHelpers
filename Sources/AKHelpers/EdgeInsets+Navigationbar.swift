//
//  EdgeInsets+Navigationbar.swift
//  AKHelpers
//
//  Created by Amr Koritem on 11/02/2023.
//

import UIKit

public extension UIEdgeInsets {
    /// Makes a `UIEdgeInsets` instance with its `left` and `right` properties having equal values.
    static func symmetric(horizontal: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }

    /// Makes a `UIEdgeInsets` instance with its `top` and `bottom` properties having equal values.
    static func symmetric(vertical: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0)
    }
}

public extension UINavigationBar {
    func makeTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = .clear
    }
}

public extension UINavigationController {
    func makeNavigationBarTransparent() {
        navigationBar.makeTransparent()
    }
}
