//
//  UITextField.swift
//  Fitsentive
//
//  Created by karan dhiman on 19/07/21.
//

import Foundation
import UIKit

extension UITextView {
    func setLeftPadding(_ amount:CGFloat){
        self.textContainerInset = UIEdgeInsets(top: 15, left: amount, bottom: 5, right: 5);
    }
}

extension UITextField {
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightPaddingIconLocation(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 24.0, height: 18.0))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 3, left:5, bottom: 0, right: 40)
        self.rightViewMode = .always
        self.rightView = btnView
    }
    
    func setRightPaddingIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * 0.70), height: ((self.frame.height) * 0.70)))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left:5, bottom: 0, right: 40)
        self.rightViewMode = .always
        self.rightView = btnView
    }
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
