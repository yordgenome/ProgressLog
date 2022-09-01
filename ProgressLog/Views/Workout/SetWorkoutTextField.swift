//
//  WorkoutCellTextField.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/19.
//

import Foundation
import UIKit

class SetWorkoutTextField: UITextField {
    
    let label = UILabel()
//
//    var leftBorder = CALayer()
//    var rightBorder = CALayer()
//    var topBorder = CALayer()
//    var bottomBorder = CALayer()

    
    init(frame: CGRect, placeholder: String, tag: Int, labelWidth: CGFloat, borderWidth: CGFloat = 1, borderColor: UIColor = UIColor.baseColor!, cornerRadius: CGFloat = 5) {
        super.init(frame: frame)
        // textField
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowOffset = .init(width: 1.5, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6
        self.tag = tag
        self.placeholder = " " + placeholder
        self.borderStyle = .roundedRect
        self.font = UIFont.systemFont(ofSize: 14)

        // label
        label.text = placeholder
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.cornerRadius = 3
        label.layer.backgroundColor = borderColor.cgColor
        label.textColor = UIColor.white
        self.addSubview(label)
        label.anchor(bottom: self.topAnchor, left: self.leftAnchor, width: labelWidth, height: 14, bottomPadding: -2, leftPadding: -2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


