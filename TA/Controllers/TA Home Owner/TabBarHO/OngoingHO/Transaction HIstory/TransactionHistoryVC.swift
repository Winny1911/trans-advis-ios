//
//  TransactionHistoryVC.swift
//  TA
//
//  Created by Applify on 11/01/22.
//

import UIKit

class TransactionHistoryVC: BaseViewController {

    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet weak var imgProfitLoss: UIImageView!
    @IBOutlet weak var btnVwBreakup: UIButton!
    @IBOutlet weak var lblProfiltLoss: UILabel!
    @IBOutlet weak var stckVwProfit: UIStackView!
    @IBOutlet weak var topvwHeight: NSLayoutConstraint!
    @IBOutlet weak var TransactionTableView: UITableView!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var spendLbl: UILabel!
    @IBOutlet weak var budgetLbl: UILabel!

    let transactionHistoryVM: TransactionHistoryVM = TransactionHistoryVM()
    var projectId = 0
    var transactionData: TransactionData?
    var transactionDataCO: TransactionCOResponseDetail?
    var isFrom = ""
    var isType = ""
    var spentValue = 0
    var cartValue = 0
    var refund = ""
    var cartTaskArrList = [CommonTaskCartDetails]()
    //var cartArrList = [CartDetailss]()
    var refundAmountArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoRecordFound.isHidden = true
        btnVwBreakup.setRoundCorners(radius: btnVwBreakup.frame.height / 2)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.isHidden = false
        //tabBarController?.tabBar.isHidden = true
        self.title = "hello world"
        self.TransactionTableView.delegate = self
        self.TransactionTableView.dataSource = self
        self.TransactionTableView.rowHeight = UITableView.automaticDimension
        self.TransactionTableView.estimatedRowHeight = 215.0
        self.TransactionTableView.tableFooterView = UIView()
        self.TransactionTableView.register(UINib.init(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if self.isFrom == "CO" {
            btnVwBreakup.isHidden = false
            topvwHeight.constant = 110.0
            stckVwProfit.isHidden = false
        } else if self.isFrom == "SubTask" {
            btnVwBreakup.isHidden = true
            topvwHeight.constant = 110.0
            stckVwProfit.isHidden = false
        } else {
            btnVwBreakup.isHidden = true
            stckVwProfit.isHidden = true
            topvwHeight.constant = 91.0
        }
        self.fetchTransactionDetails()
    }
    
    func fetchTransactionDetails() {
        self.cartValue = 0
        if self.isFrom == "CO" {
            if isType == "SubTask" {
                let params = ["projectId": projectId]
                transactionHistoryVM.getSubTaskTransactionHistoryCOApi(params) { response in
                    self.transactionDataCO = response?.data
                    
                    self.cartTaskArrList.removeAll()
                    let arrTasks = response?.data?.Tasks ?? [TasksDetailss]()
                    var arrCart = response?.data?.Cart ?? [CartDetailss]()
                    for i in 0 ..< arrTasks.count {
                        let taskModel = CommonTaskCartDetails(lastName: arrTasks[i].assginee?.lastName ?? "", firstName: arrTasks[i].assginee?.firstName ?? "", taskType: arrTasks[i].taskType ?? 1, amount: arrTasks[i].budget ?? 0, dateTime: arrTasks[i].createdAt ?? "", status: arrTasks[i].paymentStatus ?? 0)
                            
                        self.cartTaskArrList.append(taskModel)
                        self.refundAmountArray.append("0")
                    }
                    for i in 0 ..< arrCart.count {
                        if arrCart[i].cartDispute?.count == 0 || arrCart[i].cartDispute == nil {
                            self.refundAmountArray.append("0")
                        } else {
                            if arrCart[i].cartDispute?[0].isRefund ?? 0 == 0 {
                                self.refundAmountArray.append("0")
                            } else {
                                self.refundAmountArray.append("\(arrCart[i].cartDispute?[0].refundedAmount ?? "")")
                            }
                        }
                        
                        let taskModel = CommonTaskCartDetails(lastName: arrCart[i].CartUser?.lastName ?? "", firstName: arrCart[i].CartUser?.firstName ?? "", taskType: 2, amount: arrCart[i].vendorAmount ?? 0, dateTime: arrCart[i].createdAt ?? "", status: arrCart[i].paymentStatus ?? 0)
                            
                        self.cartTaskArrList.append(taskModel)
                    }
                    
    //                self.lblProfiltLoss.text = "$\(response?.data?.EstimatedPrfitLoss ?? 0)"
                    
                    var realsAmount = "\(response?.data?.EstimatedPrfitLoss ?? 0)"
                    let formatte = NumberFormatter()
                    formatte.numberStyle = NumberFormatter.Style.decimal

                    let amoun = Double(realsAmount)
                    let formattedStrin = formatte.string(for: amoun)
                    self.lblProfiltLoss.text =  "$ \(formattedStrin ?? "")"
                    
                    if (response?.data?.EstimatedPrfitLoss ?? 0) < 0 {
                        self.imgProfitLoss.image = UIImage(named: "ic_loss")
                    } else {
                        self.imgProfitLoss.image = UIImage(named: "ic_profit-1")
                    }
    //                self.budgetLbl.text = "$\(response?.data?.bidAmount ?? "0")"
                    
                    var realAmount = "\(response?.data?.bidAmount ?? "0")"
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.decimal

                    let amount = Double(realAmount)
                    let formattedString = formatter.string(for: amount)
                    self.budgetLbl.text =  "$ \(formattedString ?? "")"
                    
                    self.spentValue = 0
                    
                    if arrTasks.count > 0 {
                        for i in 0 ..< (arrTasks.count)  {
                            if arrTasks[i].status == 1 {
                                self.spentValue = self.spentValue + (arrTasks[i].budget)!
                            }
                        }
                    }
                    if arrCart.count > 0 {
                        for i in 0 ..< (arrCart.count)  {
                            if arrCart[i].status == 1 {
                                self.cartValue = self.cartValue + (arrCart[i].vendorAmount)!
                            }
                        }
                    }
                    
    //                self.spendLbl.text = "$\(self.spentValue)"
                    var realAmounts = "\(response?.data?.spent ?? 0)" //"\(self.spentValue)"
                    let formatters = NumberFormatter()
                    formatters.numberStyle = NumberFormatter.Style.decimal

                    let amounts = Double(realAmounts)
                    let formattedStrings = formatters.string(for: amounts)
                    self.spendLbl.text =  "$ \(formattedStrings ?? "")"
                    let spendAmount = response?.data?.spent ?? 0
    //                self.spendLbl.text =  "$ \(spendAmount)"
                    
    //                self.availableLbl.text = "$\(response?.data?.Available ?? 0)"
                    
                    var realAmountss = "\(response?.data?.spent ?? 0)"
                    let formatterss = NumberFormatter()
                    formatterss.numberStyle = NumberFormatter.Style.decimal

                    let a = (Double(realAmount) ?? 0.0) - (Double(realAmounts) ?? 0.0)
                    let amountss = Double(a) //Double(realAmountss)
                    let formattedStringss = formatterss.string(for: amountss)
                    self.availableLbl.text =  "$ \(formattedStringss ?? "")"
                    
                    if response?.data?.Tasks?.count ?? 0 <= 0 {
    //                    self.lblNoRecordFound.isHidden = false
                        self.lblNoRecordFound.isHidden = true
                    } else {
                        self.lblNoRecordFound.isHidden = true
                    }
                    self.TransactionTableView.reloadData()
                }
            } else {
                let params = ["projectId": projectId]
                transactionHistoryVM.getTransactionHistoryCOApi(params) { response in
                    self.transactionDataCO = response?.data
                    
                    self.cartTaskArrList.removeAll()
                    let arrTasks = response?.data?.Tasks ?? [TasksDetailss]()
                    var arrCart = response?.data?.Cart ?? [CartDetailss]()
                    for i in 0 ..< arrTasks.count {
                        let taskModel = CommonTaskCartDetails(lastName: arrTasks[i].assginee?.lastName ?? "", firstName: arrTasks[i].assginee?.firstName ?? "", taskType: arrTasks[i].taskType ?? 1, amount: arrTasks[i].budget ?? 0, dateTime: arrTasks[i].createdAt ?? "", status: arrTasks[i].paymentStatus ?? 0)
                            
                        self.cartTaskArrList.append(taskModel)
                        self.refundAmountArray.append("0")
                    }
                    for i in 0 ..< arrCart.count {
                        if arrCart[i].cartDispute?.count == 0 || arrCart[i].cartDispute == nil {
                            self.refundAmountArray.append("0")
                        } else {
                            if arrCart[i].cartDispute?[0].isRefund ?? 0 == 0 {
                                self.refundAmountArray.append("0")
                            } else {
                                self.refundAmountArray.append("\(arrCart[i].cartDispute?[0].refundedAmount ?? "")")
                            }
                        }
                        
                        
                        let taskModel = CommonTaskCartDetails(lastName: arrCart[i].CartUser?.lastName ?? "", firstName: arrCart[i].CartUser?.firstName ?? "", taskType: 2, amount: arrCart[i].vendorAmount ?? 0, dateTime: arrCart[i].createdAt ?? "", status: arrCart[i].paymentStatus ?? 0)
                            
                        self.cartTaskArrList.append(taskModel)
                    }
                    
    //                self.lblProfiltLoss.text = "$\(response?.data?.EstimatedPrfitLoss ?? 0)"
                    
                    var realsAmount = "\(response?.data?.EstimatedPrfitLoss ?? 0)"
                    let formatte = NumberFormatter()
                    formatte.numberStyle = NumberFormatter.Style.decimal

                    let amoun = Double(realsAmount)
                    let formattedStrin = formatte.string(for: amoun)
                    self.lblProfiltLoss.text =  "$ \(formattedStrin ?? "")"
                    
                    if (response?.data?.EstimatedPrfitLoss ?? 0) < 0 {
                        self.imgProfitLoss.image = UIImage(named: "ic_loss")
                    } else {
                        self.imgProfitLoss.image = UIImage(named: "ic_profit-1")
                    }
    //                self.budgetLbl.text = "$\(response?.data?.bidAmount ?? "0")"
                    
                    var realAmount = "\(response?.data?.bidAmount ?? "0")"
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.decimal

                    let amount = Double(realAmount)
                    let formattedString = formatter.string(for: amount)
                    self.budgetLbl.text =  "$ \(formattedString ?? "")"
                    
                    self.spentValue = 0
                    
                    if arrTasks.count > 0 {
                        for i in 0 ..< (arrTasks.count)  {
                            if arrTasks[i].status == 1 {
                                self.spentValue = self.spentValue + (arrTasks[i].budget)!
                            }
                        }
                    }
                    if arrCart.count > 0 {
                        for i in 0 ..< (arrCart.count)  {
                            if arrCart[i].status == 1 {
                                self.cartValue = self.cartValue + (arrCart[i].vendorAmount)!
                            }
                        }
                    }
                    
    //                self.spendLbl.text = "$\(self.spentValue)"
                    var realAmounts = "\(response?.data?.spent ?? 0)" //"\(self.spentValue)"
                    let formatters = NumberFormatter()
                    formatters.numberStyle = NumberFormatter.Style.decimal

                    let amounts = Double(realAmounts)
                    let formattedStrings = formatters.string(for: amounts)
                    self.spendLbl.text =  "$ \(formattedStrings ?? "")"
                    let spendAmount = response?.data?.spent ?? 0
    //                self.spendLbl.text =  "$ \(spendAmount)"
                    
    //                self.availableLbl.text = "$\(response?.data?.Available ?? 0)"
                    
                    var realAmountss = "\(response?.data?.spent ?? 0)"
                    let formatterss = NumberFormatter()
                    formatterss.numberStyle = NumberFormatter.Style.decimal

                    let a = (Double(realAmount) ?? 0.0) - (Double(realAmounts) ?? 0.0)
                    let amountss = Double(a) //Double(realAmountss)
                    let formattedStringss = formatterss.string(for: amountss)
                    self.availableLbl.text =  "$ \(formattedStringss ?? "")"
                    
                    if response?.data?.Tasks?.count ?? 0 <= 0 {
    //                    self.lblNoRecordFound.isHidden = false
                        self.lblNoRecordFound.isHidden = true
                    } else {
                        self.lblNoRecordFound.isHidden = true
                    }
                    self.TransactionTableView.reloadData()
                }
            }
            
        } else if self.isFrom == "SubTask" {
            let params = ["projectId": projectId]
            transactionHistoryVM.getSubTaskTransactionHistoryCOApi(params) { response in
                self.transactionDataCO = response?.data
                
                self.cartTaskArrList.removeAll()
                let arrTasks = response?.data?.Tasks ?? [TasksDetailss]()
                var arrCart = response?.data?.Cart ?? [CartDetailss]()
                for i in 0 ..< arrTasks.count {
                    let taskModel = CommonTaskCartDetails(lastName: arrTasks[i].assginee?.lastName ?? "", firstName: arrTasks[i].assginee?.firstName ?? "", taskType: arrTasks[i].taskType ?? 1, amount: arrTasks[i].budget ?? 0, dateTime: arrTasks[i].createdAt ?? "", status: arrTasks[i].paymentStatus ?? 0)
                        
                    self.cartTaskArrList.append(taskModel)
                    self.refundAmountArray.append("0")
                }
                for i in 0 ..< arrCart.count {
                    if arrCart[i].cartDispute?[0].isRefund ?? 0 == 0 {
                        self.refundAmountArray.append("0")
                    } else {
                        self.refundAmountArray.append("\(arrCart[i].cartDispute?[0].refundedAmount ?? "")")
                    }
                    let taskModel = CommonTaskCartDetails(lastName: arrCart[i].CartUser?.lastName ?? "", firstName: arrCart[i].CartUser?.firstName ?? "", taskType: 2, amount: arrCart[i].vendorAmount ?? 0, dateTime: arrCart[i].createdAt ?? "", status: arrCart[i].paymentStatus ?? 0)
                        
                    self.cartTaskArrList.append(taskModel)
                }
                
//                self.lblProfiltLoss.text = "$\(response?.data?.EstimatedPrfitLoss ?? 0)"
                var realsAmount = "\(response?.data?.EstimatedPrfitLoss ?? 0)"
                let formatte = NumberFormatter()
                formatte.numberStyle = NumberFormatter.Style.decimal

                let amoun = Double(realsAmount)
                let formattedStrin = formatte.string(for: amoun)
                self.lblProfiltLoss.text =  "$ \(formattedStrin ?? "")"
                
                if (response?.data?.EstimatedPrfitLoss ?? 0) < 0 {
                    self.imgProfitLoss.image = UIImage(named: "ic_loss")
                } else {
                    self.imgProfitLoss.image = UIImage(named: "ic_profit-1")
                }
//                self.budgetLbl.text = "$\(response?.data?.bidAmount ?? "0")"
                
                var realAmount = "\(response?.data?.bidAmount ?? "0")"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                self.budgetLbl.text =  "$ \(formattedString ?? "")"
                
                self.spentValue = 0
                
                if arrTasks.count > 0 {
                    for i in 0 ..< (arrTasks.count)  {
                        if arrTasks[i].status == 1 {
                            self.spentValue = self.spentValue + (arrTasks[i].budget)!
                        }
                    }
                }
                
                if arrCart.count > 0 {
                    for i in 0 ..< (arrCart.count)  {
                        if arrCart[i].status == 1 {
                            self.cartValue = self.cartValue + (arrCart[i].vendorAmount)!
                        }
                    }
                }
                
//                self.spendLbl.text = "$\(self.spentValue)"
                var realAmounts = response?.data?.spent ?? 0 //"\(self.spentValue)"
                let formatters = NumberFormatter()
                formatters.numberStyle = NumberFormatter.Style.decimal

                let amounts = Double(realAmounts)
                let formattedStrings = formatters.string(for: amounts)
                self.spendLbl.text =  "$ \(formattedStrings ?? "")"
                
//                self.availableLbl.text = "$\(response?.data?.Available ?? 0)"
                var realAmountss = "\(response?.data?.Available ?? 0)"
                let formatterss = NumberFormatter()
                formatterss.numberStyle = NumberFormatter.Style.decimal

                let amountss = Double(realAmountss)
                let formattedStringss = formatterss.string(for: amountss)
                self.availableLbl.text =  "$ \(formattedStringss ?? "")"
                if response?.data?.Tasks?.count ?? 0 <= 0 {
//                    self.lblNoRecordFound.isHidden = false
                    self.lblNoRecordFound.isHidden = true
                } else {
                    self.lblNoRecordFound.isHidden = true
                }
                self.TransactionTableView.reloadData()
            }
        } else {
            let params = ["projectId": projectId]
            transactionHistoryVM.getOngoingTransactionHistoryApi(params) { response in
                self.transactionDataCO = response?.data
                
                self.cartTaskArrList.removeAll()
                let arrTasks = response?.data?.Tasks ?? [TasksDetailss]()
                var arrCart = response?.data?.Cart ?? [CartDetailss]()
                for i in 0 ..< arrTasks.count {
                    let taskModel = CommonTaskCartDetails(lastName: arrTasks[i].assginee?.lastName ?? "", firstName: arrTasks[i].assginee?.firstName ?? "", taskType: arrTasks[i].taskType ?? 1, amount: arrTasks[i].budget ?? 0, dateTime: arrTasks[i].createdAt ?? "", status: arrTasks[i].paymentStatus ?? 0)
                        
                    self.cartTaskArrList.append(taskModel)
                    self.refundAmountArray.append("0")
                }
                for i in 0 ..< arrCart.count {
                    if arrCart[i].cartDispute?[0].isRefund ?? 0 == 0 {
                        self.refundAmountArray.append("0")
                    } else {
                        self.refundAmountArray.append("\(arrCart[i].cartDispute?[0].refundedAmount ?? "")")
                    }
                    let taskModel = CommonTaskCartDetails(lastName: arrCart[i].CartUser?.lastName ?? "", firstName: arrCart[i].CartUser?.firstName ?? "", taskType: 2, amount: arrCart[i].vendorAmount ?? 0, dateTime: arrCart[i].createdAt ?? "", status: arrCart[i].paymentStatus ?? 0)
                        
                    self.cartTaskArrList.append(taskModel)
                }
                
//                self.lblProfiltLoss.text = "$\(response?.data?.EstimatedPrfitLoss ?? 0)"
                var realsAmount = "\(response?.data?.EstimatedPrfitLoss ?? 0)"
                let formatte = NumberFormatter()
                formatte.numberStyle = NumberFormatter.Style.decimal

                let amoun = Double(realsAmount)
                let formattedStrin = formatte.string(for: amoun)
                self.lblProfiltLoss.text =  "$ \(formattedStrin ?? "")"
                
                if (response?.data?.EstimatedPrfitLoss ?? 0) < 0 {
                    self.imgProfitLoss.image = UIImage(named: "ic_loss")
                } else {
                    self.imgProfitLoss.image = UIImage(named: "ic_profit-1")
                }
//                self.budgetLbl.text = "$\(response?.data?.bidAmount ?? "0")"
                
                var realAmount = "\(response?.data?.bidAmount ?? "0")"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                self.budgetLbl.text =  "$ \(formattedString ?? "")"
                
                self.spentValue = 0
                
                if arrTasks.count > 0 {
                    for i in 0 ..< (arrTasks.count)  {
                        if arrTasks[i].status == 1 {
                            self.spentValue = self.spentValue + (arrTasks[i].budget)!
                        }
                    }
                }
                
                if arrCart.count > 0 {
                    for i in 0 ..< (arrCart.count)  {
                        if arrCart[i].status == 1 {
                            self.cartValue = self.cartValue + (arrCart[i].vendorAmount)!
                        }
                    }
                }
                
//                self.spendLbl.text = "$\(self.spentValue)"
                var realAmounts = response?.data?.spent ?? 0 //"\(self.spentValue)"
                let formatters = NumberFormatter()
                formatters.numberStyle = NumberFormatter.Style.decimal

                let amounts = Double(realAmounts)
                let formattedStrings = formatters.string(for: amounts)
                self.spendLbl.text =  "$ \(formattedStrings ?? "")"
                
//                self.availableLbl.text = "$\(response?.data?.Available ?? 0)"
                var realAmountss = "\(response?.data?.Available ?? 0)"
                let formatterss = NumberFormatter()
                formatterss.numberStyle = NumberFormatter.Style.decimal

                let amountss = Double(realAmountss)
                let formattedStringss = formatterss.string(for: amountss)
                self.availableLbl.text =  "$ \(formattedStringss ?? "")"
                
                if response?.data?.Tasks?.count ?? 0 <= 0 {
//                    self.lblNoRecordFound.isHidden = false
                    self.lblNoRecordFound.isHidden = true
                } else {
                    self.lblNoRecordFound.isHidden = true
                }
                self.TransactionTableView.reloadData()
            }
        }
    }
    
    @IBAction func tapDidBackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapDidTransactionPopUPViewButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionPopUpViewVC") as? TransactionPopUpViewVC
        destinationViewController!.isFrom = self.isFrom
        
        if self.isFrom == "CO" {
            destinationViewController!.price = "\(transactionDataCO?.bidAmount ?? "0")"
            destinationViewController!.subContractorFund = "\(self.spentValue)"
            destinationViewController!.contractorFund = "\(self.cartValue)"
            destinationViewController!.taCommission = "\(transactionDataCO?.TAcommisssion ?? 0)"
            destinationViewController!.balance = "\(transactionDataCO?.BAlance ?? 0)"
            self.present(destinationViewController!, animated: true, completion: nil)
        } else if self.isFrom == "SubTask" {
            
        } else {
            destinationViewController!.bitAmount = "\(transactionDataCO?.bidAmount ?? "0")"
            //transactionData?.bidAmount ?? ""
            destinationViewController!.suppliFund = "\(self.cartValue)"
            destinationViewController!.fundDisbused = "\(self.spentValue)"
            //"\(transactionData?.totalSpent ?? 0)"
            //transactionData?.bidAmount ?? ""
            destinationViewController!.balance = "\(transactionDataCO?.Available ?? 0)"
            self.present(destinationViewController!, animated: true, completion: nil)
            
        }        
        
    }
    
}

