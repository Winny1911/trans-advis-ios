//
//  PastTasksVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class PastTasksVC: BaseViewController {

    @IBOutlet weak var pastTaskTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sentMessageButton: UIButton!
    @IBOutlet weak var markCompletedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastTaskTableView.delegate = self
        pastTaskTableView.dataSource = self
        
        markCompletedButton.isHidden = true
        sentMessageButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        sentMessageButton.layer.borderWidth = 1.5
        
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bottomView.layer.shadowRadius = 5.0
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = CGSize.zero
        
        self.registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        pastTaskTableView.register(UINib.init(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
}

extension PastTasksVC:UITableViewDelegate{
    
}

extension PastTasksVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell
        {
            cell.deleteButton.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

