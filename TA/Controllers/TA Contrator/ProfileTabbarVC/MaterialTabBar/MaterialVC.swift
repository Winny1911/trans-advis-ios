//
//  MaterialsVC.swift
//  TA
//
//  Created by Designer on 16/12/21.
//

import UIKit
import SDWebImage

class MaterialVC: BaseViewController {

    //MARK: Outlet
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var btnVwHt: NSLayoutConstraint!
    @IBOutlet weak var lblNoRecords: UILabel!
    @IBOutlet weak var searchTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var priceOfOrderList: UILabel!
    @IBOutlet weak var numberOforderList: UILabel!
    @IBOutlet weak var addedOrderListBtn: UIButton!
    @IBOutlet weak var orderStackView: UIStackView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var materialCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var materialLbl: UILabel!
    @IBOutlet weak var orderListLbl: UILabel!
    
    //MARK: Variable
    var materialCOVM = MaterialCOVM()
    var allMaterialCOData: [MaterialDetailCOData]?
    var selectedMaterialCOData = [MaterialDetailCOData]()
    var orderMaterialFlow = ""
    var seletedIndexes = [Int]()
    
    var vendorId = 0
    var category = ""
    
    var mainProejctId = 0
    var subTaskId = 0
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoRecords.isHidden = true
        selectedMaterialCOData.removeAll()
        seletedIndexes.removeAll()
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.cornerRadius = 5.0
        
        self.txtFldSearch.delegate = self
        
        btnCross.isHidden = true
        viewFilter.setRoundCorners(radius: 12.0)
        viewSearch.setRoundCorners(radius: 6.0)
        
