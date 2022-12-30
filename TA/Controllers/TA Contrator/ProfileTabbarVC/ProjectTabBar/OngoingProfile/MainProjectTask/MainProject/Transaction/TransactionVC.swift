//
//  TransactionVC.swift
//  TA
//
//  Created by Designer on 15/12/21.
//

import UIKit

class TransactionVC: BaseViewController {

    @IBOutlet weak var transactionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        registerCells()
    }

    // MARK: RegisterXib file
    func registerCells() {
        transactionTableView.register(UINib.init(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TransactionVC:UITableViewDelegate{
    
}

extension TransactionVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell
            {
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    
}
