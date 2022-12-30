//
//  MyChatMessageTableViewCell.swift
//  Oryxre Service Provider
//
//  Created by Ankit Goyal on 2019/11/19.
//  Copyright © 2019 Applify Tech Pvt Ltd. All rights reserved.
//

import UIKit
import Nantes
import SafariServices

class MyChatMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var labelMessage: NantesLabel!
    @IBOutlet weak var labelTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        labelMessage.numberOfLines = 0
        if let linkColor = UIColor(named: "#499CDE") {
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: linkColor,
                NSAttributedString.Key.underlineColor: linkColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            labelMessage.linkAttributes = linkAttributes
            labelMessage.delegate = self
        }
    }
    
    func setTextMessage(dictionary: ChatMessages) {
        let message = dictionary.message ?? ""
        let created_at = Int64(dictionary.message_time ?? "") ?? 0
        let time = UIFunction.getDateStringForDateSeperatorFromTimestamp(created_at)

        labelMessage.text = message
        labelTime.text = time
    }
}

// MARK: - Nantes Label Delegates
extension MyChatMessageTableViewCell : NantesLabelDelegate {
   
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL){
        if ["http", "https"].contains(link.scheme?.lowercased() ?? "") {
            let controller = SFSafariViewController(url: link)
            appDelegate().window?.rootViewController?.present(controller, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.open(link)
        }
    }

    func attributedLabel(_ label: NantesLabel, didSelectPhoneNumber phoneNumber: String){
        let number = phoneNumber.removeWhitespace()
        if let url = URL(string: "telprompt://\(number)") {
            let application = UIApplication.shared
            guard application.canOpenURL(url) else {
                return
            }
            application.open(url, options: [:], completionHandler: nil)
        }
    }
}