        self.materialCollectionView.delegate = self
        self.materialCollectionView.dataSource = self
        self.materialCollectionView.register(UINib(nibName: "MaterialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MaterialCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNotificationIcon), name: Notification.Name.newNotification, object: nil)
    }
    
    @objc func setNotificationIcon() {
        self.setNotification(notificationBtn: self.notificationBtn)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllInboxMessagesForRedDot()
        self.setNotification(notificationBtn: self.notificationBtn)
        
        self.txtFldSearch.text = ""
        if orderMaterialFlow == "orderMaterialFlow" {
            self.notificationView.isHidden = true
            self.notificationButton.isHidden = true
            self.btnVwHt.constant = 56.0
            self.searchTrailingSpace.constant = -55.0
            self.backButton.isHidden = false
            self.orderListLbl.isHidden = false
            self.materialLbl.isHidden = true
            self.orderView.isHidden = false
            self.orderStackView.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            fetchFilterMaterialVendor()
        } else {
            self.btnVwHt.constant = 0.0
            self.searchTrailingSpace.constant = 13.0
            self.backButton.isHidden = true
            self.orderListLbl.isHidden = true
            self.materialLbl.isHidden = false
            self.orderView.isHidden = true
            self.orderStackView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            self.fetchFilterMaterial()
        }
    }
    
    @IBAction func actionNotifications(_ sender: Any) {
        let vc = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addedToOrderListAction(_ sender: UIButton) {
        if self.selectedMaterialCOData.count > 0 {
            let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderItemListVC") as? OrderItemListVC
            destinationViewController?.mainProejctId = self.mainProejctId
            destinationViewController?.subTaskId = self.subTaskId
            destinationViewController?.vendorId = self.vendorId
            destinationViewController?.selectedMaterialCOData = self.selectedMaterialCOData
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        } else {
            showMessage(with: "Please select atleast one item", theme: .error)
        }
    }
    
    //MARK: Fetch Filter Material Vendor API
    func fetchFilterMaterialVendor() {
        let searchedString = self.txtFldSearch.text?.trimmed ?? ""
        var param = [String: Any]()
        param = [
            "search" : searchedString,
            "vendorId" : self.vendorId,
            "category" : self.category
        ] as [String : Any]
        materialCOVM.getMaterialVendorApiCall(param) { model in
            self.allMaterialCOData?.removeAll()
            self.allMaterialCOData = model?.data?.listing ?? []
            if self.allMaterialCOData?.count ?? 0 <= 0 {
                self.lblNoRecords.isHidden = false
            } else {
                self.lblNoRecords.isHidden = true
            }
                
            self.materialCollectionView.reloadData()
        }
    }
    
    //MARK: Fetch Filter Material API
    func fetchFilterMaterial() {
        let searchedString = self.txtFldSearch.text?.trimmed ?? ""
        var arrayOfFilterState = [String]()
        var arrayOfFilterCategory = [Int]()
        var arrayOfFilterFirstNAme = [String]()
        var filterDict = [String:Any]()
        var filterArray = [[String:Any]]()
        
        if let stateArr = UserDefaults.standard.value(forKey: "MaterialFilterStateCO") as? [String] {
            if stateArr.count > 0 {
                arrayOfFilterState = stateArr
            }
        }
        
        if let categoryArr = UserDefaults.standard.value(forKey: "MaterialFilterCategoryCOID") as? [Int] {
            if categoryArr.count > 0 {
                arrayOfFilterCategory = categoryArr
            }
        }
        
        if let firstNameArr = UserDefaults.standard.value(forKey: "MaterialFilterFirstNameCO") as? [String] {
            if firstNameArr.count > 0 {
                arrayOfFilterFirstNAme = firstNameArr
            }
        }
        
        if arrayOfFilterState.count > 0 && arrayOfFilterCategory.count > 0 && arrayOfFilterFirstNAme.count > 0{
            filterDict = ["category":arrayOfFilterCategory, "location":arrayOfFilterState, "firstName": arrayOfFilterFirstNAme] as [String : Any]
        } else if arrayOfFilterCategory.count > 0 && arrayOfFilterState.count == 0 && arrayOfFilterFirstNAme.count == 0{
            filterDict = ["category":arrayOfFilterCategory] as [String : Any]
        } else if arrayOfFilterCategory.count == 0 && arrayOfFilterState.count > 0 && arrayOfFilterFirstNAme.count == 0 {
            filterDict = ["location":arrayOfFilterState] as [String : Any]
        } else if arrayOfFilterFirstNAme.count > 0 && arrayOfFilterState.count == 0 && arrayOfFilterCategory.count == 0 {
            filterDict = ["firstName":arrayOfFilterFirstNAme] as [String : Any]
        } else if arrayOfFilterFirstNAme.count > 0 && arrayOfFilterState.count > 0 && arrayOfFilterCategory.count == 0 {
            filterDict = ["firstName":arrayOfFilterFirstNAme, "location":arrayOfFilterState] as [String : Any]
        } else if arrayOfFilterFirstNAme.count == 0 && arrayOfFilterState.count > 0 && arrayOfFilterCategory.count > 0 {
            filterDict = ["category":arrayOfFilterCategory, "location":arrayOfFilterState] as [String : Any]
        } else if arrayOfFilterFirstNAme.count > 0 && arrayOfFilterState.count == 0 && arrayOfFilterCategory.count > 0 {
            filterDict = ["category":arrayOfFilterCategory, "firstName":arrayOfFilterFirstNAme] as [String : Any]
        } else {
            filterDict = [String:Any]()
        }
        filterArray.removeAll()
        filterArray.append(filterDict)
        var param = [String: Any]()
        param = [
            "filter": filterDict,
            "search" : searchedString
        ] as [String : Any]
        materialCOVM.getMaterialApiCall(param) { model in
            self.allMaterialCOData?.removeAll()
            self.allMaterialCOData = model?.data?.allProducts ?? []
            if self.allMaterialCOData?.count ?? 0 <= 0 {
                self.lblNoRecords.isHidden = false
            } else {
                self.lblNoRecords.isHidden = true
            }
            self.materialCollectionView.reloadData()
        }
    }
    
    //MARK: Search Cross Button Action
    @IBAction func searchCrossButtonAction(_ sender: UIButton) {
        self.txtFldSearch.text = ""
        self.btnCross.isHidden = true
        self.txtFldSearch.resignFirstResponder()
        if orderMaterialFlow == "orderMaterialFlow" {
            fetchFilterMaterialVendor()
        } else {
            fetchFilterMaterial()
        }
    }
    
    //MARK: Search Filter Button Action
    @IBAction func tapDidFilterButtonAction(_ sender: UIButton) {
        let destinationViewController = Storyboard.material.instantiateViewController(withIdentifier: "MaterialFilterCOVC") as? MaterialFilterCOVC
        destinationViewController!.completionHandlerGoToMaterialScreen = { [weak self] in
            self!.fetchFilterMaterial()
        }
        self.present(destinationViewController!, animated: true)
    }
}

// MARK: Extension CollectionDelegateFlowLayout
extension MaterialVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orderMaterialFlow == "orderMaterialFlow" {
            return CGSize(width: view.frame.size.width / 2.2, height:196.0)
        } else {
            return CGSize(width: view.frame.size.width / 2.2, height:160.0)
        }
    }
}

