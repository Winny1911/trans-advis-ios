//
//  TransactionPopUpViewVC.swift
//  TA
//
//  Created by Applify on 12/01/22.
//

import UIKit

class TransactionPopUpViewVC: BaseViewController {

    @IBOutlet weak var lblStaticBlnc: UILabel!
    @IBOutlet weak var lblStatic4: UILabel!
    @IBOutlet weak var lblStatic3: UILabel!
    @IBOutlet weak var lblStatic2: UILabel!
    
    @IBOutlet weak var lblTransServiceFee: UILabel!
    @IBOutlet weak var vwHtConst: NSLayoutConstraint!
    @IBOutlet weak var projectBitAmmountLbl: UILabel!
    @IBOutlet weak var projectAmountLbl: UILabel!
    @IBOutlet weak var suppliFundLbl: UILabel!
    @IBOutlet weak var fundDisbusedLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    
    var bitAmount = ""
    var isFrom = ""
    
    var price = ""
    var subContractorFund = ""
    var contractorFund = ""
    var taCommission = ""
    var balance = ""
    var fundDisbused = ""
    var suppliFund = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isFrom == "CO" {
            lblStaticBlnc.text = "Balance To Contractor"
            lblStatic2.text = "Contractor Supplies Funded"
            lblStatic3.text = "Subcontractor and Other Fees Funded"
            vwHtConst.constant = 290.0
            lblStatic4.isHidden = false
            lblTransServiceFee.isHidden = false
            
//            self.projectBitAmmountLbl.text = "$\(price)"
            var realAmountss = "\(price)"
            let formatterss = NumberFormatter()
            formatterss.numberStyle = NumberFormatter.Style.decimal

            let amountss = Double(realAmountss)
            let formattedStringss = formatterss.string(for: amountss)
            self.projectBitAmmountLbl.text =  "$ \(formattedStringss ?? "")"
            
//            self.projectAmountLbl.text = "$\(price)"
            var realAmounts = "\(price)"
            let formatters = NumberFormatter()
            formatters.numberStyle = NumberFormatter.Style.decimal

            let amounts = Double(realAmounts)
            let formattedStrings = formatters.string(for: amounts)
            self.projectAmountLbl.text =  "$ \(formattedStrings ?? "")"
            
//            self.suppliFundLbl.text = "$\(contractorFund)"
            var realsAmount = "\(contractorFund)"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amt = Double(realsAmount)
            let formattedString = formatter.string(for: amt)
            self.suppliFundLbl.text =  "$ \(formattedString ?? "")"
            
//            self.fundDisbusedLbl.text = "$\(subContractorFund)"
            var realAmountes = "\(subContractorFund)"
            let formatteres = NumberFormatter()
            formatteres.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmountes)
            let formattedStringes = formatteres.string(for: amount)
            self.fundDisbusedLbl.text =  "$ \(formattedStringes ?? "")"
            
//            self.lblTransServiceFee.text = "$\(taCommission)"
            var realAmountssss = "\(taCommission)"
            let formatterssss = NumberFormatter()
            formatterssss.numberStyle = NumberFormatter.Style.decimal

            let amoun = Double(realAmountssss)
            let formattedStrin = formatterssss.string(for: amoun)
            self.lblTransServiceFee.text =  "$ \(formattedStrin ?? "")"
            
//            self.balanceLbl.text = "$\(balance)"
            var realAmt = "\(balance)"
            let formatte = NumberFormatter()
            formatte.numberStyle = NumberFormatter.Style.decimal

            let amouns = Double(realAmt)
            let formattedStg = formatte.string(for: amouns)
            self.balanceLbl.text =  "$ \(formattedStg ?? "")"
            
        } else {
            lblStaticBlnc.text = "Balance"
            lblStatic2.text = "Supplies funded for project(Materials Ordered)"
            lblStatic3.text = "Funds disbursed"
            vwHtConst.constant = 240.0
            lblStatic4.isHidden = true
            lblTransServiceFee.isHidden = true
            
//            self.projectBitAmmountLbl.text = "$\(bitAmount)"
            var realAmountss = "\(bitAmount)" //"\(price)"
            let formatterss = NumberFormatter()
            formatterss.numberStyle = NumberFormatter.Style.decimal

            let amountss = Double(realAmountss)
            let formattedStringss = formatterss.string(for: amountss)
            self.projectBitAmmountLbl.text =  "$ \(formattedStringss ?? "")"
            
//            self.projectAmountLbl.text = "$\(bitAmount)"
            var realAmounts = "\(bitAmount)"
            let formatters = NumberFormatter()
            formatters.numberStyle = NumberFormatter.Style.decimal

            let amounts = Double(realAmounts)
            let formattedStrings = formatters.string(for: amounts)
            self.projectAmountLbl.text =  "$ \(formattedStrings ?? "")"
            
//            self.suppliFundLbl.text = "$\(suppliFund)"
            var realsAmount = "\(suppliFund)"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amt = Double(realsAmount)
            let formattedString = formatter.string(for: amt)
            self.suppliFundLbl.text =  "$ \(formattedString ?? "")"
            
            self.fundDisbusedLbl.text = "$\(fundDisbused)"
            var realAmountssss = "\(fundDisbused)"
            let formatterssss = NumberFormatter()
            formatterssss.numberStyle = NumberFormatter.Style.decimal

            let amoun = Double(realAmountssss)
            let formattedStrin = formatterssss.string(for: amoun)
            self.fundDisbusedLbl.text =  "$ \(formattedStrin ?? "")"
            
//            self.balanceLbl.text = "$\(balance)"
            var realAmt = "\(balance)"
            let formatte = NumberFormatter()
            formatte.numberStyle = NumberFormatter.Style.decimal

            let amouns = Double(realAmt)
            let formattedStg = formatte.string(for: amouns)
            self.balanceLbl.text =  "$ \(formattedStg ?? "")"
        }
    }
    
    
    @IBAction func actionDismis(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
