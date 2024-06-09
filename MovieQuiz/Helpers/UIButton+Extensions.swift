//
//  UIButton+Extensions.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 14.05.2024.
//

import UIKit

extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
