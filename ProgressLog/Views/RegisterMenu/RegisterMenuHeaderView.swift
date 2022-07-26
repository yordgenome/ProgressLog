//
//  RegiWorkoutHeaderView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/06.
//

import UIKit

class RegisterMenuHeaderView: UIView {
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.text = "トレーニング一覧"
        label.textColor = .white
        label.font = UIFont(name: "GeezaPro-Bold", size: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("編集", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = .outColor

        addSubview(textLabel)
        addSubview(editButton)
        textLabel.anchor(top: safeAreaLayoutGuide.topAnchor, centerX: centerXAnchor, width: 200, height: 30, topPadding: 5)
        editButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, width: 50, height: 25, topPadding: 5, rightPadding: 20)

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