// MARK: Extension CollectionView Delegate
extension MaterialVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = Storyboard.material.instantiateViewController(withIdentifier: "MaterialDetailsCOVC") as? MaterialDetailsCOVC
        destinationViewController?.id = allMaterialCOData?[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
}

// MARK: Extension CollectionView DataSource
extension MaterialVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMaterialCOData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaterialCollectionViewCell", for: indexPath) as? MaterialCollectionViewCell {
            if orderMaterialFlow == "orderMaterialFlow" {
                if self.seletedIndexes.contains(indexPath.row) {
                    cell.addedToOrderbutton.setTitle("Added To Order List", for: .normal)
                    cell.addedToOrderbutton.backgroundColor = UIColor.appColorGreen
                    cell.addedToOrderbutton.setTitleColor(UIColor.white, for: .normal)
                } else {
                    cell.addedToOrderbutton.setTitle("Add To Order List", for: .normal)
                    cell.addedToOrderbutton.backgroundColor = UIColor.white
                    cell.addedToOrderbutton.setTitleColor(UIColor.appColorGreen, for: .normal)
                }
                cell.addedToOrderbutton.tag = indexPath.row
                cell.addedToOrderbutton.addTarget(self, action: #selector(self.addToOrder), for: .touchUpInside)
                cell.stckVwHt.constant = 36.0
                cell.addedToOrderbutton.isHidden = false
            } else {
                cell.stckVwHt.constant = 0.0
                cell.addedToOrderbutton.isHidden = true
            }
            if self.allMaterialCOData?[indexPath.row].productFiles?.count ?? 0 > 0 {
                if let imgStr = allMaterialCOData?[indexPath.row].productFiles?[0].file {
                    cell.materialImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
                }
            } else{
                cell.materialImageView.image = UIImage(named: "emptyImage")
            }
            cell.materialName.text = self.allMaterialCOData?[indexPath.row].name ?? ""
//            cell.materialPrice.text = "$\(self.allMaterialCOData?[indexPath.row].price ?? Double(0.0))"
            
            var realAmount = "\(self.allMaterialCOData?[indexPath.row].price ?? Double(0.0))"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            cell.materialPrice.text =  "$ \(formattedString ?? "")"
            return cell
        }
        return UICollectionViewCell()
    }
    
    @objc func addToOrder(sender: UIButton) {
        if seletedIndexes.contains(sender.tag) {
            let indx = seletedIndexes.firstIndex(of: sender.tag)
            self.seletedIndexes.remove(at: indx!)
            self.selectedMaterialCOData.remove(at: indx!)
        } else {
            self.selectedMaterialCOData.append((self.allMaterialCOData?[sender.tag])!)
            self.seletedIndexes.append(sender.tag)
        }
        self.numberOforderList.text = "Order List(\(self.selectedMaterialCOData.count ))"
        var totalPrice = Double(0.0)
        if self.selectedMaterialCOData.count > 0 {
            for i in 0 ..< self.selectedMaterialCOData.count {
                totalPrice = totalPrice + self.selectedMaterialCOData[i].price!
            }
            self.priceOfOrderList.text = "$ \(totalPrice)"
        } else {
            self.priceOfOrderList.text = "$ \(0)"
        }
        self.materialCollectionView.reloadData()
    }
}

// MARK: Extension Textfield Delegate
extension MaterialVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.btnCross.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFldSearch {
            self.btnCross.isHidden = true
            if orderMaterialFlow == "orderMaterialFlow" {
                self.fetchFilterMaterialVendor()
            } else {
                self.fetchFilterMaterial()
            }
        }
    }
}
