//
//  MaterialDetailsCOVC.swift
//  TA
//
//  Created by Applify on 21/01/22.
//

import UIKit

class MaterialDetailsCOVC: BaseViewController {

    //MARK: Outlet
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var materialImageView: UIImageView!
    @IBOutlet weak var materialNameLbl: UILabel!
    @IBOutlet weak var materialPriceLbl: UILabel!
    @IBOutlet weak var materialDescriptionLbl: UILabel!
    @IBOutlet weak var materialWeightLbl: UILabel!
    @IBOutlet weak var materialSizeLbl: UILabel!
    @IBOutlet weak var materialLbl: UILabel!
    @IBOutlet weak var materialBrandLbl: UILabel!
    @IBOutlet weak var materialCategoryLbl: UILabel!
    @IBOutlet weak var materialSubCategoryLbl: UILabel!
    @IBOutlet weak var materialUserLbl: UILabel!
    
    //MARK: Variable
    var materialCOVM = MaterialCOVM()
    var id = 0
    var profileId = 0
    var veendorLink = ""
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.cornerRadius = 5.0
    }
    
    //MARK: Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.getMaterialDeatialCOAPI()
    }
    
    //MARK: Material Deatial API and Fetching Data
    func getMaterialDeatialCOAPI(){
        var param = [String: Any]()
        param = [
            "id" : id
        ] as [String : Any]
        materialCOVM.getMaterialApiCall(param) { model in
            if model?.data?.allProducts?[0].productFiles?.count ?? 0 > 0 {
                if let imgStr = model?.data?.allProducts?[0].productFiles?[0].file {
                    self.materialImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
                }
            } else{
                self.materialImageView.image = UIImage(named: "emptyImage")
            }
            self.navigationLabel.text = "Material Detail" //model?.data?.allProducts?[0].name ?? ""
            self.materialUserLbl.text = "by \(model?.data?.allProducts?[0].user?.firstName ?? "") \(model?.data?.allProducts?[0].user?.lastName ?? "")"
            self.materialNameLbl.text = model?.data?.allProducts?[0].name ?? ""
//            self.materialPriceLbl.text = "$\(model?.data?.allProducts?[0].price ?? 0)"
            
            var realAmount = "\(model?.data?.allProducts?[0].price ?? 0)"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.materialPriceLbl.text =  "$ \(formattedString ?? "")"
            
            self.materialDescriptionLbl.text = model?.data?.allProducts?[0].allProductDescription ?? ""
            self.materialWeightLbl.text = model?.data?.allProducts?[0].weight ?? ""
            self.materialSizeLbl.text = model?.data?.allProducts?[0].size ?? ""
            self.materialLbl.text = model?.data?.allProducts?[0].material ?? ""
            self.materialBrandLbl.text = model?.data?.allProducts?[0].brand ?? ""
            self.materialCategoryLbl.text = model?.data?.allProducts?[0].category ?? ""
            self.materialSubCategoryLbl.text = model?.data?.allProducts?[0].subCategory ?? ""
            self.profileId = model?.data?.allProducts?[0].userID ?? 0 //id ?? 0
            self.veendorLink = model?.data?.venderDeepLink ?? ""
        }
    }
    
    @IBAction func viewProfileBtnAction(_ sender: Any) {
        let vc = Storyboard.material.instantiateViewController(withIdentifier: "VendorDetailVC") as? VendorDetailVC
        //vc!.profileId = profileId
        vc!.vandorLink = veendorLink + "\(profileId)"
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    //MARK: Back ButtonAction
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}
