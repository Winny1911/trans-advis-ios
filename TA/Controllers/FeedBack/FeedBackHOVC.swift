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
 
    var arrRatingValue = [Int]()
    
    var questionArr = ["Are you happy with the level of service that the Contractor provided you with?","How would you rank how well the contractor coordinated with you through the project?","What would you rank your overall experience with this Contractor to be?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        nameLbl.text = "\(firstName) \(lastNmae)"
        
        for i in 0 ..< self.questionArr.count {
            self.arrRatingValue.append(-1)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Register Cell
      func registerCell(){
            tableView.register(UINib.init(nibName: "FeedBackHOTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedBackHOTableViewCell")
    }
    
    

    @IBAction func NextButtonTapAction(_ sender: Any) {
//        if self.arrRatingValue.contains(-1){
//            showMessage(with: "Please response all", theme: .error)
//        }else{
            let vc = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackSubmitVC") as! FeedBackSubmitVC
            vc.ratingOne = "\(self.arrRatingValue[0])"
            vc.ratingTwo = "\(self.arrRatingValue[1])"
            vc.ratingThree = "\(self.arrRatingValue[2])"
            vc.name = self.firstName
            vc.lastName = self.lastNmae
            vc.projectId = "\(self.projectID)"
            vc.contractorId = "\(self.contractorID)"
            vc.completionHandlerGoToOnPastListing = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.completionHandlerGoToOnPastListing?()
            }
            navigationController?.pushViewController(vc, animated: true)
       // }
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
        
        cell.btn1.tag = (100 * indexPath.row) + 4
        cell.btn2.tag = (100 * indexPath.row) + 3
        cell.btn3.tag = (100 * indexPath.row) + 2
        cell.btn4.tag = (100 * indexPath.row) + 1
        cell.btn5.tag = (100 * indexPath.row) + 0
        
        cell.btn1.addTarget(self, action: #selector(tapEmojiButton), for: .touchUpInside)
        cell.btn2.addTarget(self, action: #selector(tapEmojiButton), for: .touchUpInside)
        cell.btn3.addTarget(self, action: #selector(tapEmojiButton), for: .touchUpInside)
        cell.btn4.addTarget(self, action: #selector(tapEmojiButton), for: .touchUpInside)
        cell.btn5.addTarget(self, action: #selector(tapEmojiButton), for: .touchUpInside)
        
        if self.arrRatingValue[indexPath.row] == 0 {
            cell.emojiVw5.isHidden = true
        } else if self.arrRatingValue[indexPath.row] == 1 {
            cell.emojiVw4.isHidden = true
        } else if self.arrRatingValue[indexPath.row] == 2 {
            cell.emojiVw3.isHidden = true
        } else if self.arrRatingValue[indexPath.row] == 3 {
            cell.emojiVw2.isHidden = true
        } else if self.arrRatingValue[indexPath.row] >= 4 {
            cell.emojiVw1.isHidden = true
        }
        cell.questionLbl.text = questionArr[indexPath.row]
        return cell
    }
    
    @objc func tapEmojiButton(sender:UIButton){
        let buttonNumber = sender.tag % 100
        let cellNumber = sender.tag / 100
        self.arrRatingValue[cellNumber] = buttonNumber
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
