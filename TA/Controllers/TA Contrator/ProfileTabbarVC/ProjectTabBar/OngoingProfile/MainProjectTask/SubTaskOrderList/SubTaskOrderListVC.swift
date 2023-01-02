//
//  SubTaskOrderListVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class SubTaskOrderListVC: BaseViewController {

    @IBOutlet weak var subOrderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subOrderTableView.delegate = self
        subOrderTableView.dataSource = self
        registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        subOrderTableView.register(UINib.init(nibName: "OrderListTableviewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableviewCell")
    }
}

extension SubTaskOrderListVC: UITableViewDelegate{
    
}

extension SubTaskOrderListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableviewCell", for: indexPath) as? OrderListTableviewCell
        {
            cell.declineButton.isHidden = true
            cell.acceptOrder.isHidden = true
            cell.lineview.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
