//
//  SecondGradientView.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/20.
//

import UIKit

class SecondGradientView: UIView, CAAnimationDelegate {
    
    let gradientLayer = CAGradientLayer()
        
    let colors = [
        UIColor.secondColor,
        UIColor.white
    ].map { $0!.cgColor}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = colors
        gradientLayer.drawsAsynchronously = true
        layer.addSublayer(gradientLayer)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
