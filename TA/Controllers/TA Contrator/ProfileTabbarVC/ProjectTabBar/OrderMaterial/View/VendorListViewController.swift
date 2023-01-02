//
//  VendorListViewController.swift
//  TA
//
//  Created by Dev on 03/02/22.
//

import UIKit

class VendorListViewController: UIViewController {

    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var vendorsListTableView: UITableView!
    var viewModel:OrderMaterialViewModel = OrderMaterialViewModel()
    var arrOfVendors = [Listing]()
    var category = ""
    var mainProejctId = 0
    var subTaskId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category)
        print(mainProejctId)
        print(subTaskId)
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        vendorsListTableView.rowHeight = 304
        vendorsListTableView.estimatedRowHeight = UITableView.automaticDimension
        vendorsListTableView.separatorStyle = .none
//        self.lblTop.text = "\(category) Vendors"
        registerCells()
        viewModel.getAllMaterialsApi(["category":category]) { response in
            if response != nil{
                self.arrOfVendors = (response?.data.listing)!
                if self.arrOfVendors.count == 0 || self.arrOfVendors == nil {
                    self.lblTop.text = "Vendors"
                    self.vendorsListTableView.isHidden = true
                } else {
                    self.noDataFoundLabel.isHidden = true
                    self.lblTop.text = "\(self.arrOfVendors.count) Vendors"
                }
                self.vendorsListTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        vendorsListTableView.register(UINib.init(nibName: "VendorListTableViewCell", bundle: nil), forCellReuseIdentifier: "VendorListTableViewCell")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VendorListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfVendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vendorsListTableView.dequeueReusableCell(withIdentifier: "VendorListTableViewCell") as! VendorListTableViewCell
        cell.selectionStyle = .none
        cell.lblTitle.text = "\(arrOfVendors[indexPath.row].firstName ?? "")" + " \(arrOfVendors[indexPath.row].lastName ?? "")"
        cell.lblProjectsCompleted.text = "\(arrOfVendors[indexPath.row].productsCount ?? 0)"
        cell.vendorImage.sd_setImage(with: URL(string: arrOfVendors[indexPath.row].profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"))
        cell.btnViewProfile.tag = indexPath.row
        cell.btnViewProducts.tag = indexPath.row
        
        cell.btnViewProducts.addTarget(self, action: #selector(viewProducts(sender:)), for: .touchUpInside)
        cell.btnViewProfile.addTarget(self, action: #selector(viewProfile(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func viewProducts(sender: UIButton) {
        let destinationViewController = Storyboard.material.instantiateViewController(withIdentifier: "MaterialVC") as? MaterialVC
        destinationViewController?.orderMaterialFlow = "orderMaterialFlow"
        destinationViewController?.mainProejctId = self.mainProejctId
        destinationViewController?.subTaskId = self.subTaskId
        destinationViewController?.vendorId = self.arrOfVendors[sender.tag].id ?? 0
        destinationViewController?.category = self.category
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @objc func viewProfile(sender: UIButton) {
        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "VenderProfilesCOVC") as? VenderProfilesCOVC
        destinationViewController?.id = self.arrOfVendors[sender.tag].id ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
