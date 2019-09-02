//
//  CustomTextFields.swift
//  Test
//
//  Created by Igor Skripnik on 8/31/19.
//  Copyright © 2019 IS. All rights reserved.
//

import UIKit

class CustomTextFields: UITextField {
    
    let customColor = UIColor(red: 164/255, green: 171/255, blue: 170/255, alpha: 1.0)
    let customColorPlaceholder = UIColor(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
    
    override func awakeFromNib() {
        
        var bottomBorder = UIView()
        self.backgroundColor = UIColor.clear
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : customColorPlaceholder])
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = customColor
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 2).isActive = true // Set Border-Strength
    }
}
