//
//  TaskHOVC.swift
//  TA
//
//  Created by Dev on 28/12/21.
//

import UIKit

class TaskHOVC: BaseViewController {

    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    
    let ongoingProjectsHOViewModel: OngoingProjectHOVM = OngoingProjectHOVM()
    
    var id = 0
    var test = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoRecord.isHidden = true
        self.taskTableView.tableFooterView = UIView()
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        test.removeAll()
        taskTableView.tableFooterView = UIView()
        self.fetchProjectDetails()
    }
    
    // MARK: RegisterXib file
    func registerCells() {
        taskTableView.register(UINib.init(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    func fetchProjectDetails() {
        let params = ["id": id]
        ongoingProjectsHOViewModel.getOngoingProjectDetailApi(params) { response in
            self.test.removeAll()
            for i in 0 ..< (response?.data?.mainProjectTasks?.count)! {
                self.test.append(response?.data?.mainProjectTasks?[i].task ?? "")
            }
            if self.test.count <= 0 {
                self.lblNoRecord.isHidden = false
            } else{
                self.lblNoRecord.isHidden = true
            }
//            if let progress = response?.data?.progress {
//                let  floatProgress = (Double(progress) / Double(100.0))
//                if response?.data?.status == 9 && floatProgress >= 1 {
//                    NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
//                } else {
//                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//                }
//            } else {
//                NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//            }
            
//            if response?.data?.status == 10 {
//                NotificationCenter.default.post(name: Notification.Name("AdminAprovalCheck"), object: nil)
//            } else if response?.data?.mainProjectTasks?.count ?? 0 <= 0 {
//                NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
//            } else {
//                
//                if let progress = response?.data?.progress {
//                    let  floatProgress = (Double(progress) / Double(100.0))
//                    if response?.data?.status == 9 && floatProgress >= 1 {
//                        NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
//                    } else if response?.data?.status == 10 {
//                        NotificationCenter.default.post(name: Notification.Name("AdminAprovalCheck"), object: nil)
//                    } else {
//                        NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//                    }
//                } else {
//                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
//                }
//            }
            
            if let progress = response?.data?.progress {
                let  floatProgress = (Double(progress) / Double(100.0))
                if response?.data?.status == 9 && floatProgress >= 1 {
                    NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
                }
            } else {
                if response?.data?.status == 9 {
                    NotificationCenter.default.post(name: Notification.Name("ApproveDeliveryCheck"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
                }
            }
            
            if response?.data?.status == 10 {
                NotificationCenter.default.post(name: Notification.Name("AdminAprovalCheck"), object: nil)
            }
            
            self.taskTableView.reloadData()
        }
    }
}


extension TaskHOVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell
        {
            cell.dateLbl.isHidden = true
            cell.tastTitleLbl.text = test[indexPath.row]
            cell.deleteButton.isHidden = true
            
            cell.deleteTaskTapAction = {
                () in
                print("Delete Action")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
