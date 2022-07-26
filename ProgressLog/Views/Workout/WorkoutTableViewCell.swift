//
//  TrainingLogTableViewCell.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
//MARK: - Properties
    
    static let identifier = "WorkoutTableViewCell"
        
//MARK: - UIParts
    
    let leftSpaceLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 10
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        label.layer.backgroundColor = UIColor.outColor?.cgColor
        
        return label
    }()
    
    let leftDecoLabel: UILabel = {
        let label = UILabel()
        label.layer.backgroundColor = UIColor.accentColor?.cgColor
        return label
    }()
    
    let targetPartLabel = WorkoutTableViewLabel(maskedCorner: [.layerMaxXMinYCorner],
                                                backgroundColor: UIColor.outColor!,
                                                textColor: .white,
                                                textAlignment: .left,
                                                fontSize: 12)
    
    let menuLabel = WorkoutTableViewLabel(maskedCorner: [],
                                         backgroundColor: UIColor.outColor!,
                                         textColor: .white,
                                          textAlignment: .left,
                                          fontSize: 18)

    let volumeTextLabel = WorkoutTableViewLabel(maskedCorner: [.layerMinXMinYCorner,.layerMaxXMinYCorner],
                                                backgroundColor: .white,
                                               textColor: UIColor.outColor!,
                                               textAlignment: .center,
                                                text: "総負荷",
                                                fontSize: 12)
    
    let TotalVolumeLabel = WorkoutTableViewLabel(maskedCorner: [],
                                                 backgroundColor: .white,
                                                 textColor: UIColor.outColor!,
                                                 textAlignment: .center,
                                                 fontSize: 18)
    
    let weightLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .clear,
                                            textColor: UIColor.outColor!,
                                            textAlignment: .center,
                                            fontSize: 18)
    
    let batsuLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .clear,
                                           textColor: UIColor.outColor!,
                                           textAlignment: .center,
                                           fontSize: 18)
    
    let repsLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .clear,
                                          textColor: UIColor.outColor!,
                                          textAlignment: .center,
                                          fontSize: 18)
  
//    let addLogButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "plus.circle.fill")?.resize(size: CGSize(width: 40, height: 40)), for: .normal)
//        button.tintColor = .baseColor
//        button.layer.cornerRadius = 10
//        button.layer.maskedCorners = [.layerMaxXMinYCorner]
//        button.layer.backgroundColor = UIColor.outColor!.cgColor
//        return button
//    }()
    
    
//MARK: - LifeCycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.contentView.layer.cornerRadius = 10
//        self.layer.masksToBounds = true
        
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
        volumeTextLabel.addBorder(width: 2, color: (.outColor?.withAlphaComponent(0.9))!, position: .bottom)
        TotalVolumeLabel.addBorder(width: 2, color: (.outColor?.withAlphaComponent(0.9))!, position: .bottom)
        
    }
    
    func setupLayout() {
        addSubview(leftSpaceLabel)
        addSubview(leftDecoLabel)
        addSubview(targetPartLabel)
        addSubview(menuLabel)
        addSubview(TotalVolumeLabel)
        addSubview(volumeTextLabel)
        addSubview(weightLabel)
        addSubview(batsuLabel)
        addSubview(repsLabel)
        leftSpaceLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: 15)
        leftDecoLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: 5, leftPadding: 5)
        targetPartLabel.anchor(top: topAnchor, left: leftSpaceLabel.rightAnchor, right: rightAnchor, height: 18)
        menuLabel.anchor(top: targetPartLabel.bottomAnchor, left: leftSpaceLabel.rightAnchor, right: rightAnchor, height: 25)
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

//MARK: - WorkoutTableViewLabel
class WorkoutTableViewLabel: UILabel {
    
    init(maskedCorner: CACornerMask,
         borderWidth: CGFloat = 2,
         borderColor: UIColor = UIColor.baseColor!,
         borderPosition: BorderPosition = .none,
         backgroundColor: UIColor, textColor: UIColor,
         textAlignment: NSTextAlignment,
         text: String = "",
         fontSize: CGFloat) {
        
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = maskedCorner
        self.layer.masksToBounds = true
        self.layer.backgroundColor = backgroundColor.cgColor
        self.addBorder(width: borderWidth, color: borderColor, position: borderPosition)
        self.textColor = textColor
        self.text = text
        self.font = UIFont(name: "GeezaPro", size: fontSize)
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

