//
//  String.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import Foundation
import UIKit
import CommonCrypto
import MobileCoreServices
extension String {
    var isLocalImageUrl: Bool {
        return !self.contains("http") && !self.contains("www.") && self.contains("LocalImg_")
    }
}

extension String {
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    var isValidEmailAddress: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return testEmail.evaluate(with: self)
    }
    
    var isValidFirstName: Bool {
        return !isEmpty && self.count >= 3 && self.count <= 50
    }
    
    var isValidCompanyName: Bool {
        return !isEmpty && self.count >= 3 && self.count <= 50
    }
    
    var isValidProjectTitle: Bool {
        return !isEmpty && self.count >= 3 && self.count <= 100
    }
    
    var isValidProjectDesc: Bool {
        return !isEmpty && self.count >= 3 && self.count <= 1000
    }
    
    var isValidLastName: Bool {
        return !isEmpty && self.count >= 3 && self.count <= 50
    }
    
    var isValidPhoneNumber: Bool {
        return !isEmpty && self.count >= 8 && self.count <= 13
    }
    
    var isValidLicence: Bool{
        return isEmpty && self.count <= 20
    }
    
    var isPhoneNumber: Bool {
        let PHONE_REGEX = "^[0-9][0-9]{8,12}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }

    var isValidName: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9_. ]", options: .regularExpression) == nil
    }
    
    var isValidNameCount: Bool {
        return !isEmpty && self.count >= 3 && self.count <= 50
    }
    
    var isValidAccountNameCount: Bool {
        return !isEmpty && self.count == 16
    }
    
    var isValidBankCodeCount: Bool {
        return  !isEmpty && self.count >= 3 && self.count <= 30
    }
    
    var isValidBankName: Bool {
        return  !isEmpty && self.count <= 15
    }
    
    var isValidNameCharactersOnly: Bool {
        return !isEmpty && range(of: ".*[^A-Za-z].*", options: .regularExpression) == nil
    }
    
    var isValidPhone: Bool {
        return self.count > 8 && self.count < 14 && isDigits
    }
    
    var isValidTextViewCount: Bool {
        return self.count >= 20 && self.count < 501
    }
    
    var isValidPassword: Bool {
        return !isEmpty && self.count >= 8 && self.count <= 20
    }

    var isValidRouting: Bool {
        return !isEmpty && self.count <= 9
    }
    var isValidSSN: Bool {
        return !isEmpty && self.count == 9
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        if rangeOfCharacter(from: notDigits,
                            options: String.CompareOptions.literal,
                            range: nil) == nil {
            return true
        }
        return false
    }
    
    var isContainsNumericAndSpecialCharacters: Bool {
        let numbers = CharacterSet.decimalDigits
        let punctuationChar = CharacterSet.punctuationCharacters
        
        if self.rangeOfCharacter(from: numbers) == nil || self.rangeOfCharacter(from: punctuationChar) == nil {
            return false
        }
        return true
    }
    
    var isValidAccountNumber: Bool {
        return !isEmpty && self.count >= 10 && self.count <= 20
    }
    
    func isValidUrl() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            // check if the string has link inside
            return detector.numberOfMatches(in: self, options: [], range: .init( location: 0, length: utf16.count)) > 0
        } catch {
            print("Error during NSDatadetector initialization \(error)" )
        }
        return false
    }
    
}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }

    func subString(at: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: at)
        let endIndex = self.index(self.startIndex, offsetBy: at)
        return String(self[startIndex...endIndex])
    }
}

extension String {
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
}

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    var boolValue: Bool {
        return self == "true" || self == "1" || self == "YES"
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineHeight: CGFloat = 20) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func size(with font: UIFont, maxWidth: CGFloat = 1000, lineHeight: CGFloat = 20) -> CGSize {
        let height = self.height(withConstrainedWidth: maxWidth, font: font, lineHeight: lineHeight)
        let width = self.width(withConstrainedHeight: height, font: font)
        let size = CGSize(width: width, height: height)
        return size
    }
}

// MARK: - String Extension for chat
extension String {
    func isServerImage() -> Bool {
        if self.hasPrefix("http") || self.hasPrefix("https") {
            return true
        } else {
            return false
        }
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

// MARK: - Trim
extension String {
    func trim() -> String {
       return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    func formatPhone(with mask: String) -> String {
        let digits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = digits.startIndex
        
        for character in mask {
            if index == digits.endIndex {
                break
            }
            if character == "X" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
}
