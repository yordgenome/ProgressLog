//
//  SetWorkoutView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/25.
//

import UIKit

class SetWorkoutView: UIView, UITextFieldDelegate{
    private let gradientView = SecondGradientView()

    let batsuLabel: UILabel = {
        let label = UILabel()
        label.text = "×"
        label.textColor = .baseColor
        label.font = UIFont(name: "GeezaPro", size: 26)
        return label
    }()
    
    let targetPartTextField: UITextField = SetWorkoutTextField(frame: .zero, placeholder: "部位", tag: 0, labelWidth: 30)
    
    let workoutNameTextField: UITextField = SetWorkoutTextField(frame: .zero, placeholder: "トレーニングメニュー", tag: 1, labelWidth: 110)

    let weightTextField: UITextField = SetWorkoutTextField(frame: .zero, placeholder: "重量", tag: 2, labelWidth: 30)
    
    let repsTextField: UITextField = SetWorkoutTextField(frame: .zero, placeholder: "レップ数", tag: 3, labelWidth: 50)
    
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
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("クリア", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor.secondColor?.cgColor
        button.layer.shadowOffset = .init(width: 1.5, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 6
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        gradientView.frame = UIScreen.main.bounds
        addSubview(gradientView)
        
        targetPartTextField.delegate = self
        workoutNameTextField.delegate = self
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        weightTextField.keyboardType = .numberPad
        repsTextField.keyboardType = .numberPad
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addsubViews()
        
        targetPartTextField.anchor(top: topAnchor, left: leftAnchor, width: 120, height: 26, topPadding: 20, leftPadding: 20)
        workoutNameTextField.anchor(top: targetPartTextField.topAnchor, left: targetPartTextField.rightAnchor, right: rightAnchor, height: 26, leftPadding: 20, rightPadding: 20)
        weightTextField.anchor(top: targetPartTextField.bottomAnchor, left: targetPartTextField.leftAnchor, width: 80, height: 26, topPadding: 20)
        batsuLabel.anchor(top: weightTextField.topAnchor, left: weightTextField.rightAnchor, width: 20, height: 26, leftPadding: 20)
        repsTextField.anchor(top: weightTextField.topAnchor, left: batsuLabel.rightAnchor, width: 80, height: 26, leftPadding: 20)
        setButton.anchor(bottom: weightTextField.bottomAnchor, right: rightAnchor, width: 45, height: 34, rightPadding: 20)
        clearButton.anchor(bottom: weightTextField.bottomAnchor, right: setButton.leftAnchor, width: 45, height: 34, rightPadding: 20)
        }
    
    private func addsubViews() {
        addSubview(batsuLabel)
        addSubview(workoutNameTextField)
        addSubview(targetPartTextField)
        addSubview(weightTextField)
        addSubview(repsTextField)
        addSubview(setButton)
        addSubview(clearButton)
    }
}
