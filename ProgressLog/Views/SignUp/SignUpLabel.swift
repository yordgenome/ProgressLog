//
//  SignUpLabel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/19.
//

import UIKit

class SignUpLabel: UILabel {
    
    init(text: String, font: UIFont){
        super.init(frame: .zero)
        self.text = text
        self.textColor = .white
        self.textAlignment = .center
        self.font = font
        self.backgroundColor = .clear
    }
    
    init(text: String, fontColor: UIColor = .white){
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


