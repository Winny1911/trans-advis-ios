//
//  PastSubOrderListVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class PastSubOrderListVC: BaseViewController {

    @IBOutlet weak var pastSubOrderListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastSubOrderListTableView.delegate = self
        pastSubOrderListTableView.dataSource = self
        registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        pastSubOrderListTableView.register(UINib.init(nibName: "OrderListTableviewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableviewCell")
    }
}

extension PastSubOrderListVC: UITableViewDelegate{
    
}

extension PastSubOrderListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableviewCell", for: indexPath) as? OrderListTableviewCell
        {
            cell.declineButton.isHidden = true
            cell.acceptOrder.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
