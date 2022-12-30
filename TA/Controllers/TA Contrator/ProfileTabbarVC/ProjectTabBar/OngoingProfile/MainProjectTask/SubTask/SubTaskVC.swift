//
//  SubTaskVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class SubTaskVC: BaseViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var oredrMaterialButton: UIButton!
    @IBOutlet weak var transactionsButton: UIButton!
    @IBOutlet weak var projectFileCollectionView: UICollectionView!
   // @IBOutlet weak var addProjectFileButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sentMessageButton: UIButton!
    var item = ["item 1","item 2","item 3","item 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //bottomView.isHidden = true
        
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bottomView.layer.shadowRadius = 5.0
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = CGSize.zero
        
        sentMessageButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        sentMessageButton.layer.borderWidth = 1.5
        
        projectFileCollectionView.delegate = self
        projectFileCollectionView.dataSource = self
        
        oredrMaterialButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        oredrMaterialButton.layer.borderWidth = 1.5
        transactionsButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        transactionsButton.layer.borderWidth = 1.5
       // addProjectFileButton.layer.borderColor = (UIColor( red: 250/255, green: 147/255, blue:101/255, alpha: 1.0 )).cgColor
       // addProjectFileButton.layer.borderWidth = 0.5
        
        self.projectFileCollectionView.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        
        blackView.isHidden = true

    }
    
    @IBAction func orderMaterialBtnAction(_ sender: Any) {
//        let destinationVC = Storyboard.subTask.instantiateViewController(withIdentifier: "SubTaskOrderMaterialVC") as! SubTaskOrderMaterialVC
//        self.present(destinationVC,animated:  true)
    }
    @IBAction func markCompletedBtnAction(_ sender: Any) {
        blackView.isHidden = false
    }
    @IBAction func cancelTaskBtnAction(_ sender: Any) {
        blackView.isHidden = true
    }
    @IBAction func tapDIdAddProjectFileButton(_ sender: UIButton) {
        item.append("item n")
        projectFileCollectionView.reloadData()
    }
}

// MARK: Extension CollectionDelegateFlowLayout
extension SubTaskVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height:61)
    }
}

extension SubTaskVC: UICollectionViewDelegate{
    
}

extension SubTaskVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath)as? ProjectFileCollecrtionView
        {
            return cell
        }
        return UICollectionViewCell()
    }
}
