//
//  SignUpButton.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/19.
//

import UIKit

class SignUpButton: UIButton {
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = .secondColor?.withAlphaComponent(0.9)
        self.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: 18)
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = .init(width: 1.5, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6
    }
    
    init() {
        super.init(frame: .zero)

        self.setTitle("パスワードをお忘れですか?", for: .normal)
        self.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: 14)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
