//
//  SentDocumentTableViewCell.swift
//  Business App
//
//  Created by Ankit Goyal on 27/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit

class SentDocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var labelDocumentName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    var didSelectAttachment: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureOnDocument()
    }
    
    func setDocumentMessage(dictionary:ChatMessages) {
        let created_at = Int64(dictionary.message_time ?? "") ?? 0
        let message = dictionary.message ?? ""
        let time = UIFunction.getDateStringForDateSeperatorFromTimestamp(created_at)

        labelDocumentName.text = message
        labelTime.text = time
    }
    
    func addTapGestureOnDocument() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openAttachment))
        self.baseView.isUserInteractionEnabled = true
        self.baseView.addGestureRecognizer(tapGesture)
    }
    
    @objc func openAttachment(_ sender: UITapGestureRecognizer) {
        self.didSelectAttachment?()
    }
}
