//
//  VenderProfilesCOVC.swift
//  TA
//
//  Created by Applify on 17/02/22.
//

import UIKit

class VenderProfilesCOVC: BaseViewController {

    @IBOutlet weak var collVwHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var venderImageView: UIImageView!
    @IBOutlet weak var venderNameLbl: UILabel!
    @IBOutlet weak var numberOfOrderDeliveredLbl: UILabel!
    @IBOutlet weak var TAIdLbl: UILabel!
    @IBOutlet weak var vendorAddressLbl: UILabel!
    @IBOutlet weak var vendorAboutLbl: UILabel!
    @IBOutlet weak var vendorProductLbl: UILabel!
    @IBOutlet weak var vendorProductCollectionView: UICollectionView!
    
    var materialCOVM = MaterialCOVM()
    var vendorProfileVM: VendorProfileCOVM = VendorProfileCOVM()
    var id = 0
    var allMaterialCOData: [MaterialDetailCOData]?
    var vendorDeepLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.vendorProductCollectionView.delegate = self
        self.vendorProductCollectionView.dataSource = self
        self.vendorProductCollectionView.register(UINib(nibName: "MaterialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MaterialCollectionViewCell")
        self.fetchVendorProfile()
    }
    
    func fetchVendorProfile(){
        var param = [String: Any]()
        param = [
            "id" : id
        ] as [String : Any]
        vendorProfileVM.getVendorProfileCODataApi(param) { model in
            self.venderImageView.sd_setImage(with: URL(string: (model?.data?.profilePic) ?? ""), placeholderImage: UIImage(named: "ic_HO_profile"), completed: nil)
            self.venderNameLbl.text = "\(model?.data?.firstName ?? "") \(model?.data?.lastName ?? "")"
            self.vendorDeepLink = ""
            self.vendorDeepLink = model?.data?.venderDeepLink ?? ""
            self.vendorAddressLbl.text = "\(model?.data?.addressLine1 ?? ""), \(model?.data?.city ?? ""), \(model?.data?.state ?? "")"
            self.numberOfOrderDeliveredLbl.text = "\(model?.data?.productsCount ?? 0)"
            self.TAIdLbl.text = "\(model?.data?.id ?? 0)"
            self.fetchFilterMaterialVendor()
        }
    }

    //MARK: Fetch Filter Material Vendor API
    func fetchFilterMaterialVendor() {
        var param = [String: Any]()
        param = [
            "vendorId" : self.id
        ] as [String : Any]
        materialCOVM.getMaterialVendorApiCall(param) { model in
            self.allMaterialCOData?.removeAll()
            self.allMaterialCOData = model?.data?.listing ?? []
            self.vendorProductLbl.text = "Products (\(self.allMaterialCOData?.count ?? 0))"
            self.vendorProductCollectionView.reloadData()
            if self.allMaterialCOData?.count ?? 0 > 0 {
                if (self.allMaterialCOData?.count)! % 2 == 0 {
                    let count = (self.allMaterialCOData?.count)! / 2
                    self.collVwHeight.constant = CGFloat((160 * count) + 50)
                } else {
                    let count = ((((self.allMaterialCOData?.count)!) + 1) / 2)
                    self.collVwHeight.constant = CGFloat((160 * count) + 50)
                }
            } else {
                self.collVwHeight.constant = 0.0
            }
            
        }
    }
    
    @IBAction func backToButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callingButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
//        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
//          let objectsToShare = [name]
//          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//          self.present(activityVC, animated: true, completion: nil)
//        } else {
//          // show alert for not available
//        }
        let items = ["Hey! Check out this vendor I found on the Transaction Advisor platform that might be useful for you. \(self.vendorDeepLink)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}

// MARK: Extension CollectionDelegateFlowLayout
extension VenderProfilesCOVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 2.4, height:160.0)
    }
}

extension VenderProfilesCOVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMaterialCOData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaterialCollectionViewCell", for: indexPath) as? MaterialCollectionViewCell
        {
            cell.stckVwHt.constant = 0.0
            cell.addedToOrderbutton.isHidden = true
            if self.allMaterialCOData?[indexPath.row].productFiles?.count ?? 0 > 0 {
                if let imgStr = allMaterialCOData?[indexPath.row].productFiles?[0].file {
                    cell.materialImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
                }
            } else{
                cell.materialImageView.image = UIImage(named: "emptyImage")
            }
            
            cell.addedToOrderbutton.isHidden = true
            cell.materialName.text = allMaterialCOData?[indexPath.row].name ?? ""
            cell.materialPrice.text = "$ \(allMaterialCOData?[indexPath.row].price ?? 0)"
            return cell
        }
        return UICollectionViewCell()
    }
}

