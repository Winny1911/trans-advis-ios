//
//  FeedBackHOVC.swift
//  TA
//
//  Created by applify on 03/03/22.
//

import UIKit

class FeedBackHOVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    var completionHandlerGoToOnPastListing: (() -> Void)?
    var DataPass = [String]()
    var projectID = Int()
    var contractorID = Int()
    var firstName = String()
    var lastNmae = String()
    var rating1 = 0
    var rating2 = 0
    var rating3 = 0
 
    var questionArr = ["Are you happy with the level of service that the Contractor provided you with?","How would you rank how well the contractor coordinated with you through the project?","What would you rank your overall experience with this Contractor to be?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        nameLbl.text = firstName
        
        // Do any additional setup after loading the view.
    }
    //MARK:- Register Cell
      func registerCell(){
            tableView.register(UINib.init(nibName: "FeedBackHOTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedBackHOTableViewCell")
    }
    
    

    @IBAction func NextButtonTapAction(_ sender: Any) {
        if rating1 == 0 || rating2 == 0 || rating3 == 0{
            //desable button
        }else{
            let vc = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackSubmitVC") as! FeedBackSubmitVC
            vc.ratingOne = "\(self.rating1 )" ?? ""
            vc.ratingTwo = "\(self.rating2 )" ?? ""
            vc.ratingThree = "\(self.rating3 )" ?? ""
            vc.name = self.firstName ?? ""
            vc.lastName = self.lastNmae ?? ""
            vc.projectId = "\(self.projectID)" ?? ""
            vc.contractorId = "\(self.contractorID)" ?? ""
            vc.completionHandlerGoToOnPastListing = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.completionHandlerGoToOnPastListing?()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
extension FeedBackHOVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedBackHOTableViewCell", for: indexPath) as! FeedBackHOTableViewCell
        cell.emojiVw1.isHidden = false
        cell.emojiVw2.isHidden = false
        cell.emojiVw3.isHidden = false
        cell.emojiVw4.isHidden = false
        cell.emojiVw5.isHidden = false
        if indexPath.row == 0{
            cell.btnTapAction1 = {
                () in
                cell.emojiVw1.isHidden = true
                self.rating1 = 1
            }
            cell.btnTapAction2 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = true
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating1 = 2
            }
            cell.btnTapAction3 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = true
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating1 = 3
            }
            cell.btnTapAction4 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = true
                cell.emojiVw5.isHidden = false
                self.rating1 = 4
            }
            cell.btnTapAction5 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = true
                self.rating1 = 5
            }
        }
        if indexPath.row == 1{
            cell.btnTapAction1 = {
                () in
                cell.emojiVw1.isHidden = true
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating2 = 1
            }
            cell.btnTapAction2 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = true
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating2 = 2
            }
            cell.btnTapAction3 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = true
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating2 = 3
            }
            cell.btnTapAction4 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = true
                cell.emojiVw5.isHidden = false
                self.rating2 = 4
            }
            cell.btnTapAction5 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = true
                self.rating2 = 5
            }
        }
        if indexPath.row == 2{
            cell.btnTapAction1 = {
                () in
                cell.emojiVw1.isHidden = true
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating3 = 1
            }
            cell.btnTapAction2 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = true
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating3 = 2
            }
            cell.btnTapAction3 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = true
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = false
                self.rating3 = 3
            }
            cell.btnTapAction4 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = true
                cell.emojiVw5.isHidden = false
                self.rating3 = 4
            }
            cell.btnTapAction5 = {
                () in
                cell.emojiVw1.isHidden = false
                cell.emojiVw2.isHidden = false
                cell.emojiVw3.isHidden = false
                cell.emojiVw4.isHidden = false
                cell.emojiVw5.isHidden = true
                self.rating3 = 5
            }
        }
        cell.questionLbl.text = questionArr[indexPath.row]
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
