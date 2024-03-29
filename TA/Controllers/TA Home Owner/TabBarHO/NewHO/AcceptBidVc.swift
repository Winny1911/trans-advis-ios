//
//  AcceptBidVc.swift
//  TA
//
//  Created by applify on 05/01/22.
//

import UIKit

class AcceptBidVc: BaseViewController {
    
    @IBOutlet weak var lblTopHeading: UILabel!
    @IBOutlet weak var yesConfirmButton: UIButton!
    @IBOutlet weak var notYetButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var viewModel : RejectBidVM = RejectBidVM()
    var acceptBid : RejectBidModel?
    var projectId = Int()
    var bidId = Int()
    var completionHandlerGoToAgreementScreen : (() -> Void)?
    var budget = "0"
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var realAmount = "\(budget)"
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal

        let amount = Double(realAmount)
        let formattedString = formatter.string(for: amount)
        budget =  formattedString ?? ""
        let amountString = budget == "0" ? "" : "$\(budget)"
        lblTopHeading.text = "Are you sure you want to accept bid amount \(amountString)?"
        notYetButton.setRoundCorners(radius: 6.0)
        yesConfirmButton.setRoundCorners(radius: 6.0)
        bgView.setRoundCorners(radius: 18.0)
        setAttributedLabel()
     }
    
    func setAttributedLabel() {
        let amountString = budget == "0" ? "" : "$\(budget)"
        let myString = "Are you sure you want to accept bid amount \(amountString)?"
        let attrStri = NSMutableAttributedString.init(string:myString)
           let nsRange = NSString(string: myString).range(of: budget, options: String.CompareOptions.caseInsensitive)
           attrStri.addAttributes([NSAttributedString.Key.font: UIFont.init(name: PoppinsFont.semiBold, size: 16.0) as Any], range: nsRange)
           self.lblTopHeading.attributedText = attrStri
    }
    
    func acceptBidApiHit(){
        let params = ["projectId":"\(self.projectId)","bidId": "\(self.bidId)","status": "1" ]
        self.viewModel.rejectOrAcceptBidApiCall(params){ model in
            showMessage(with: SucessMessage.bidAcceptSuccessfully, theme: .success)
            self.dismiss(animated: true)
            self.completionHandlerGoToAgreementScreen?()
        }
    }
    
    @IBAction func yesConfirmButtonAction(_ sender: Any) {
//        acceptBidApiHit()
        self.dismiss(animated: true)
        self.completionHandlerGoToAgreementScreen?()
    }
    
    @IBAction func actionNotYet(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
