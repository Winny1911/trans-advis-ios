////
////  FloatingLabelInput.swift
////  FloatingLabelInput
////
////  Created by Mark Boleigha on 09/10/2019.
////  Copyright © 2019 Sprinthub Mobile. All rights reserved.
////
//
import UIKit

class FloatingLabelInput: UITextField {
    var floatingLabel: UILabel!// = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    
    var _placeholder: String?
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    var ticketTop : NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        if self.floatingLabel == nil {
            self.addFloatingLabel()
        }
        self.addTarget(self, action: #selector(self.resetFloatingLable), for: [.editingDidEnd, .editingChanged])
    }
    
//    // Add a floating label to the view on becoming first responder
    func addFloatingLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(named: "#B2B2B2")!,
            .font: self.font!
        ]
        self.attributedPlaceholder = NSAttributedString(string: self._placeholder ?? "", attributes: attributes)
    }
    
    @objc func resetFloatingLable() {
        DispatchQueue.main.async {
            self.ticketTop?.isActive = false
            
            if self.text?.isEmpty ?? true {
                self.ticketTop = self.floatingLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            } else {
                self.ticketTop = self.floatingLabel?.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5)
            }
            
            self.ticketTop?.isActive = true
            
            UIView.animate(withDuration: 0.2) {
                if let view = self.superview {
                    view.layoutIfNeeded()
                }
            }
        }
    }
}

