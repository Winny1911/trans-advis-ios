//
//  AllReviewTableViewCell.swift
//  TA
//
//  Created by Dev on 15/12/21.
//

import UIKit

class AllReviewTableViewCell: UITableViewCell {
    var viewModel : GetReviewVM = GetReviewVM()
    var viewModelCO : GetReviewCOVM = GetReviewCOVM()
    var conID = Int()
    var index = Int()
    var isContractor = Bool()
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
        //GetApiHit()
        
        
        self.collectionView.register(UINib(nibName: "ProjectImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectImagesCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func GetApiHit(){
        if isContractor {
            self.viewModelCO.getReviewApiCall(conID){_ in
                print("sucessfull")
                print(self.viewModelCO.reviewData.count)
                self.collectionView.reloadData()
            }
        } else {
            self.viewModel.getReviewApiCall(conID){_ in
                print("sucessfull")
                print(self.viewModel.reviewData.count)
                self.collectionView.reloadData()
            }
        }
    }
    
}
//MARK:  - Extension CollectionDelegateFlowLayout
extension AllReviewTableViewCell: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height:80)
     }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isContractor {
            if viewModelCO.reviewData.count != 0 {
                return viewModelCO.reviewData[index].ratingImages!.count
            }
        } else {
            if viewModel.reviewData.count != 0 {
                return viewModel.reviewData[index].ratingImage!.count
                
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectImagesCollectionViewCell", for: indexPath) as? ProjectImagesCollectionViewCell
        {
            if isContractor {
                guard self.viewModelCO.reviewData[index].ratingImages != nil ||
                        self.viewModelCO.reviewData[index].ratingImages?.count ?? 0 > 0 ||
                        self.viewModelCO.reviewData[index].ratingImages?[index] == nil else {
                    return cell
                }
                
                let imgStr = self.viewModelCO.reviewData[index].ratingImages![indexPath.item]
                
                cell.projectImages.sd_setImage(with: URL(string: imgStr.file ?? ""), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
            } else {
                guard self.viewModel.reviewData[index].ratingImage != nil ||
                        self.viewModel.reviewData[index].ratingImage?.count ?? 0 > 0 ||
                        self.viewModel.reviewData[index].ratingImage?[index] == nil else {
                    return cell
                }
                print("descricao do projeto --->>>\(self.viewModel.reviewData[index].overAllFeedback)")
                print("Imagem do projeto --->>>\(self.viewModel.reviewData[index].ratingImage![indexPath.item].file)")
                if self.viewModel.reviewData[index].overAllFeedback == "message CO to HO good" {
                    cell.projectImages.image = UIImage(named: "emptyImage")
                    return cell
                }
                let imgStr = self.viewModel.reviewData[index].ratingImage![indexPath.item]
                if imgStr.file != nil {
                    cell.projectImages.sd_setImage(with: URL(string: imgStr.file!), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
                } else {
                    cell.projectImages.image = UIImage(named: "emptyImage")
                }
                
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
}
