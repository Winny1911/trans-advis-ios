//
//  ShowImageVC.swift
//  TA
//
//  Created by Applify  on 02/03/22.
//

import UIKit
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import Photos

class ShowImageVC: BaseViewController {

    @IBOutlet weak var imgVww: UIImageView!

    var imsgeStrURL = ""
    var isImage = false
    var img = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isImage == true {
            imgVww.image = img
        } else {
            self.imsgeStrURL = imsgeStrURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            imgVww.sd_setImage(with: URL(string: imsgeStrURL), placeholderImage: UIImage(named: "doc"), completed:nil)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
