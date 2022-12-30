//
//  ProfileTableViewCell.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var blurVwww: UIView!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var vwMainProject: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sentButton: UIButton!
    @IBOutlet weak var viewTransactionButton: UIButton!
    @IBOutlet weak var markCompletedButton: UIButton!
    
    @IBOutlet weak var progressVw: CircularProgressView!
    
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var mainProjectLbl: UILabel!
    @IBOutlet weak var ongoingHOImageView: UIImageView!
    @IBOutlet weak var ongoingHONameLbl: UILabel!
    @IBOutlet weak var ongoingHOTittleLbl: UILabel!
    @IBOutlet weak var ongoingHODescriptionLbl: UILabel!
    
    @IBOutlet weak var markButtonView: UIView!
    // MARK: variable
    let shapeLayer = CAShapeLayer()
    var viewTransactionTapAction : (()->())?
    var approveDeliveryTapAction : (()->())?
    var sendMessageTapAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ongoingHOImageView.setRoundCorners(radius: ongoingHOImageView.frame.height / 2)
        
        viewTransactionButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        markCompletedButton.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        sentButton.addTarget(self, action: #selector(sendMsgbtnTap), for: .touchUpInside)
        
        vwMainProject.roundCorners(corners: [.topRight, .bottomRight], radius:4.0)
        sentButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        sentButton.layer.borderWidth = 1.5
        
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 5.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.cornerRadius = 5.0
        
        //Round Progress Bar
//        let center = progressVw.center
//        let trackLayer = CAShapeLayer()
//        let circularPath = UIBezierPath(arcCenter: center, radius: 15, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
//
//        trackLayer.path = circularPath.cgPath
//        trackLayer.strokeColor = UIColor.lightGray.cgColor
//        trackLayer.lineWidth = 3
//        trackLayer.strokeEnd = 0
//        trackLayer.fillColor = UIColor.clear.cgColor
//        mainView.layer.addSublayer(trackLayer)
//
//
//        shapeLayer.path = circularPath.cgPath
//        shapeLayer.strokeColor = UIColor(named: "#FA9365")?.cgColor
//        shapeLayer.lineWidth = 3
//        shapeLayer.strokeEnd = 0
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineCap = CAShapeLayerLineCap.round
//      //  progressVw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//
//        mainView.layer.addSublayer(shapeLayer)
//
//        let basicAimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAimation.toValue = 0.8
//       // basicAimation.duration = 5
//        basicAimation.fillMode = CAMediaTimingFillMode.forwards
//        basicAimation.isRemovedOnCompletion = false
//        //shapeLayer.add(basicAimation,forKey: "urSoBasic")
//        trackLayer.add(basicAimation,forKey: "urSoBasic")
//
//        let basicAimations = CABasicAnimation(keyPath: "strokeEnd")
//        basicAimations.toValue = 0.8
//        basicAimation.duration = 5
//        basicAimations.fillMode = CAMediaTimingFillMode.forwards
//        basicAimations.isRemovedOnCompletion = false
//        shapeLayer.add(basicAimations,forKey: "urSoBasic")
    }
    
    // MARK: for clourse call
    @objc func btnTapped() {
        print("Tapped!")
        // use our "call back" action to tell the controller the button was tapped
        viewTransactionTapAction?()
    }
    
    // MARK: for clourse call
    @objc func btnTap() {
        print("Tapped!")
        // use our "call back" action to tell the controller the button was tapped
        approveDeliveryTapAction?()
    }
    
    // MARK: for clourse call
    @objc func sendMsgbtnTap() {
        print("Tapped!")
        // use our "call back" action to tell the controller the button was tapped
        sendMessageTapAction?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
