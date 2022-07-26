//
//  RegisterWorkoutMenuCell.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/05.
//

import UIKit

class RegsterMenuCell: UITableViewCell {
    
    static let identifier = "RegiWorkoutCell"
    
    let menuLabel: UILabel = {
        let label = UILabel()
        
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(menuLabel)
        menuLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, leftPadding: 50)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
