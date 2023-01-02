//
//  PastOrderlistVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class PastOrderlistVC: BaseViewController {

    @IBOutlet weak var pastOrderListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pastOrderListTableView.delegate = self
        pastOrderListTableView.dataSource = self
        registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        pastOrderListTableView.register(UINib.init(nibName: "OrderListTableviewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableviewCell")
    }
}

extension PastOrderlistVC: UITableViewDelegate{
    
}

extension PastOrderlistVC: UITableViewDataSource{
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
        return 310
    }
}
