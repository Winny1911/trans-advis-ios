//
//  MaterialFilterCOVC.swift
//  TA
//
//  Created by Applify on 24/01/22.
//

import UIKit

class MaterialFilterCOVC: BaseViewController {
    
    // MARK: Outlet
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var filterTblVw: UITableView!
    @IBOutlet weak var btnClearAllFilter: UIButton!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    
    // MARK: Variable
    var materialCOVM = MaterialCOVM()
    
    var arrOfFiltersHeaders = [String]()
    var arrOfFiltersValues = [[String]]()
    var expandedSectionArray = [Int]()
    var completionHandlerGoToMaterialScreen: (() -> Void)?
    var selectedFilters = [[String: [String]]]()
    var selectedFiltersState = [String]()
    var selectedFiltersCategory = [String]()
    var selectedFiltersCategoryid = [Int]()
    var selectedFiltersFirstName = [String]()
    var idArray = [Int]()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        
        self.filterTblVw.separatorColor = UIColor.clear
        self.filterTblVw.rowHeight = UITableView.automaticDimension
        self.filterTblVw.estimatedRowHeight = 40.0
        self.filterTblVw.tableFooterView = UIView()
        self.filterTblVw.separatorStyle = .none
        
        self.filterTblVw.delegate = self
        self.filterTblVw.dataSource = self
        
        if let stateArr = UserDefaults.standard.value(forKey: "MaterialFilterStateCO") as? [String] {
            if stateArr.count > 0 {
                selectedFiltersState = stateArr
            }
        }
        
        if let categoryArr = UserDefaults.standard.value(forKey: "MaterialFilterCategoryCO") as? [String] {
            if categoryArr.count > 0 {
                selectedFiltersCategory = categoryArr
            }
        }
        
