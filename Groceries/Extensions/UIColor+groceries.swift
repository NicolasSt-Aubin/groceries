//
//  UIColor+saptest.swift
//  saptest
//
//  Created by Nicolas St-Aubin on 2017-06-02.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Convenience init
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(colorString: String) {
        let hexColorString = colorString.replacingOccurrences(of: "#", with: "0x", options: NSString.CompareOptions.literal, range: nil)
        let scanner = Scanner(string: hexColorString)
        var result : UInt32 = 0
        if scanner.scanHexInt32(&result) {
            self.init(netHex:Int(result))
            return
        }
        self.init()
    }
    
    // MARK: - Public methods
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    // MARK: - Paradym colors
    
    class var flatCloud: UIColor {
        return UIColor(colorString: "#ecf0f1")
    }
    
    class var pageBackgroundColor: UIColor {
        return UIColor(colorString: "#f7f9f9")
    }
    
    class var flatSilver: UIColor {
        return UIColor(colorString: "#bdc3c7")
    }
    
    class var flatPeterRiver: UIColor {
        return UIColor(colorString: "#3498db")
    }
    
    class var flatBelizeHole: UIColor {
        return UIColor(colorString: "#2980b9")
    }
    
    class var flatMidnightBlue: UIColor {
        return UIColor(colorString: "#2c3e50")
    }
    
    class var flatBlack: UIColor {
        return UIColor(colorString: "#222222")
    }
}
