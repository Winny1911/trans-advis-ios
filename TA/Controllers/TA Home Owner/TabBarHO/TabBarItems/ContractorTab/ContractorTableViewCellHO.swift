//
//  ContractorTableViewCellHO.swift
//  TA
//
//  Created by Dev on 14/12/21.
//

import UIKit

class ContractorTableViewCellHO: UITableViewCell {
    var sendBtn  : (()-> ())?
    var initiateChatAction: (()-> ())?
    var selectedSkills = [String]()
    
    @IBOutlet weak var recmdVwHt: NSLayoutConstraint!
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var lblAllProjects: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewReviewsButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var KeySkillcollectionView: UICollectionView!
    @IBOutlet weak var sendProjectBtn: UIButton!
    @IBOutlet weak var emojiView1: UIView!
    @IBOutlet weak var emojiView2: UIView!
    @IBOutlet weak var emojiView3: UIView!
    @IBOutlet weak var emojiView4: UIView!
    @IBOutlet weak var emojiView5: UIView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var userSkills: [UserSkills]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedSkills.removeAll()
        selectedSkills.removingDuplicates()
        selectedSkills.removeDuplicates()
        backgroudView.layer.masksToBounds = false
        backgroudView.layer.shadowColor = UIColor.lightGray.cgColor
        backgroudView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroudView.layer.shadowRadius = 5.0
        backgroudView.layer.shadowOpacity = 0.5
        backgroudView.layer.shadowOffset = CGSize.zero
        backgroudView.layer.cornerRadius = 5.0
        KeySkillcollectionView.delegate = self
        KeySkillcollectionView.dataSource = self
        sendProjectBtn.addTarget(self, action: #selector(sendButton), for: .touchUpInside)
       
        self.KeySkillcollectionView.register(UINib(nibName: "keySkillCell", bundle: nil), forCellWithReuseIdentifier: "keySkillCell")
      
    }
    
    func userSkill() {
        self.selectedSkills.removeAll()
        for i in 0..<(userSkills?.count ?? 0) {
            if userSkills?[i].projectCategory?.title != nil{
                self.selectedSkills.append(userSkills?[i].projectCategory?.title ?? "")
            }
        }
        self.KeySkillcollectionView.reloadData()
    }
    
    @objc func sendButton(){
        sendBtn?()
    }
        
    @IBAction func sendMessageButtonAction(_ sender: Any) {
        initiateChatAction?()
    }
    
    
   override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
   
}
//MARK:  - Extension CollectionDelegateFlowLayout,delegate and DataSource
extension ContractorTableViewCellHO: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: getWidth(title: userSkillArr[indexPath.row].projectCategory?.title ?? ""), height:25)
        return CGSize(width: getWidth(title: selectedSkills[indexPath.row]), height:25)
      }
    
    func getWidth(title:String) -> CGFloat{
            let font = UIFont(name: PoppinsFont.medium, size: 14)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let myText = title
            let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            return size.width + 25
        }
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSkills.count
        
     }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keySkillCell", for: indexPath) as! keySkillCell
        cell.keySkillLbl.text = selectedSkills[indexPath.item]
        return cell
    }
}
