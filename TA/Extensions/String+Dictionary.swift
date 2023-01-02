//
//  String+Dictionary.swift
//  TA
//
//  Created by global on 05/04/22.
//

import UIKit

extension NSDictionary {
    func asJSONString() -> String? {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText
        }
        return ""
    }
}

extension String {
    func asDictionary() -> NSDictionary? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension NSMutableAttributedString {

    open func addAttributes(
        primaryString: String,
        primaryColor: UIColor,
        primaryFont: UIFont,
        secondaryStrings: [String],
        secondaryColor: UIColor,
        secondaryFont: UIFont) -> NSMutableAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: primaryFont,
            NSAttributedString.Key.foregroundColor: primaryColor]
        let string = NSAttributedString(string: primaryString, attributes: attributes)

        self.append(string)
        for string in secondaryStrings {
            let range: NSRange = self.mutableString.range(of: string, options: .caseInsensitive)
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: secondaryFont,
                NSAttributedString.Key.foregroundColor: secondaryColor]
            self.setAttributes(attributes, range: range)
        }
        return self
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
