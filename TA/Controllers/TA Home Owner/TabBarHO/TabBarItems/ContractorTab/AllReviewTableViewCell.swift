//
//  AllReviewTableViewCell.swift
//  TA
//
//  Created by Dev on 15/12/21.
//

import UIKit

class AllReviewTableViewCell: UITableViewCell {
    var viewModel : GetReviewVM = GetReviewVM()
    var conID = Int()
    var index = Int()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImages: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
      //  GetApiHit()
        //print("image====\(viewModel)")
        
        self.collectionView.register(UINib(nibName: "ProjectImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectImagesCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func GetApiHit(){
        self.viewModel.getReviewApiCall(conID){_ in
            print("sucessfull")
            print(self.viewModel.reviewData.count)
            self.collectionView.reloadData()
        }
    }
    
}
//MARK:  - Extension CollectionDelegateFlowLayout
extension AllReviewTableViewCell: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height:80)
     }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.reviewData.count != 0 {
            return viewModel.reviewData[section].ratingImages!.count
        }
       return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectImagesCollectionViewCell", for: indexPath)as? ProjectImagesCollectionViewCell
        {
            if self.viewModel.reviewData[indexPath.section].ratingImages != nil {
                if self.viewModel.reviewData[indexPath.section].ratingImages?.count ?? 0 > 0{
                    if let imgStr = self.viewModel.reviewData[indexPath.section].ratingImages?[index].file{
                        cell.projectImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
}
