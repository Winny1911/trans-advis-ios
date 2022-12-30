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
        self.addTarget(self, action: #selector(self.resetFloatingLable), for: .editingDidEnd)
        self.addTarget(self, action: #selector(self.resetFloatingLable), for: .editingChanged)
    }

    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.floatingLabel.textColor = UIColor.init(named: "#B2B2B2")
        self.floatingLabel.font = self.font
        self.floatingLabel.text = " " + (self._placeholder ?? "") + "  "
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.textAlignment = .center
        self.addSubview(self.floatingLabel)
        //            self.layer.borderColor = self.activeBorderColor.cgColor
        
        self.floatingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14).isActive = true
        
        ticketTop = self.floatingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        ticketTop?.isActive = true
        self.placeholder = ""
        
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    @objc func resetFloatingLable() {
        
        ticketTop?.isActive = false
        
        if self.text?.isEmpty ?? true {
            ticketTop = self.floatingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0) // Place our label -- pts above the text field
            self.floatingLabel.layer.backgroundColor = UIColor.clear.cgColor
            self.floatingLabel.textColor = UIColor.init(named: "#B2B2B2")

        } else {
            ticketTop = self.floatingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -(self.frame.height / 2)) // Place our label -- pts above the text field
            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
            self.floatingLabel.textColor = UIColor.init(named: "#767676")
        }
        
        ticketTop?.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}

