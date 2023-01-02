//
//  OrderMaterialPopupViewController.swift
//  TA
//
//  Created by Dev on 03/02/22.
//

import UIKit

class OrderMaterialPopupViewController: UIViewController {

    var viewModel:OrderMaterialViewModel = OrderMaterialViewModel()
    var listOfCategories = [Categories]()
    
    @IBOutlet weak var categoryTextField: FloatingLabelInput!
    @IBOutlet weak var categoriesTableHeight: NSLayoutConstraint!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var completionHandlerGoToMaterialFlow: (() -> Void)?
    var btnTapAction3 : (()->())?
    var vendorId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        categoryTextField.setRightPaddingIcon(icon: UIImage(named: "ic_down")!)
        categoryTextField.setLeftPadding(14)
        categoriesTableView.separatorStyle = .none
        categoriesTableView.rowHeight = 35
        categoriesTableView.estimatedRowHeight = UITableView.automaticDimension
        viewModel.getAllCategoryApi { list in
            if list != nil{
                self.listOfCategories = list!
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        categoriesTableView.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }
    
    func refreshTableHeight() {
        categoriesTableHeight.constant = CGFloat(listOfCategories.count) * 35.0
        categoriesTableView.reloadData()
//        categoriesTableView.
    }
    
    var isOpened = false
    @IBAction func btnCategoriesTapped(_ sender: UIButton) {
        isOpened = !sender.isSelected
        if isOpened{
            refreshTableHeight()
        }else{
            categoriesTableHeight.constant = 0
            categoriesTableView.reloadData()
        }
    }
    
    @IBAction func backgroundViewTapped(_ sender: UIControl) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLookVendorsTapped(_ sender: Any) {
        if categoryTextField.text == nil || categoryTextField.text == ""{
            showMessage(with: "Please select category")
        }
        else{
            self.dismiss(animated: true, completion: nil)
            btnTapAction3?()
        }
    }
}

extension OrderMaterialPopupViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.selectionStyle = .none
        cell.lblCategory.text = self.listOfCategories[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.categoryTextField.text = self.listOfCategories[indexPath.row].title
        vendorId = "\(self.listOfCategories[indexPath.row].id!)"
        categoryTextField.resetFloatingLable()
        categoriesTableHeight.constant = 0
        categoriesTableView.reloadData()
    }
    
}
