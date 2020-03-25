//
//  UIVIew+Extension.swift
//  CatchMe
//
//  Created by Nadia on 3/24/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import UIKit

// MARK: - Styling
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return nil
            }
        }
    }
}

// MARK: - Blur
extension UIView {
    func blurView() {
        self.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
    }
}
