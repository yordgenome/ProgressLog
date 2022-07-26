//
//  WorkoutCell.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/22.
//

import UIKit

class WorkoutCell: UITableViewCell {
    //MARK: - Properties
    
    static let identifier = "WorkoutCell"
    
    //MARK: - UIParts
    
    let leftSpaceLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 10
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        label.layer.backgroundColor = UIColor.outColor?.cgColor
        
        return label
    }()
    //
    //    let leftDecoLabel: UILabel = {
    //        let label = UILabel()
    //        label.layer.backgroundColor = UIColor.accentColor?.cgColor
    //        return label
    //    }()
    
    let targetPartLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let volumeTextLabel: UILabel = {
        let label = UILabel()
        label.text = "ボリューム"
        return label
    }()
    
    let TotalVolumeLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let batsuLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let repsLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    //MARK: - LifeCycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let backgroundView = CellBackgroundView()
//        addSubview(backgroundView)
//        backgroundView.frame = self.frame
//        backgroundView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: self.frame.width*7/8, leftPadding: 10)
//        backgroundView.layer.cornerRadius = 10
//        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        let blur = UIBlurEffect()
//        let blurEffectView = UIVisualEffectView(effect: blur)
//        blurEffectView.frame = self.frame
//        addSubview(blurEffectView)
        
        batsuLabel.text = "×"
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.outColor!.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowOffset = .init(width: 1.5, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 6
        backgroundColor = .white
        
        //        targetPartLabel.addBorder(width: 2, color: (.outColor?.withAlphaComponent(0.9))!, position: .bottomRight)
        //        volumeTextLabel.addBorder(width: 2, color: (.outColor?.withAlphaComponent(0.9))!, position: .bottom)
        //        TotalVolumeLabel.addBorder(width: 2, color: (.outColor?.withAlphaComponent(0.9))!, position: .bottom)
        
    }
    
    func setupLayout() {
        addSubview(leftSpaceLabel)
        //        addSubview(leftDecoLabel)
        addSubview(targetPartLabel)
        addSubview(menuLabel)
        addSubview(TotalVolumeLabel)
        addSubview(volumeTextLabel)
        addSubview(weightLabel)
        addSubview(batsuLabel)
        addSubview(repsLabel)
        leftSpaceLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: 10)
        //        leftDecoLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: 5, leftPadding: 5)
        targetPartLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 18, leftPadding: 20)
        menuLabel.anchor(top: targetPartLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 25, leftPadding: 20)
        volumeTextLabel.anchor(top: topAnchor, right: rightAnchor, width: 80, height: 18)
        TotalVolumeLabel.anchor(top: volumeTextLabel.bottomAnchor, right: rightAnchor, width: 80, height: 25)
        weightLabel.anchor(top: TotalVolumeLabel.bottomAnchor, left: leftAnchor, width: 80, height: 20, topPadding: 5, leftPadding: 40)
        batsuLabel.anchor(top: TotalVolumeLabel.bottomAnchor, left: weightLabel.rightAnchor, width: 20, height: 20, topPadding: 5, leftPadding: 20)
        repsLabel.anchor(top: TotalVolumeLabel.bottomAnchor, left: batsuLabel.rightAnchor, width: 60, height: 20, topPadding: 5, leftPadding: 20)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
