//
//  BluredVIew.swift
//  CatchMe
//
//  Created by Nadia on 3/24/20.
//  Copyright © 2020 Nadzeya. All rights reserved.
//

import UIKit

class BluredView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.blurView()
    }
}
