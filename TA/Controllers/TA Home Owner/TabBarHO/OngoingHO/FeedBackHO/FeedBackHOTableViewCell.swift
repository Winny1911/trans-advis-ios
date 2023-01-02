//
//  FeedBackHOTableViewCell.swift
//  TA
//
//  Created by applify on 03/03/22.
//

import UIKit

class FeedBackHOTableViewCell: UITableViewCell {
    var btnTapAction1 : (()->())?
    var btnTapAction2 : (()->())?
    var btnTapAction3 : (()->())?
    var btnTapAction4 : (()->())?
    var btnTapAction5 : (()->())?

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btn1.addTarget(self, action: #selector(tabButtonOne), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(tabButtonTwo), for: .touchUpInside)
        btn3.addTarget(self, action: #selector(tabButtonThree), for: .touchUpInside)
        btn4.addTarget(self, action: #selector(tabButtonFour), for: .touchUpInside)
        btn5.addTarget(self, action: #selector(tabButtonFive), for: .touchUpInside)
        
        // Configure the view for the selected state
    }
    @objc func tabButtonOne(){
        btnTapAction1?()
    }
    @objc func tabButtonTwo(){
        btnTapAction2?()
    }
    @objc func tabButtonThree(){
        btnTapAction3?()
    }
    @objc func tabButtonFour(){
        btnTapAction4?()
    }
    @objc func tabButtonFive(){
        btnTapAction5?()
    }
    
}
