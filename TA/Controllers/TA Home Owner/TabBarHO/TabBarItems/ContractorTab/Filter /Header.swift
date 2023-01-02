//
//  Header.swift
//  ExpandTableCell
//
//  Created by Dev on 26/08/21.
//

import Foundation
import UIKit

class Header: UIView {
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    
    //@IBOutlet weak var sectionLabel: UILabel!
//    @IBOutlet var contentView: UIView!
//    @IBOutlet weak var tapButton: UIButton!
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        loadNib()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        loadNib()
//
//    }
//    func loadNib(){
//        Bundle.main.loadNibNamed("Header", owner: self, options: nil)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//    }
}
