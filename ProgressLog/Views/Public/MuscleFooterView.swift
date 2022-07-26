//
//  MuscleFooterView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/10.
//

import UIKit

class MuscleFooterView: UIView {
    
    let homeView = MuscleFooterButton(frame: .zero, width: 50, imageName: "house.fill")
    let chartView = MuscleFooterButton(frame: .zero, width: 50, imageName: "chart.bar.xaxis")
    let workoutView = MuscleFooterButton(frame: .zero, width: 60, imageName: "rectangle.and.pencil.and.ellipsis")
    let menuView = MuscleFooterButton(frame: .zero, width: 50, imageName: "heart.fill")
    let boostView = MuscleFooterButton(frame: .zero, width: 50, imageName: "cube.fill")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue


        let baseStackView = UIStackView(arrangedSubviews: [homeView, chartView, workoutView, menuView, boostView])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 10
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(baseStackView)
    
        baseStackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, centerY: centerYAnchor, leftPadding: 10, rightPadding: 10)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MuscleFooterButton: UIView {
    
    var button: BottomButton?
    
    init(frame: CGRect, width: CGFloat, imageName: String) {
        super.init(frame: frame)
        
        button = BottomButton(type: .system)
        //UIImageを拡張メソッドでリサイズ
        button?.setImage(UIImage(systemName: imageName)?.resize(size: .init(width: width*0.6, height: width*0.6)), for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.tintColor = .endColor
        button?.backgroundColor = .white
        button?.layer.cornerRadius = width/2
        button?.layer.shadowOffset = .init(width: 1.5, height: 2)
        button?.layer.shadowColor = UIColor.black.cgColor
        button?.layer.shadowOpacity = 0.5
        button?.layer.shadowRadius = 15
        
        addSubview(button!)
        
        button?.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: width, height: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MuscleBottomButton: UIButton {
    
    //ボタンを押しているときに縮小拡大するアニメーション
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: []) {
                    //ハイライトになっている時、大きさを0.8倍に
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                    self.layoutIfNeeded()
                }
            } else {
                //ハイライトが消えると、元の大きさに
                self.transform = .identity
                self.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
