//
//  ChatImageTableViewCell.swift
//  Oryxre Service Provider
//
//  Created by Ankit Goyal on 2019/11/20.
//  Copyright © 2019 Applify Tech Pvt Ltd. All rights reserved.
//

import UIKit
import SDWebImage

class ChatImageTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageViewAttachment: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    var didSelectAttachment: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureOnImage()
    }

    func addTapGestureOnImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openAttachment))
        self.baseView.isUserInteractionEnabled = true
        self.baseView.addGestureRecognizer(tapGesture)
    }
    
    func setAttachmentMessage(dictionary: ChatMessages) {
        let created_at = Int64(dictionary.message_time ?? "") ?? 0
        let message = dictionary.attachment_url ?? ""
        let time = UIFunction.getDateStringForDateSeperatorFromTimestamp(created_at)
        
        labelTime.text = time
        if (message.isServerImage()) {
            imageViewAttachment.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageViewAttachment.sd_setImage(with: URL(string: message), placeholderImage: nil)
        }
    }
    
    @objc func openAttachment(_ sender: UITapGestureRecognizer) {
        self.didSelectAttachment?()
    }
}
