//
//  GradientAnimationView.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/18.
//

import UIKit

class GradientAnimationView: UIView, CAAnimationDelegate {
    
    let gradientLayer = CAGradientLayer()
    
    var curentIndex = (start: 1, end: 0)
    
    let colors = [
        UIColor.init(hex: "02386E"),
        UIColor.init(hex: "010280"),
        UIColor.init(hex: "061993"),
        UIColor.init(hex: "0C3BAA"),
        UIColor.init(hex: "135CC5"),
        UIColor.init(hex: "1973D1"),
    ].map { $0!.cgColor}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [colors[curentIndex.start], colors[curentIndex.end]]
        gradientLayer.drawsAsynchronously = true
        layer.addSublayer(gradientLayer)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        animate()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        
        curentIndex = ((curentIndex.start+1) % colors.count, (curentIndex.end+1) % colors.count)
        
        let fromColor = gradientLayer.colors
        let anim = CABasicAnimation(keyPath: "colors")
        anim.delegate = self
        anim.fromValue = fromColor
        anim.toValue = [colors[curentIndex.start], colors[curentIndex.end]]
        anim.duration = 10
//        anim.fillMode = CAMediaTimingFillMode.forwards
//        anim.isRemovedOnCompletion = false
        gradientLayer.add(anim, forKey: "colors")
    }
    
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = [colors[curentIndex.start], colors[curentIndex.end]]
        animate()
        print(#function)
    }
    
}
