//
//  GBTxtViewDoc.swift
//  TA
//
//  Created by Dev on 05/04/22.
//

import Foundation

//private func setPlaceholderLabel(){
//    self.isSetupPlaceholder = true
//    self.tintColor = UIColor.black
//    print(self.text)
//    placeholderLabel.text = placeholder
//    placeholderLabel.textColor = placeholderColor ?? .lightGray
//    placeholderLabel.textAlignment = self.textAlignment
//    self.superview?.addSubview(placeholderLabel)
//    placeholderLabel.font = self.font
//    if self.font == nil{
//        placeholderLabel.font = UIFont.systemFont(ofSize: 18)
//    }
//    constraintPlaceholderLabelTop = placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
//    constraintPlaceholderLabelTop.isActive = true
//    if isFloatingLabel{
//        constraintPlaceholderLabelTop.constant = 15
//    }
//    placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14).isActive = true
//    if placeholderLabel.text == " Write your Message" {
//        placeholderLabel.numberOfLines = 1
//        placeholderLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -130).isActive = true
//    }
      //Updated code:----------
//    else {
//       placeholderLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -150).isActive = true
//    }
//    if placeholderLabel.text == "About me"{
//        placeholderLabel.numberOfLines = 1
//        placeholderLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -220).isActive = true
//    }
//
//    if self.text.count > 0{
//        if !isFloatingLabel{
//            self.placeholderLabel.isHidden = true
//        }
//        self.refreshPlaceholder()
//    }
//}


//MARK:-  Notification
//@objc func refreshPlaceholder(){
//    DispatchQueue.main.async {
//        if self.text.count > 0{
//            if self.isFloatingLabel{
//                if self.constraintPlaceholderLabelTop.constant != 0{
//                    self.placeholderLabel.animate(font: UIFont(name: "Poppins-Medium", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), duration: 0.5)
//                    self.constraintPlaceholderLabelTop.constant = -12
//                    self.placeholderLabel.backgroundColor = .white
//                    self.placeholderLabel.textColor = self.selectedColor
//                    UIView.animate(withDuration: 0.5, animations: {
//                        self.superview?.layoutIfNeeded()
//                    })
//
//                }
//            }
            //Updated Code:-------
//            else{
//                self.placeholderLabel.isHidden = false
//                self.placeholderLabel.animate(font: UIFont(name: "Poppins-Medium", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), duration: 0.5)
//                self.placeholderLabel.textColor = self.selectedColor
//
//            }
//        }else{
//            if self.isFloatingLabel{
//                self.placeholderLabel.animate(font: self.font ?? UIFont.systemFont(ofSize: 18), duration: 0.5)
//                self.constraintPlaceholderLabelTop.constant = 16
//                self.placeholderLabel.backgroundColor = .clear
//                self.placeholderLabel.textColor = self.placeholderColor
//                UIView.animate(withDuration: 0.5) {
//                    self.superview?.layoutIfNeeded()
//                }
//            }else{
//                self.placeholderLabel.textColor = self.placeholderColor
//                self.placeholderLabel.isHidden = false
//            }
//        }
//    }
//}