extension TransactionHistoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // if self.isFrom == "CO" {
            return (self.cartTaskArrList.count)
//        } else if self.isFrom == "SubTask" {
//            return (self.cartTaskArrList.count)
//        } else {
//            return transactionData?.tasks?.count ?? 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)as? HistoryTableViewCell {
           // if self.isFrom == "CO" {
                let firstName = self.cartTaskArrList[indexPath.row].firstName ?? ""
                let LastName = self.cartTaskArrList[indexPath.row].lastName ?? ""
                cell.assignLbl.text = "\(firstName) \(LastName)"
                let budget = self.cartTaskArrList[indexPath.row].amount ?? 0
//                cell.amountLbl.text = "$\(budget)"
            var realAmountss = "\(budget)"
            let formatterss = NumberFormatter()
            formatterss.numberStyle = NumberFormatter.Style.decimal

            let amountss = Double(realAmountss)
            let formattedStringss = formatterss.string(for: amountss)
            cell.amountLbl.text =  "$ \(formattedStringss ?? "")"
                
                let createdAt = self.cartTaskArrList[indexPath.row].dateTime ?? ""
                if createdAt != ""{
                    let date1 = DateHelper.convertDateString(dateString: createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "h:mm a")
                    let date2 = DateHelper.convertDateString(dateString: createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM,yyyy")
                    cell.dateLbl.text = "\(date2) at \(date1)"
                }

                if self.cartTaskArrList[indexPath.row].status == 0 {
                    cell.statusLabel.text = "  Pending  "
                    cell.statusLabel.backgroundColor = UIColor.appBtnRed
                } else if self.cartTaskArrList[indexPath.row].status == 1 {
                    cell.statusLabel.text = "  Completed  "
                    cell.statusLabel.backgroundColor = UIColor.appColorGreen
                } else {
                    cell.statusLabel.text = "  Decline  "
                    cell.statusLabel.backgroundColor = UIColor.appBtnRed
                }
                
                let taskType = self.cartTaskArrList[indexPath.row].taskType ?? 0
                if taskType == 1 {
                    cell.typeLbl.text = "Sub Contracted"
                } else if taskType == 2 {
                    cell.typeLbl.text = "Material Order"
                } else {
                    cell.typeLbl.text = "Self Assigned"
                }
            print(refundAmountArray)
//            if isType == "SubTask" {
//                cell.refundText.isHidden = true
//                cell.refundAmountLabel.isHidden = true
//            } else {
                if self.refundAmountArray[indexPath.row] == "0" {
                    cell.refundText.isHidden = true
                    cell.refundAmountLabel.isHidden = true
                } else {
                    cell.refundText.isHidden = false
                    cell.refundAmountLabel.isHidden = false
                    cell.refundAmountLabel.text = "$\(self.refundAmountArray[indexPath.row])"
                }
//            }
           
//            } else if self.isFrom == "SubTask" {
//                let firstName = self.cartTaskArrList[indexPath.row].firstName ?? ""
//                let LastName = self.cartTaskArrList[indexPath.row].lastName ?? ""
//                cell.assignLbl.text = "\(firstName) \(LastName)"
//                let budget = self.cartTaskArrList[indexPath.row].amount ?? 0
//                cell.amountLbl.text = "$\(budget)"
//
//                let createdAt = self.cartTaskArrList[indexPath.row].dateTime ?? ""
//                if createdAt != ""{
//                    let date1 = DateHelper.convertDateString(dateString: createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "h:mm a")
//                    let date2 = DateHelper.convertDateString(dateString: createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM,yyyy")
//                    cell.dateLbl.text = "\(date2) at \(date1)"
//                }
//
//                if self.cartTaskArrList[indexPath.row].status == 0 {
//                    cell.statusLabel.text = "  Pending  "
//                    cell.statusLabel.backgroundColor = UIColor.appBtnRed
//                } else if self.cartTaskArrList[indexPath.row].status == 1 {
//                    cell.statusLabel.text = "  Completed  "
//                    cell.statusLabel.backgroundColor = UIColor.appColorGreen
//                } else {
//                    cell.statusLabel.text = "  Decline  "
//                    cell.statusLabel.backgroundColor = UIColor.appBtnRed
//                }
//
//                let taskType = self.cartTaskArrList[indexPath.row].taskType ?? 0
//                if taskType == 1 {
//                    cell.typeLbl.text = "Sub Contracted"
//                } else if taskType == 2 {
//                    cell.typeLbl.text = "Material Order"
//                } else {
//                    cell.typeLbl.text = "Other"
//                }
//            } else {
//                let firstName = transactionData?.tasks?[indexPath.row].assginee?.firstName ?? ""
//                let LastName = transactionData?.tasks?[indexPath.row].assginee?.lastName ?? ""
//                cell.assignLbl.text = "\(firstName) \(LastName)"
//                cell.typeLbl.text = "SELF ASSIGNED"
//                //transactionData?.tasks?[indexPath.row].type ?? ""
//                let budget = transactionData?.tasks?[indexPath.row].budget ?? 0
//                cell.amountLbl.text = "$\(budget)"
//                let createdAt = transactionData?.tasks?[indexPath.row].createdAt ?? ""
//                if createdAt != ""{
//                    let date1 = DateHelper.convertDateString(dateString: createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "h:mm a")
//                    let date2 = DateHelper.convertDateString(dateString: createdAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM,yyyy")
//                    cell.dateLbl.text = "\(date2) at \(date1)"
//                }
//                let status = transactionData?.tasks?[indexPath.row].status ?? 0
//                if status == 0{
//                    cell.statusLabel.text = "  Pending  "
//                    cell.statusLabel.backgroundColor = UIColor.appBtnRed
//                }
//                else{
//                    cell.statusLabel.text = "  Completed  "
//                    cell.statusLabel.backgroundColor = UIColor.appColorGreen
//                }
//            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
