//
//  PastProfileVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class PastProjectVC: BaseViewController {

    @IBOutlet weak var pastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastTableView.delegate = self
        pastTableView.dataSource = self
        self.registerCells()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        pastTableView.register(UINib.init(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
}

extension PastProjectVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mainStoryboard =  UIStoryboard(name: "PastMainProjectTask", bundle: Bundle.main)
//        guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "PastMainProjectTaskVC") as? PastMainProjectTaskVC else{
//            print("Error: Controller not found!!!")
//            return
//        }
        guard let destinationViewController = Controllers.pastMainProjectTask else{
            print("Error: Controller not found!!!")
            return
        }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        print(" Navigate successfully")
    }
    
}

extension PastProjectVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell
        {
            cell.blurVwww.isHidden = true
            cell.markCompletedButton.isHidden = true
            // MARK: clourse call
            cell.viewTransactionTapAction = {
                () in
                print("hello ---- >>")
                let mainStoryboard =  UIStoryboard(name: "PastMainProjectTask", bundle: Bundle.main)
                guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "PastMainProjectTaskVC") as? PastMainProjectTaskVC else{
                    print("Error: Controller not found!!!")
                    return
                }
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                print(" Navigate successfully")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}
