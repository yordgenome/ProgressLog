//
//  HomeHeader.swift
//  ProgressLog
//
//  Created by 田原葉 on 2022/09/06.
//

import UIKit

class HomeHeader: UIView {
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        backgroundColor = .outColor

        addSubview(imageView)
        imageView.anchor(top: safeAreaLayoutGuide.topAnchor, centerX: centerXAnchor, width: 30, height: 30, topPadding: 5)
        
    }
}
