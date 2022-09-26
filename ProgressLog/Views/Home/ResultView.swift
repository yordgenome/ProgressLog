//
//  ResultView.swift
//  ProgressLog
//
//  Created by 田原葉 on 2022/09/19.
//

import UIKit

class ResultView: UIView {
    
    let resultLabel = UILabel()
    let percentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 125
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = 4
        layer.borderColor = UIColor.baseColor!.cgColor
        
        resultLabel.text = "0"
        resultLabel.font = UIFont(name: "GeezaPro-Bold", size: 80)
        resultLabel.textColor = UIColor.baseColor
        resultLabel.textAlignment = .center

        percentLabel.text = "%"
        percentLabel.font = UIFont(name: "GeezaPro-Bold", size: 20)
        percentLabel.textColor = UIColor.baseColor
        percentLabel.textAlignment = .center

        setupLayout()
    }
    
    func setupLayout() {
        addSubview(resultLabel)
        addSubview(percentLabel)

        resultLabel.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: 180, height: 80)
        percentLabel.anchor(bottom: resultLabel.bottomAnchor, left:  resultLabel.rightAnchor, width: 30, height: 30)

    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
