//
//  PastHOVC.swift
//  TA
//
//  Created by Dev on 10/12/21.
//

import UIKit

class PastHOVC: BaseViewController {

    
    @IBOutlet weak var noPastProjectLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let pastProjectsHOViewModel: PastProjectVM = PastProjectVM()
    var pastProjectsListing = [AllPastProject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
    }
    
    //MARK: - REGISTER CELL
    func registerCell() {
        tableView.register(UINib.init(nibName: "NewHOTableViewCell", bundle: nil), forCellReuseIdentifier: "NewHOTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pastProjectDetail()
    }
    func pastProjectDetail(){
        let param = ["status":3]
        pastProjectsHOViewModel.getPastProjectApi(param) { response in
            self.pastProjectsListing = response?.data?.allProjects ?? []
            self.tableView.isHidden = false
            if self.pastProjectsListing.count <= 0 {
                self.tableView.isHidden = true
                self.noPastProjectLbl.isHidden = false
            } else {
                self.tableView.reloadData()
                self.noPastProjectLbl.isHidden = true
                
            }
        }
    }
}

extension PastHOVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.pastHO.instantiateViewController(withIdentifier: "PastProjectDetailHOVC") as? PastProjectDetailHOVC
        destinationViewController?.id = self.pastProjectsListing[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  pastProjectsListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewHOTableViewCell", for: indexPath) as! NewHOTableViewCell
        cell.descriptionHOLabel.text = self.pastProjectsListing[indexPath.row].title ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

