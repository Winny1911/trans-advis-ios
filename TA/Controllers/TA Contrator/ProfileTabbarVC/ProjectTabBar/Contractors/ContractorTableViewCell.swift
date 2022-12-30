//
//  ContractorTableViewCell.swift
//  TA
//
//  Created by applify on 21/01/22.
//

import UIKit

class ContractorTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var descreptionLbl: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emojiVwOne: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.addCustomShadow()
        descreptionLbl.isHidden = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "KeySkillCollectionVwCell", bundle: nil), forCellWithReuseIdentifier: "KeySkillCollectionVwCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewReviewBtnAction(_ sender: Any) {
    }
}
extension ContractorTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeySkillCollectionVwCell", for: indexPath) as! KeySkillCollectionVwCell
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return(CGSize(width: 100, height: 30))
    }

}

