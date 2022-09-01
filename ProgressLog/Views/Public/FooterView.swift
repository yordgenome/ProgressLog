//
//  MuscleFooterView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/10.
//

import UIKit

class FooterView: UIView {
    let gradientView = SecondGradientView()
    
        let homeView = FooterButtonView(frame: .zero, width: 50, imageName: "house.fill", text: "ホーム", labelWidth: 30)
        let chartView = FooterButtonView(frame: .zero, width: 50, imageName: "chart.bar.xaxis", text: "グラフ", labelWidth: 30)
        let workoutView = FooterButtonView(frame: .zero, width: 50, imageName: "rectangle.and.pencil.and.ellipsis", text: "記録", labelWidth: 30)
        let menuView = FooterButtonView(frame: .zero, width: 50, imageName: "heart.fill", text: "種目", labelWidth: 30)
        let selfView = FooterButtonView(frame: .zero, width: 50, imageName: "cube.fill", text: "設定", labelWidth: 30)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        gradientView.frame = UIScreen.main.bounds
        addSubview(gradientView)

        let baseStackView = UIStackView(arrangedSubviews: [homeView, chartView, workoutView, menuView, selfView])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 10
        baseStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(baseStackView)
        baseStackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, leftPadding: 10, rightPadding: 10)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FooterButtonView: UIView {
    var label = UILabel()

    var button: FooterButton?
    
    init(frame: CGRect, width: CGFloat, imageName: String, text: String, labelWidth: CGFloat) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        button = FooterButton(type: .system)
        //UIImageを拡張メソッドでリサイズ
        button?.setImage(UIImage(systemName: imageName)?.resize(size: .init(width: width*0.7, height: width*0.7)), for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.tintColor = .white
        button?.backgroundColor = .baseColor
        button?.layer.cornerRadius = 10
        button?.layer.shadowOffset = .init(width: 1.5, height: 2)
        button?.layer.shadowColor = UIColor.black.cgColor
        button?.layer.shadowOpacity = 0.5
        button?.layer.shadowRadius = 15
        
        addSubview(button!)
        button?.anchor(top: topAnchor, centerX: centerXAnchor, width: width, height: width, topPadding: 10)

        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)

        addSubview(label)
        label.anchor(bottom: button!.bottomAnchor, centerX: centerXAnchor,  width: labelWidth, height: 14)
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FooterButton: UIButton {
    
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
