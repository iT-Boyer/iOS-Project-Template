//
//  CornerRadius.swift
//  KidsReader
//
//  Created by BB9z on 2020/12/31.
//

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
