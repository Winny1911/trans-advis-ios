//
//  OrderItemListVC.swift
//  TA
//
//  Created by Applify on 14/02/22.
//

import UIKit
import MapKit
import CoreLocation

class OrderItemListVC: BaseViewController {

    @IBOutlet weak var popUpVw: UIView!
    @IBOutlet weak var blackVw: UIView!
    @IBOutlet weak var navigationLbl: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var addressTextField: FloatingLabelInput!
    @IBOutlet weak var stateTextField: FloatingLabelInput!
    @IBOutlet weak var cityTextField: FloatingLabelInput!
    @IBOutlet weak var zipCodeTextField: FloatingLabelInput!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
        
    var selectedMaterialCOData = [MaterialDetailCOData]()
    var arrOfQuantity = [String]()
    
    var vendorId = 0
    var mainProejctId = 0
    var subTaskId = 0
    var materialCOVM = MaterialCOVM()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpVw.setRoundCorners(radius: 10.0)
        popUpVw.isHidden = true
        blackVw.isHidden = true
        self.navigationLbl.text = "Order Item List(\(self.selectedMaterialCOData.count))"
        self.itemTableView.delegate = self
        self.itemTableView.dataSource = self
        self.itemTableView.separatorColor = UIColor.clear
        self.registerCells()
        self.tableViewHeight.constant = CGFloat(selectedMaterialCOData.count * 100)
        
        self.arrOfQuantity.removeAll()
        for i in 0 ..< self.selectedMaterialCOData.count {
            self.arrOfQuantity.append("1")
        }
        self.addressTextField.setLeftPadding(14)
        self.stateTextField.setLeftPadding(14)
        self.cityTextField.setLeftPadding(14)
        self.zipCodeTextField.setLeftPadding(14)
        
        self.addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.stateTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.zipCodeTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.quantityUpdated(notification:)), name: Notification.Name("QuantityUpdated"), object: nil)
        self.setloaction()
        self.updatePrice()
        
    }
    
    @objc func quantityUpdated(notification: Notification) {
        for i in 0 ..< self.selectedMaterialCOData.count {
            let cell = itemTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! OrderListItemTableViewCell
            if cell.itemQtyTextField.text == "" || cell.itemQtyTextField.text == nil {
                cell.itemQtyTextField.text = "0"
                self.arrOfQuantity[i] = "0"
            } else {
                self.arrOfQuantity[i] = cell.itemQtyTextField.text ?? "0"
            }
        }
        self.updatePrice()
    }
    
    func updatePrice(){
        var totalPrice = Double(0.0)
        if self.selectedMaterialCOData.count > 0 {
            for i in 0 ..< self.selectedMaterialCOData.count {
                let spePrice = (self.selectedMaterialCOData[i].price!) * (Double(Int(self.arrOfQuantity[i]) ?? 1))
                totalPrice = totalPrice + spePrice
            }
            self.totalPrice.text = "$ \(totalPrice)"
        } else {
            self.totalPrice.text = "$ \(0)"
        }
    }
    
    func setloaction() {
        if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            self.addressTextField.text = obj.addressLine1
            self.addressTextField.resetFloatingLable()
            
            self.cityTextField.text = obj.city
            self.cityTextField.resetFloatingLable()
            
            self.stateTextField.text = obj.state
            self.stateTextField.resetFloatingLable()
            
            self.zipCodeTextField.text = obj.zipCode
            self.zipCodeTextField.resetFloatingLable()
        }
    }
    
    func registerCells() {
        itemTableView.register(UINib.init(nibName: "OrderListItemTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListItemTableViewCell")
    }
    
    //MARK: Sent Order Action
    @IBAction func sentOrderRequestButtonAction(_ sender: UIButton) {
        var param = [String: Any]()
        var cartArr = [[String:Any]]()
        for i in 0 ..< selectedMaterialCOData.count {
            var dict = [String:Any]()
            dict["productId"] = "\(selectedMaterialCOData[i].id ?? 0)"
            dict["item"] = selectedMaterialCOData[i].name ?? ""
            dict["quantity"] = arrOfQuantity[i]
            dict["price"] = "\(selectedMaterialCOData[i].price ?? Double(0.0))"
            cartArr.append(dict)
        }
        let priceStr = self.totalPrice.text?.replacingOccurrences(of: "$ ", with: "")
        if priceStr == "0.0" || priceStr == "0" {
            showMessage(with: "Please enter item quantity", theme: .error)
        } else {
            if self.subTaskId != 0 {
                param = [
                    "projectId" : "\(self.mainProejctId)",
                    "vendorId" : "\(self.vendorId)",
                    "subTaskId" : "\(self.subTaskId)",
                    "finalAmount" : "\(priceStr ?? "0")",
                    "address" : self.addressTextField.text ?? "",
                    "state" : self.stateTextField.text ?? "",
                    "city" : self.cityTextField.text ?? "",
                    "zipCode" : self.zipCodeTextField.text ?? "",
                    "CartItem" : cartArr.toJSONString()
                ] as [String : Any]
            } else {
                param = [
                    "projectId" : "\(self.mainProejctId)",
                    "vendorId" : "\(self.vendorId)",
                    "finalAmount" : "\(priceStr ?? "0")",
                    "address" : self.addressTextField.text ?? "",
                    "state" : self.stateTextField.text ?? "",
                    "city" : self.cityTextField.text ?? "",
                    "zipCode" : self.zipCodeTextField.text ?? "",
                    "CartItem" : cartArr.toJSONString()
                ] as [String : Any]
            }
            materialCOVM.createCartApiCall(param) { model in
                self.popUpVw.isHidden = false
                self.blackVw.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.popUpVw.isHidden = true
                    self.blackVw.isHidden = true
                    NotificationCenter.default.post(name: Notification.Name("GoToTaskList"), object: nil)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: OngoingProjectDetailVC.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func tappedDidBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderItemListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMaterialCOData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListItemTableViewCell", for: indexPath)as? OrderListItemTableViewCell {
            cell.itemQtyTextField.tag = indexPath.row
            cell.itemQtyTextField.text = self.arrOfQuantity[indexPath.row]
            cell.itemTittleLbl.text = selectedMaterialCOData[indexPath.row].name ?? ""
            cell.itemPriceLbl.text = "$\(selectedMaterialCOData[indexPath.row].price ?? 0)"
            if self.selectedMaterialCOData[indexPath.row].productFiles?.count ?? 0 > 0 {
                if let imgStr = selectedMaterialCOData[indexPath.row].productFiles?[0].file {
                    cell.itemImageview.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
                }
            } else{
                cell.itemImageview.image = UIImage(named: "emptyImage")
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

    
