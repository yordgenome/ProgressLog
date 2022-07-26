//
//  TrainingLogHeaderView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/04.
//

import UIKit

final class DatePickView: UIView, UITextFieldDelegate {
    
    let nextDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("翌日＞", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "GeezaPro", size: 14)
        button.layer.masksToBounds = true
        return button
    }()
    
    let previousDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＜前日", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "GeezaPro", size: 14)
        button.layer.masksToBounds = true
        return button
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont(name: "GeezaPro-Bold", size: 20)
        textField.textColor = UIColor.white
        textField.layer.masksToBounds = true
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.locale = Locale.current
        dp.maximumDate = Date()
        dp.backgroundColor = UIColor.baseColor
        return dp
    }()
    
    private let totalVolumeLabel: UILabel = {
        let label = UILabel()
        label.text = "本日のトレーニングボリューム"
        
        
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .baseColor
        
        dateTextField.text = DateUtils.toStringFromDate(date: Date())

        setupLayout()
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        dateTextField.delegate = self
    }
    
    private func setupLayout() {
        backgroundColor = .outColor
        addSubview(previousDayButton)
        addSubview(dateTextField)
        addSubview(nextDayButton)
        
        previousDayButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, width: 50, height: 25, topPadding: 5, leftPadding: 20)
        dateTextField.anchor(top: safeAreaLayoutGuide.topAnchor, centerX: centerXAnchor, width: 150, height: 30, topPadding: 5)
        nextDayButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, width: 50, height: 25, topPadding: 5, rightPadding: 20)
    }
    
    @objc func done() {

        dateTextField.text = DateUtils.toStringFromDate(date: datePicker.date)
        endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


