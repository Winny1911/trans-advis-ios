//
//  NewHOVC.swift
//  TA
//
//  Created by Dev on 09/12/21.
//

import UIKit
import SDWebImage

class NewHOVC: BaseViewController {
   
    let newProjectsHOViewModel: NewProjectsHOViewModel = NewProjectsHOViewModel()
    var newProjectsListing = [NewProjectsDetail]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblNoActive: UILabel!
    @IBOutlet weak var btnCreateProject: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isFromInvitationNotification = false
    var isFromInvitationNotificationProjectId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCreateProject.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 16.0)
        self.allProjectDetailAPIcall()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidPlacedToHomeOwnerProjectsDetails(notification:)), name: Notification.Name("BidPlacedToHomeOwnerProjectsDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recallBidToHomeOwnerNewProjectsDetails(notification:)), name: Notification.Name("RecallBidToHomeOwnerNewProjectsDetails"), object: nil)
    }
    
    @objc func recallBidToHomeOwnerNewProjectsDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromInvitationNotification =  true
        self.isFromInvitationNotificationProjectId =  notiDict["projectId"] as! Int
        self.allProjectDetailAPIcall()
    }
    
    @objc func bidPlacedToHomeOwnerProjectsDetails(notification: Notification) {
        let notiDict = notification.userInfo! as NSDictionary
        self.isFromInvitationNotification =  true
        self.isFromInvitationNotificationProjectId =  notiDict["projectId"] as! Int
        self.allProjectDetailAPIcall()
    }
    
    func allProjectDetailAPIcall(){
        let param = ["status":1]
        newProjectsHOViewModel.getNewProjectApi(param) { response in
            self.newProjectsListing = response?.data?.allProjects ?? []
            self.tableView.isHidden = false
            if self.newProjectsListing.count <= 0 {
                self.tableView.isHidden = true
            } else {
                self.tableView.reloadData()
            }
            if self.isFromInvitationNotification == true {
                self.isFromInvitationNotification = false
                for i in 0 ..< self.newProjectsListing.count {
                    if self.newProjectsListing[i].id == self.isFromInvitationNotificationProjectId {
                        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "NewDetailsHOVC") as? NewDetailsHOVC
                        destinationViewController?.projectId = self.newProjectsListing[i].id ?? 0
                        self.isFromInvitationNotificationProjectId = 0
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    //MARK: - REGISTER CELL
    func registerCell() {
        tableView.register(UINib.init(nibName: "NewHOTableViewCell", bundle: nil), forCellReuseIdentifier: "NewHOTableViewCell")
    }
    
    @IBAction func actionCreateProject(_ sender: Any) {
        let vc = Controllers.createProjectHO
        vc!.projectId = 0
        NotificationCenter.default.post(name: Notification.Name("IsCreateNewProject"), object: nil)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension NewHOVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newProjectsListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewHOTableViewCell", for: indexPath) as! NewHOTableViewCell
        cell.descriptionHOLabel.text = self.newProjectsListing[indexPath.row].title ?? ""
        cell.btnNext.tag = indexPath.row
        cell.btnNext.addTarget(self, action: #selector(actionNext(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func actionNext(sender: UIButton) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "NewDetailsHOVC") as? NewDetailsHOVC
        destinationViewController?.projectId = self.newProjectsListing[sender.tag].id ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "NewDetailsHOVC") as? NewDetailsHOVC
        destinationViewController?.projectId = self.newProjectsListing[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
