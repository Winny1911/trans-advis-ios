//
//  AttachmentListTableViewCell.swift
//  TA
//
//  Created by iOS on 15/09/22.
//

import UIKit

class AttachmentListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var showImageButton: UIButton!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var attachmentDeleteButton: UIButton!
    @IBOutlet weak var attachmentLabel: UILabel!

    var deleteAttachment : (() -> ())?
    var showImageOnFullView : (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.addCustomShadow()
        self.attachmentDeleteButton.addTarget(self, action: #selector(deleteAttchment), for: .touchUpInside)
        self.showImageButton.addTarget(self, action: #selector(showImage), for: .touchUpInside)
        // Initialization code
    }

    @objc func deleteAttchment() {
        self.deleteAttachment?()
    }

    @objc func showImage() {
        self.showImageOnFullView?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
