//
//  ReceivedVoiceTableViewCell.swift
//  Business App

import UIKit

class ReceivedVoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var labelVoiceName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imgViewVoice: UIImageView!
    var didSelectAttachment: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureOnVoice()
        changeImgVoice()
    }
    
    func changeImgVoice() {
        imgViewVoice.image = UIImage(named: "document")
    }
    
    func addTapGestureOnVoice() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openAttachment))
        self.baseView.isUserInteractionEnabled = true
        self.baseView.addGestureRecognizer(tapGesture)
    }
    
    func setVoiceMessage(dictionary: ChatMessages) {
        let created_at = Int64(dictionary.message_time ?? "") ?? 0
        let message = dictionary.message ?? ""
        let time = UIFunction.getDateStringForDateSeperatorFromTimestamp(created_at)
        
        labelVoiceName.text = message
        labelTime.text = time
    }
    
    @objc func openAttachment(_ sender: UITapGestureRecognizer) {
        self.didSelectAttachment?()
    }
}
