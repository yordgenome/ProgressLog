//
//  RegisterWorkoutMenuHeader.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/06.
//

import UIKit

class RegisterMenuTableViewVHeader: UIView {
    
    var delegate: TableHeaderViewDelegate? = nil
    var section: Int = 0
    
    let targetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.outColor?.cgColor
        label.layer.cornerRadius = 8
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return label
    }()
    
    let openSectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.white.cgColor
//        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .outColor
        return button
    }()
    
    let addMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.outColor?.cgColor
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.baseColor?.cgColor
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init(frame: CGRect, section: Int) {
        super.init(frame: frame)
        self.section = section
        
        setupLayout()
    }
    
    private func setupLayout() {
        layer.cornerRadius = 8
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = .white
        

        addSubview(targetLabel)
        addSubview(openSectionButton)
        addSubview(addMenuButton)
        addSubview(deleteButton)
        targetLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: 150)
        openSectionButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, width: 60)
        addMenuButton.anchor(top: topAnchor, bottom: bottomAnchor, right: openSectionButton.leftAnchor, width: 30)
        deleteButton.anchor(top: topAnchor, bottom: bottomAnchor, right: addMenuButton.leftAnchor, width: 30, rightPadding: 20)
        openSectionButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc private func tappedButton() {
        print(#function, self.section)
        if let dg = self.delegate {
            dg.changeCellState(view: self, section: self.section)
        } else {
            print("error: \(#function)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
