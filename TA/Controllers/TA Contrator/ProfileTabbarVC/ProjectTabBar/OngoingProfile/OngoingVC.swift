//
//  OngoingVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class OngoingVC: BaseViewController {

    @IBOutlet weak var ongoingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ongoingTableView.delegate = self
        ongoingTableView.dataSource = self
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        ongoingTableView.register(UINib.init(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectTableViewCell")
    }
}

extension OngoingVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.mainProjectTask.instantiateViewController(withIdentifier: "MainProjectTaskVC") as? MainProjectTaskVC
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
}

extension OngoingVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as? ProjectTableViewCell
        {
            // MARK: clourse call
            cell.viewTransactionTapAction = {
                () in
                let mainStoryboard =  UIStoryboard(name: "MainProjectTask", bundle: Bundle.main)
                guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainProjectTaskVC") as? MainProjectTaskVC else{
                    print("Error: Controller not found!!!")
                    return
                }
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}
