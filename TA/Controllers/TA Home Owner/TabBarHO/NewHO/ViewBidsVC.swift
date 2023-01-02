//
//  ViewBidsVC.swift
//  TA
//
//  Created by applify on 05/01/22.
//

import UIKit

class ViewBidsVC: BaseViewController {

    @IBOutlet weak var noBid: UILabel!
    @IBOutlet weak var lblTopAttributed: UILabel!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewBidsViewModel : ViewBidsVM = ViewBidsVM()
    var id = Int()
    var ViewBids =  [AllProjectViewBidData]()
    var completionHandlerGoToNewProjectDetailScreen: (() -> Void)?
    
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCells()
        navigationController?.navigationBar.isHidden = false
        
        setAttributedLabel()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noBid.isHidden = true
        navigationController?.navigationBar.isHidden = true
        if  self.isFrom == "InvitedTaskCO" {
            self.getViewInvitedBidsApiHit()
        } else {
            getViewBidsApiHit()
        }
        
    }
    
    func setAttributedLabel() {
        let myString = "You can see max 4 bids at the same time. To see more reject any of the existing bids"
        let attrStri = NSMutableAttributedString.init(string:myString)
           let nsRange = NSString(string: myString).range(of: "4 bids", options: String.CompareOptions.caseInsensitive)
           attrStri.addAttributes([NSAttributedString.Key.font: UIFont.init(name: PoppinsFont.semiBold, size: 16.0) as Any], range: nsRange)
           self.lblTopAttributed.attributedText = attrStri
    }
    
    func getViewInvitedBidsApiHit(){
        let param = ["projectId":id]
        self.viewBidsViewModel.ViewInvitedBidsApiCall(param){ model in
            self.ViewBids = model?.data ?? []
            self.lblTop.text = "View Bids (\(self.ViewBids.count)/4)"
            if self.ViewBids.count <= 0 {
                self.noBid.isHidden = false
            } else {
                self.noBid.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    func getViewBidsApiHit(){
        let param = ["projectId":id]
        self.viewBidsViewModel.ViewBidsApiCall(param){ model in
            self.ViewBids = model?.data ?? []
            self.lblTop.text = "View Bids (\(self.ViewBids.count)/4)"
            if self.ViewBids.count <= 0 {
                self.noBid.isHidden = false
            } else {
                self.noBid.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        tableView.register(UINib.init(nibName: "ViewBidsTableVwCell", bundle: nil), forCellReuseIdentifier: "ViewBidsTableVwCell")
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ViewBidsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewBids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ViewBidsTableVwCell", for: indexPath) as? ViewBidsTableVwCell
        {
            cell.firstNameLbl.text = "\(self.ViewBids[indexPath.row].user?.firstName ?? "") \(self.ViewBids[indexPath.row].user?.lastName ?? "")"
//            cell.bidAmountLbl.text = "$ \(self.ViewBids[indexPath.row].bidAmount ?? "")"
            
            var realAmount = "\(self.ViewBids[indexPath.row].bidAmount ?? "")"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            cell.bidAmountLbl.text =  "$ \(formattedString ?? "")"

            if self.ViewBids[indexPath.row].user?.profilePic ?? "" > ""{
                if let imgStr = self.ViewBids[indexPath.row].user?.profilePic{
                    cell.profileImg.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "BidDetailVc") as? BidDetailVc
        destinationViewController!.id = self.ViewBids[indexPath.row].id ?? 0
        if self.isFrom == "InvitedTaskCO" {
            destinationViewController!.isFrom = "InvitedTaskCO"
        }
        destinationViewController!.completionHandlerGoToViewBidsScreen = { [weak self] in
            if self!.isFrom == "InvitedTaskCO" {
                //// YET TO BE DONE
                self!.navigationController?.popViewController(animated: true)
                self!.completionHandlerGoToNewProjectDetailScreen?()
            } else {
                self!.navigationController?.popViewController(animated: true)
                self!.completionHandlerGoToNewProjectDetailScreen?()
            }
        }
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

