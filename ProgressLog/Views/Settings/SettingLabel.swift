//
//  SettingLabel.swift
//  ProgressLog
//
//  Created by 田原葉 on 2022/09/12.
//

import UIKit

class SettingLabel: UILabel {
    
    init(){
        super.init(frame: .zero)
        self.textColor = .outColor
        self.textAlignment = .left
        self.font = font
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.baseColor!.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = .init(width: 1.5, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6
    }
    
    init(text: String, fontColor: UIColor = UIColor.outColor!){
        super.init(frame: .zero)
        self.text = text
        self.textColor = fontColor
        self.textAlignment = .left
        self.font = UIFont(name: "GeezaPro", size: 12)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
