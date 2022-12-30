//
//  SelectProjectToSendHOVC.swift
//  TA
//
//  Created by Dev on 21/12/21.
//

import UIKit

class SelectProjectToSendHOVC: BaseViewController {

    let SentProjectViewModel: SendProjectVM = SendProjectVM()
    var constID = Int()
    var sentArr = [String]()
    
    var projectId = 0
    var arrSelectedProjects = [String]()
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var listingTableView: UITableView!
    let ProjectsHOViewModel: NewProjectsHOViewModel = NewProjectsHOViewModel()
    var ProjectsListing = [NewProjectsDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoData.isHidden = true
        self.listingTableView.delegate = self
        self.listingTableView.dataSource = self
        
        self.registerCell()
        self.bgView.roundCorners(corners: [.topLeft, .topRight], radius:18.0)
        self.allProjectDetailAPIcall()
    }
    
    func allProjectDetailAPIcall(){
        let param = ["status":1, "invitedUserId":self.constID]
        ProjectsHOViewModel.getNewProjectApi(param) { response in
            self.ProjectsListing = response?.data?.allProjects ?? []
            if self.ProjectsListing.count <= 0 {
                self.lblNoData.isHidden = false
            } else {
                self.lblNoData.isHidden = true
            }
            for i in 0 ..< self.ProjectsListing.count {
                if self.ProjectsListing[i].id == self.projectId {
                    if self.projectId != 0 {
                        self.arrSelectedProjects.append("\(self.projectId)")
                    }
                }
            }
            self.listingTableView.reloadData()
        }
    }
    
    //MARK: - REGISTER CELL
    func registerCell() {
        listingTableView.register(UINib.init(nibName: "SelectionProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionProjectTableViewCell")
        }
    
    @IBAction func sendProjectsActionBtn(_ sender: Any) {
        if arrSelectedProjects.count <= 0 {
            showMessage(with: ValidationError.emptySelectedProject, theme: .error)
        } else {
            SentProjectViewModel.sendProjectApiCall("\(constID)", arrSelectedProjects) { model in
                showMessage(with: SucessMessage.projectSentSuccessfully, theme: .success)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

//MARK: UITableViewDelegate and Datasource
extension SelectProjectToSendHOVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProjectsListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionProjectTableViewCell", for: indexPath) as? SelectionProjectTableViewCell {
            cell.tittleLabel.text = ProjectsListing[indexPath.row].title
            cell.checkButton.tag = indexPath.row
            cell.checkButton.addTarget(self, action: #selector(selectProject(sender:)), for: .touchUpInside)
            if self.arrSelectedProjects.contains("\(self.ProjectsListing[indexPath.row].id ?? 0)") {
                cell.checkButton.setImage(UIImage(named: "ic_checkbox_filled"), for: .normal)
            } else {
                cell.checkButton.setImage(UIImage(named: "ic_check_box"), for: .normal)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func selectProject(sender: UIButton) {
        if (self.arrSelectedProjects.contains("\(self.ProjectsListing[sender.tag].id ?? 0)")) {
            let indx = self.arrSelectedProjects.firstIndex(of: ("\(self.ProjectsListing[sender.tag].id ?? 0)"))
            self.arrSelectedProjects.remove(at: indx ?? 0)
        } else {
            self.arrSelectedProjects.append("\(self.ProjectsListing[sender.tag].id ?? 0)")
        }
        self.listingTableView.reloadData()
    }
}
