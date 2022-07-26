//
//  UIColor-Extension.swift
//  ProgressLog
//
//  Created by Yo Tahara on 2022/07/18.
//

import UIKit

extension UIColor{
    
    static let baseColor = UIColor(hex: "189AA7")
    static let secondColor = UIColor(hex: "21C4D3")
    static let accentColor = UIColor(hex: "F9ECE4")
    static let outColor = UIColor(hex: "304655")
   
    
    static let startColor = UIColor(hex: "#189AA7")
    static let endColor = UIColor.white
    
    
    // HEXカラーコードからUIColorを生成するイニシャライザ
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

