//
//  ContractorFilterVC.swift
//  TA
//
//  Created by Designer on 22/12/21.
//

import UIKit

class ContractorFilterVC: BaseViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var filterTblVw: UITableView!
    @IBOutlet weak var btnClearAllFilter: UIButton!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    let invitationViewModel: InvitationViewModel = InvitationViewModel()
    let filterHOViewModel: FilterHOViewModel = FilterHOViewModel()
    var filterListing : FilterData?
    
    var arrOfFiltersHeaders = [String]()
    var arrOfFiltersValues = [[String]]()
    var expandedSectionArray = [Int]()
    var completionHandlerGoToContractorScreen: (() -> Void)?
    var selectedFilters = [[String: [String]]]()
    //var selectedFiltersWork = [String]()
    var allFiltersWorkIds = [Int]()
    var selectedFiltersWorkIds = [Int]()
    var selectedFiltersLocation = [String]()
    
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        self.filterTblVw.separatorColor = UIColor.clear
        self.filterTblVw.rowHeight = UITableView.automaticDimension
        self.filterTblVw.estimatedRowHeight = 40.0
        self.filterTblVw.tableFooterView = UIView()
        self.filterTblVw.separatorStyle = .none
        
        self.filterTblVw.delegate = self
        self.filterTblVw.dataSource = self
        
        if self.isFrom == "InviteContractorsToBid" {
            if let workArr = UserDefaults.standard.value(forKey: "FilterWorkCOInviteBids") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationCOInviteBids") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
        } else {
            if let workArr = UserDefaults.standard.value(forKey: "FilterWorkHO") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationHO") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isFrom == "InviteContractorsToBid" {
            filterHOViewModel.getFilterCOInviteBidsApi([:]) { response in
                self.selectedFilters.removeAll()
                self.arrOfFiltersHeaders.removeAll()
                self.expandedSectionArray.removeAll()
                self.arrOfFiltersValues.removeAll()
                self.allFiltersWorkIds.removeAll()
                if response?.data?.work?.count ?? 0 > 0 {
                    var skillsArray = [String]()
                    skillsArray.removeAll()
                    for i in 0 ..< (response?.data?.work?.count ?? 0)  {
                        if response?.data?.work?[i].projectCategory?.id != nil && response?.data?.work?[i].projectCategory?.id != 0 {
                            skillsArray.append(response?.data?.work?[i].projectCategory?.title ?? "")
                            self.allFiltersWorkIds.append(response?.data?.work?[i].projectCategory?.id ?? 0)
                        }
                    }
                    self.arrOfFiltersHeaders.append("Filter By Work")
                    self.arrOfFiltersValues.append(skillsArray)
                }
                if response?.data?.location?.count ?? 0 > 0 {
                    var statesArray = [String]()
                    for i in 0 ..< (response?.data?.location?.count ?? 0)  {
                        statesArray.append(response?.data?.location?[i] ?? "")
                    }
                    self.arrOfFiltersHeaders.append("Filter By Location")
                    self.arrOfFiltersValues.append(statesArray)
                }
                self.filterTblVw.reloadData()
            }
        } else {
            filterHOViewModel.getFilterHOApi([:]) { response in
                self.selectedFilters.removeAll()
                self.arrOfFiltersHeaders.removeAll()
                self.expandedSectionArray.removeAll()
                self.arrOfFiltersValues.removeAll()
                self.allFiltersWorkIds.removeAll()
                if response?.data?.work?.count ?? 0 > 0 {
                    var skillsArray = [String]()
                    for i in 0 ..< (response?.data?.work?.count ?? 0)  {
                        if let data = response?.data?.work?[i].projectCategory, data.id != nil && data.id != 0 {
                            skillsArray.append(data.title ?? "")
                            self.allFiltersWorkIds.append(data.id ?? 0)
                        }
                    }
                    self.arrOfFiltersHeaders.append("Filter By Work")
                    self.arrOfFiltersValues.append(skillsArray)
                }
                if response?.data?.location?.count ?? 0 > 0 {
                    var statesArray = [String]()
                    for i in 0 ..< (response?.data?.location?.count ?? 0)  {
                        statesArray.append(response?.data?.location?[i] ?? "")
                    }
                    self.arrOfFiltersHeaders.append("Filter By Location")
                    self.arrOfFiltersValues.append(statesArray)
                }
                self.filterTblVw.reloadData()
            }
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
        if self.isFrom == "InviteContractorsToBid" {
            UserDefaults.standard.removeObject(forKey: "FilterWorkCOInviteBids")
            UserDefaults.standard.removeObject(forKey: "FilterLocationCOInviteBids")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToContractorScreen?()
        } else {
            UserDefaults.standard.removeObject(forKey: "FilterWorkHO")
            UserDefaults.standard.removeObject(forKey: "FilterLocationHO")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToContractorScreen?()
        }
    }
    
    //MARK: ACTION APPLY FILTER
    @IBAction func actionApplyFilter(_ sender: Any) {
        if self.isFrom == "InviteContractorsToBid" {
            if self.selectedFiltersWorkIds.count > 0 {
                UserDefaults.standard.removeObject(forKey: "FilterWorkCOInviteBids")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWorkCOInviteBids")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterWorkCOInviteBids")
            }
            
            if self.selectedFiltersLocation.count > 0 {
                UserDefaults.standard.removeObject(forKey: "FilterLocationCOInviteBids")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocationCOInviteBids")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterLocationCOInviteBids")
            }
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToContractorScreen?()
        } else {
            if self.selectedFiltersWorkIds.count > 0 {
                UserDefaults.standard.removeObject(forKey: "FilterWorkHO")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWorkHO")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterWorkHO")
            }
            
            if self.selectedFiltersLocation.count > 0 {
                UserDefaults.standard.removeObject(forKey: "FilterLocationHO")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocationHO")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterLocationHO")
            }
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToContractorScreen?()
        }
        
    }
}

extension ContractorFilterVC: UITableViewDelegate, UITableViewDataSource {
    
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
        if section == 0 {
            view.bottomLine.isHidden = true
            view.topLine.isHidden = true
        }
        return view
    }

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
            if self.selectedFiltersWorkIds.contains(self.allFiltersWorkIds[indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
            }
        } else if indexPath.section == 1 {
            if self.selectedFiltersLocation.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
            }
        }
        cell.lblFilter.text = arrOfFiltersValues[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.selectedFiltersWorkIds.contains(allFiltersWorkIds[indexPath.row]) {
                let indx = self.selectedFiltersWorkIds.firstIndex(of: allFiltersWorkIds[indexPath.row])
                self.selectedFiltersWorkIds.remove(at: indx!)
                //self.selectedFiltersWork.remove(at: indx!)
            } else {
                self.selectedFiltersWorkIds.append(self.allFiltersWorkIds[indexPath.row])
                //self.selectedFiltersWork.append(arrOfFiltersValues[indexPath.section][indexPath.row])
            }
        } else if indexPath.section == 1 {
            if self.selectedFiltersLocation.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                let indx = self.selectedFiltersLocation.firstIndex(of: arrOfFiltersValues[indexPath.section][indexPath.row])
                self.selectedFiltersLocation.remove(at: indx!)
            } else {
                self.selectedFiltersLocation.append(arrOfFiltersValues[indexPath.section][indexPath.row])
            }
        }
        self.filterTblVw.reloadData()
    }
}
