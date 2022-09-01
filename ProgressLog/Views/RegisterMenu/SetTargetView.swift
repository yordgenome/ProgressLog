//
//  CreateWorkoutView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/06.
//

import UIKit

class SetTargetView: UIView, UITextFieldDelegate{
    
    private let gradientView = SecondGradientView()
    
    let targetTextField = SetWorkoutTextField(frame: .zero, placeholder: "ターゲット部位を追加", tag: 0, labelWidth: 120)
    
//    let targetTextLabel: UILabel = {
//        let label = UILabel()
//        label.text = "ターゲット部位を追加"
//        label.textColor = .baseColor
//        label.font = UIFont(name: "GeezaPro", size: 10)
//        return label
//    }()
    
//    let targetTextField: UITextField = {
//        let textField = UITextField()
//        textField.tag = 0
//        textField.placeholder = "ターゲット部位"
//        textField.borderStyle = .roundedRect
//        textField.textColor = .baseColor
//        return textField
//    }()
    
    let setButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("追加", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor.outColor?.cgColor
        button.layer.shadowOffset = .init(width: 1.5, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 6
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.masksToBounds = true
        targetTextField.keyboardType = UIKeyboardType.default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(gradientView)
//        addSubview(targetTextLabel)
        addSubview(targetTextField)
        addSubview(setButton)
        gradientView.frame = UIScreen.main.bounds
//        targetTextLabel.anchor(top: topAnchor, left: leftAnchor, width: 120, height: 12, topPadding: 10, leftPadding: 20)
        targetTextField.anchor(top: topAnchor, left: leftAnchor, width: 140, height: 20, topPadding: 20, leftPadding: 20, rightPadding: 20)
        setButton.anchor(top: topAnchor, right: rightAnchor, width: 60, height: 34, topPadding: 10, rightPadding: 20)
        
    }
    
    private func addsubViews() {

    }
}