        if let firstNameArr = UserDefaults.standard.value(forKey: "MaterialFilterFirstNameCO") as? [String] {
            if firstNameArr.count > 0 {
                selectedFiltersFirstName = firstNameArr
            }
        }
    }
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.filterAPi()
    }
    
    @IBAction func actionDsms(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: Filter API And Handling
    func filterAPi(){
        materialCOVM.getMaterialApiCall([:]) { response in
            self.selectedFilters.removeAll()
            self.arrOfFiltersHeaders.removeAll()
            self.expandedSectionArray.removeAll()
            self.arrOfFiltersValues.removeAll()
            if response?.data?.filter?.states?.count ?? 0 > 0 {
                var stateArray = [String]()
                for i in 0 ..< (response?.data?.filter?.states?.count ?? 0)  {
                    stateArray.append(response?.data?.filter?.states?[i] ?? "")
                }
                self.arrOfFiltersHeaders.append("Filter By Location")
                self.arrOfFiltersValues.append(stateArray)
            }
            if response?.data?.filter?.category?.count ?? 0 > 0 {
                var statesArray = [String]()
                for i in 0 ..< (response?.data?.filter?.category?.count ?? 0)  {
                    statesArray.append(response?.data?.filter?.category?[i].title ?? "")
                }
                for i in 0 ..< (response?.data?.filter?.category?.count ?? 0)  {
                    self.idArray.append(response?.data?.filter?.category?[i].id ?? 0)
                }
                self.arrOfFiltersHeaders.append("Filter By Category")
                self.arrOfFiltersValues.append(statesArray)
            }
            if response?.data?.filter?.firstName?.count ?? 0 > 0 {
                var firstNameArray = [String]()
                for i in 0 ..< (response?.data?.filter?.firstName?.count ?? 0)  {
                    firstNameArray.append(response?.data?.filter?.firstName?[i] ?? "")
                }
                self.arrOfFiltersHeaders.append("Filter By Vendor")
                self.arrOfFiltersValues.append(firstNameArray)
            }
            self.filterTblVw.reloadData()
        }
    }
    
    //MARK:- Register Cell
    func registerCell() {
        filterTblVw.register(UINib.init(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
     }

    //MARK:- ACTION CANCEL
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: ACTION CLEAR FILTER
    @IBAction func actionClearAllFilter(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "MaterialFilterStateCO")
        UserDefaults.standard.removeObject(forKey: "MaterialFilterCategoryCO")
        UserDefaults.standard.removeObject(forKey: "MaterialFilterFirstNameCO")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
        self.completionHandlerGoToMaterialScreen?()
    }
    
    //MARK: ACTION APPLY FILTER
    @IBAction func actionApplyFilter(_ sender: Any) {
        if self.selectedFiltersState.count > 0 {
            UserDefaults.standard.removeObject(forKey: "MaterialFilterStateCO")
            UserDefaults.standard.set(self.selectedFiltersState, forKey: "MaterialFilterStateCO")
        } else {
            UserDefaults.standard.removeObject(forKey: "MaterialFilterStateCO")
        }
        
        if self.selectedFiltersCategory.count > 0 {
            UserDefaults.standard.removeObject(forKey: "MaterialFilterCategoryCO")
            UserDefaults.standard.set(self.selectedFiltersCategory, forKey: "MaterialFilterCategoryCO")
            UserDefaults.standard.removeObject(forKey: "MaterialFilterCategoryCOID")
            UserDefaults.standard.set(self.selectedFiltersCategoryid, forKey: "MaterialFilterCategoryCOID")
        } else {
            UserDefaults.standard.removeObject(forKey: "MaterialFilterCategoryCO")
            UserDefaults.standard.removeObject(forKey: "MaterialFilterCategoryCOID")
        }
        
        if self.selectedFiltersFirstName.count > 0 {
            UserDefaults.standard.removeObject(forKey: "MaterialFilterFirstNameCO")
            UserDefaults.standard.set(self.selectedFiltersFirstName, forKey: "MaterialFilterFirstNameCO")
        } else {
            UserDefaults.standard.removeObject(forKey: "MaterialFilterFirstNameCO")
        }
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
        self.completionHandlerGoToMaterialScreen?()
    }
}

// MARK: Extension CollectionView Delegate and DataSource
extension MaterialFilterCOVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOfFiltersHeaders.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UINib(nibName: "Header", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Header
        view.lblHeader.text = arrOfFiltersHeaders[section]
        view.btnSelect.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        view.btnSelect.tag = section
        if self.expandedSectionArray.contains(section) {
            view.imgArrow.image = UIImage(named: "ic_arrow-4")
            view.bottomLine.isHidden = true
        } else {
            view.bottomLine.isHidden = false
            view.imgArrow.image = UIImage(named: "ic_arrow-3")
        }
        if section == 0  {
            view.bottomLine.isHidden = true
            view.topLine.isHidden = true
        }
        if section == 1 {
            view.bottomLine.isHidden = true
            view.topLine.isHidden = false
        }
        return view
    }

    //MARK: Expand TableView cell
    @objc func btnTapped(sender:UIButton) {
        if self.expandedSectionArray.contains(sender.tag) {
            let indx = self.expandedSectionArray.firstIndex(of: sender.tag)
            self.expandedSectionArray.remove(at: indx!)
        } else {
            self.expandedSectionArray.append(sender.tag)
        }
        self.filterTblVw.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expandedSectionArray.contains(section) {
            return arrOfFiltersValues[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        if indexPath.section == 0 {
            if self.selectedFiltersState.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
            }
        } else if indexPath.section == 1 {
            if self.selectedFiltersCategory.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
            }
        } else if indexPath.section == 2 {
            if self.selectedFiltersFirstName.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
            }
        }
        cell.lblFilter.text = arrOfFiltersValues[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.selectedFiltersState.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                let indx = self.selectedFiltersState.firstIndex(of: arrOfFiltersValues[indexPath.section][indexPath.row])
                self.selectedFiltersState.remove(at: indx!)
            } else {
                self.selectedFiltersState.append(arrOfFiltersValues[indexPath.section][indexPath.row])
            }
        } else if indexPath.section == 1 {
            if self.selectedFiltersCategory.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                let indx = self.selectedFiltersCategory.firstIndex(of: arrOfFiltersValues[indexPath.section][indexPath.row])
                self.selectedFiltersCategory.remove(at: indx!)
                if self.selectedFiltersCategoryid.contains(idArray[indexPath.row]) {
                    let indxs = self.idArray[indexPath.row]
                    self.selectedFiltersCategoryid.remove(at: indxs)
                }
                
            } else {
                self.selectedFiltersCategory.append(arrOfFiltersValues[indexPath.section][indexPath.row])
                self.selectedFiltersCategoryid.append(idArray[indexPath.row])
            }
        } else if indexPath.section == 2 {
            if self.selectedFiltersFirstName.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                let indx = self.selectedFiltersFirstName.firstIndex(of: arrOfFiltersValues[indexPath.section][indexPath.row])
                self.selectedFiltersFirstName.remove(at: indx!)
            } else {
                self.selectedFiltersFirstName.append(arrOfFiltersValues[indexPath.section][indexPath.row])
            }
        }
        self.filterTblVw.reloadData()
    }
}
