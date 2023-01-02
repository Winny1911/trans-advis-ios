//
//  OrderlistVC.swift
//  TA
//
//  Created by Designer on 13/12/21.
//

import UIKit

class OrderlistVC: BaseViewController {

    @IBOutlet weak var orderListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        self.registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        orderListTableView.register(UINib.init(nibName: "OrderListTableviewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableviewCell")
    }
}

extension OrderlistVC: UITableViewDelegate{
    
}

extension OrderlistVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableviewCell", for: indexPath) as? OrderListTableviewCell
        {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
