//
//  ContractorVC.swift
//  TA
//
//  Created by applify on 21/01/22.
//

import UIKit

class ContractorVC: UIViewController {
    @IBOutlet weak var contractorTableVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contractorTableVw.dataSource = self
        self.contractorTableVw.delegate = self
        registerCell()
        navigationController?.navigationBar.barTintColor = UIColor.green
        
    }
    func registerCell(){
        contractorTableVw.register(UINib.init(nibName: "ContractorTableViewCell", bundle: nil), forCellReuseIdentifier: "ContractorTableViewCell")
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension ContractorVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractorTableViewCell", for: indexPath) as! ContractorTableViewCell
       // cell.descriptionLbl.isHidden = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
