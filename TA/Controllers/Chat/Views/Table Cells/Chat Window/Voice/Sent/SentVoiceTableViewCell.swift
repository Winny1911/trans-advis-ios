//
//  SentVoiceTableViewCell.swift
//  Business App
//

import UIKit
import WebKit

class SentVoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var labelVoiceName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var wkWebview: WKWebView!
    @IBOutlet weak var imgVoice: UIImageView!
    
    var didSelectAttachment: (() -> Void)?
    var request: URLRequest!

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureOnVoice()
    }
    
    func setVoiceMessage(dictionary:ChatMessages) {
        let created_at = Int64(dictionary.message_time ?? "") ?? 0
        let message = dictionary.message ?? ""
        let time = UIFunction.getDateStringForDateSeperatorFromTimestamp(created_at)
        labelVoiceName.text = message
        labelTime.text = time
        
        guard let url = URL(string: dictionary.attachment_url!) else { return }
        request = URLRequest(url: url)
        wkWebview.isHidden = true
        imgVoice.isHidden = false
        
    }
    
    func addTapGestureOnVoice() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openAttachment))
        self.baseView.isUserInteractionEnabled = true
        self.baseView.addGestureRecognizer(tapGesture)
    }
    
    @objc func openAttachment(_ sender: UITapGestureRecognizer) {
        //self.didSelectAttachment?()
        wkWebview.isHidden = false
        imgVoice.isHidden = true
        wkWebview.load(request)
    }
}
