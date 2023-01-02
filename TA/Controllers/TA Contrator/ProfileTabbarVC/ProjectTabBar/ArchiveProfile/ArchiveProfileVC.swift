//
//  ArchiveProfileVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class ArchiveProfileVC: BaseViewController {

    @IBOutlet weak var archiveTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        archiveTableView.delegate = self
        archiveTableView.dataSource = self
        self.registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        archiveTableView.register(UINib.init(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
}

extension ArchiveProfileVC:UITableViewDelegate{
    
}

extension ArchiveProfileVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell
        {
            cell.blurVwww.isHidden = true
            cell.markCompletedButton.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}
