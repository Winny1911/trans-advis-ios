//
//  ViewBidLogVC.swift
//  TA
//
//  Created by Applify  on 05/01/22.
//

import UIKit

class ViewBidLogVC: BaseViewController {

    @IBOutlet weak var tblVwBidList: UITableView!
    @IBOutlet weak var lblTopTitle: UILabel!
    
    var arrBidLog = [GetBidLoglDetail]()
    var projectTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTopTitle.text = "Bid Log" //"\(projectTitle) Bid Log"
        self.tblVwBidList.register(UINib.init(nibName: "ViewBidLogTblVwCell", bundle: nil), forCellReuseIdentifier: "ViewBidLogTblVwCell")
        self.tblVwBidList.delegate = self
        self.tblVwBidList.dataSource = self
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ViewBidLogVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBidLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewBidLogTblVwCell", for: indexPath) as! ViewBidLogTblVwCell
        cell.lblTitle.text = self.arrBidLog[indexPath.row].bidLogMessage ?? ""
        cell.lblTime.text = DateHelper.convertDateString(dateString: self.arrBidLog[indexPath.row].createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "MMM dd- hh:mm a")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
