//
//  Color.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import Foundation
import UIKit

extension UIColor {
    
    class var appBlack: UIColor {
        return UIColor(hex: "##1F1F1F")!
    }
    
    class var appBtnColorOrange: UIColor {
        return UIColor(hex: "##FA9365")!
    }
    
    class var appBtnColorGrey: UIColor {
        return UIColor(hex: "##B2B2B2")!
    }
    class var appColorGreen: UIColor {
        return UIColor(hex: "##4EC72A")!
    }
    
    class var appColorBlue: UIColor {
        return UIColor(hex: "##499CDE")!
    }

    class var appBtnColorWhite: UIColor {
        return UIColor(hex: "##FFFFFF")!
    }
    
    class var appColorGrey: UIColor {
        return UIColor(hex: "##E0E0E0")!
    }
    class var appColorText: UIColor {
        return UIColor(hex: "##484848")!
    }
    class var appSelectedBlack: UIColor {
        return UIColor(hex: "##4F515D")!
    }
    
    class var appUnSelectedBlack: UIColor {
        return UIColor(hex: "##9B9B9B")!
    }
    
    class var appUnSelectedgrey: UIColor {
        return UIColor(hex: "##E8E8E8")!
    }
    
    class var appFloatText: UIColor {
        return UIColor(hex: "##767676")!
    }
    
    class var appBtnRed: UIColor {
        return UIColor(hex: "##EF4545")!
    }
}

extension UIColor {
    var hexString: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }

    public convenience init?(hex: String) {
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        let alpha: CGFloat = 1.0
        let red: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 4, length: 2)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        return
    }
    
    private static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
}

extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
    
    class func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat)-> UIColor{
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: a)
        return color
    
    }
}
