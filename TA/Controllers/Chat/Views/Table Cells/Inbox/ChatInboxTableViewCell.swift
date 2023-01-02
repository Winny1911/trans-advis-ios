//
//  ChatInboxTableViewCell.swift
//  Business App
//
//  Created by Ankit Goyal on 20/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit
import SDWebImage


class ChatInboxTableViewCell: UITableViewCell
{
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var labeluserName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLastMessage: UILabel!
    @IBOutlet weak var viewUnReadMessage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = UIColor(hex: "#DADDE3")?.cgColor
    }
    
    func setInboxMessage(dictionary: ChatInbox) {
        let user_id = UIFunction.getCurrentUserId()
        let participant_ids = dictionary.participant_ids
        let other_user_id = UIFunction.getOtherUserId(from: participant_ids) ?? ""
        let profile_pic = dictionary.profile_pic?.asDictionary()
        let name = dictionary.name?.asDictionary()
        let unread_count = dictionary.unread_count?.asDictionary()

        let user_image = profile_pic?.objectForKeyAsString(key: other_user_id) ?? ""
        let user_name = name?.objectForKeyAsString(key: other_user_id)  ?? ""
        let updated_at = Int64(dictionary.last_message_time  ?? "0") ?? 0
        let read_count = Int(unread_count?.objectForKeyAsString(key: user_id) ?? "") ?? 0
        let last_message = (dictionary.last_message ?? "").replacingOccurrences(of: "\n", with: " ")
        let date = self.getDateString(timestamp: updated_at)
        
        if (user_image.isServerImage()) {
            // image from url
            self.userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.userImageView.sd_setImage(with: URL(string: user_image), placeholderImage: nil)
            self.userImageView.contentMode = .scaleAspectFill
        }
        else {
            self.userImageView.image = UIImage(named: "Ic_profile")
            self.userImageView.contentMode = .center
        }
        
        self.labeluserName.text = user_name
        self.labelDate.text = date
        self.labelLastMessage.text = last_message
        
        
        if (read_count > 0) {
            self.viewUnReadMessage.layer.cornerRadius = self.viewUnReadMessage.frame.size.height/2.0
            self.viewUnReadMessage.alpha = 1
        }
        else {
            self.viewUnReadMessage.alpha = 0
        }
    }
}


// MARK: - Date
extension ChatInboxTableViewCell {
 
    func getDateString(timestamp: Int64) -> String {
        let messageDateFormatter: DateFormatter = DateFormatter()
        var messageDate: Date?
        if String(format: "%lld", timestamp).count == 10 {
            messageDate = Date.init(timeIntervalSince1970: TimeInterval(timestamp))
        }
        else {
            messageDate = Date.init(timeIntervalSince1970: TimeInterval(Double(timestamp) / 1000.0))
        }
        
        if (!(messageDate as AnyObject).isKind(of: NSDate.self)) {
            return ""
        }
        
        messageDateFormatter.dateStyle = .long
        messageDateFormatter.timeStyle = .short
        messageDateFormatter.doesRelativeDateFormatting = true
        messageDateFormatter.timeZone = TimeZone.current

        let calendar = Calendar.current
        if (calendar.isDateInToday(messageDate!) == true) { // today
            messageDateFormatter.dateStyle = .none
            messageDateFormatter.dateFormat = "HH:mm"
            let today_date = messageDateFormatter.string(from: messageDate!)
            return today_date
        }
        else if (calendar.isDateInYesterday(messageDate!) == true)  { // yesterday
            messageDateFormatter.timeStyle = .none
            let yesterday_date = messageDateFormatter.string(from: messageDate!)
            return yesterday_date
        }
        else {
            messageDateFormatter.dateFormat = "yyyy/MM/dd"
            messageDateFormatter.locale = Locale(identifier: "en_US")
            messageDateFormatter.timeStyle = .none
            let aWeekAgoString = convertDateFormater(messageDate!)
            return aWeekAgoString
        }
    }
    
    func convertDateFormater(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date)
    }
}
