//
//  image buttons.swift
//  createprofile2
//
//  Created by Kai Munechika on 5/18/16.
//  Copyright © 2016 Kai Munechika. All rights reserved.
//

import UIKit

class image_buttons: UIButton {
    
    override func awakeFromNib() {
        titleLabel!.numberOfLines = 1
        titleLabel!.adjustsFontSizeToFitWidth = true
        contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)

    }
    
    

}
