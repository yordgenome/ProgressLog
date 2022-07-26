//
//  SignUpButtom.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/19.
//

import UIKit

class SignUptTextField: UITextField {
    
    init(placeholder: String, tag: Int, returnKeyType: UIReturnKeyType){
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.backgroundColor = .white
        self.tag = tag
        self.returnKeyType = returnKeyType
        if #available(iOS 12.0, *) { self.textContentType = .oneTimeCode }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
