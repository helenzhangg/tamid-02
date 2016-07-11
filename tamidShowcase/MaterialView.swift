//
//  MaterialView.swift
//  tamidShowcase
//
//  Created by H on 5/24/16.
//  Copyright © 2016 H. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        // set a shadow on the login view 
        // and rounds the corners
        
        layer.cornerRadius = 2.5
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        // alpha 0.5 = half opaque
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.5
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        // width = 0.0 -> shadow is not offset- surrounds whole view
    }

}
