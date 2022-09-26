//
//  SettingTextField.swift
//  ProgressLog
//
//  Created by 田原葉 on 2022/09/12.
//

import UIKit

class SettingTextField: UITextField {
    
    init(text: String, tag: Int = 0, returnKeyType: UIReturnKeyType){
        super.init(frame: .zero)
        self.text = text
        self.borderStyle = .roundedRect
        self.backgroundColor = .white
        self.tag = tag
        self.returnKeyType = returnKeyType
        if #available(iOS 12.0, *) { self.textContentType = .oneTimeCode }
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.baseColor!.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowOffset = .init(width: 1.5, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
