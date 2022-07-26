//
//  MuscleFooterView.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/18.
//

import UIKit

class TabFooterView: UIView {
    
    let gradientView = SecondGradientView()
//    let homeView = TabFooterButton(frame: .zero, width: 50, imageName: "house.fill", text: "ホーム", labelWidth: 30)
//    let chartView = TabFooterButton(frame: .zero, width: 50, imageName: "chart.bar.xaxis", text: "グラフ", labelWidth: 30)
//    let workoutView = TabFooterButton(frame: .zero, width: 60, imageName: "rectangle.and.pencil.and.ellipsis", text: "トレーニング記録", labelWidth: 80)
//    let noView = TabFooterButton(frame: .zero, width: 50, imageName: "heart.fill", text: "なにか", labelWidth: 30)
//    let menuView = TabFooterButton(frame: .zero, width: 50, imageName: "cube.fill", text: "種目", labelWidth: 30)
  
    let homeView = TabFooterButton(frame: .zero, width: 50, imageName: "house.fill")
    let chartView = TabFooterButton(frame: .zero, width: 50, imageName: "chart.bar.xaxis")
    let workoutView = TabFooterButton(frame: .zero, width: 60, imageName: "rectangle.and.pencil.and.ellipsis")
    let noView = TabFooterButton(frame: .zero, width: 50, imageName: "heart.fill")
    let menuView = TabFooterButton(frame: .zero, width: 50, imageName: "cube.fill")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        gradientView.frame = UIScreen.main.bounds
        addSubview(gradientView)

        let baseStackView = UIStackView(arrangedSubviews: [homeView, chartView, workoutView, noView, menuView])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 10
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(baseStackView)
    
        baseStackView.anchor(left: leftAnchor, right: rightAnchor, centerY: centerYAnchor, leftPadding: 10, rightPadding: 10)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TabFooterButton: UIView {
    
//    var label = UILabel()
    var button: BottomButton?
    //, text: String, labelWidth: CGFloat
    init(frame: CGRect, width: CGFloat, imageName: String) {
        super.init(frame: frame)
        
        button = BottomButton(type: .system)
        //UIImageを拡張メソッドでリサイズ
        button?.setImage(UIImage(systemName: imageName)?.resize(size: .init(width: width*0.6, height: width*0.6)), for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.tintColor = .baseColor
        button?.backgroundColor = .white
        button?.layer.cornerRadius = width/2
        button?.layer.borderColor = UIColor.baseColor?.cgColor
        button?.layer.borderWidth = 1
        button?.layer.shadowOffset = .init(width: 1.5, height: 2)
        button?.layer.shadowColor = UIColor.black.cgColor
        button?.layer.shadowOpacity = 0.5
        button?.layer.shadowRadius = 15
        
//        label.text = text
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.layer.cornerRadius = 3
//        label.layer.backgroundColor = UIColor.secondColor?.cgColor
//        label.textColor = UIColor.white

        addSubview(button!)
//        addSubview(label)
        
        button?.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: width, height: width)
//        label.anchor(top: button?.bottomAnchor, centerX: centerXAnchor,  width: labelWidth, height: 14, topPadding: -10)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BottomButton: UIButton {
    
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

