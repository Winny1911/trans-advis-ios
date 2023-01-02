//
//  InvitationFilterVC.swift
//  TA
//
//  Created by Applify  on 21/12/21.
//

import UIKit

class InvitationFilterVC: BaseViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var filterTblVw: UITableView!
    @IBOutlet weak var btnClearAllFilter: UIButton!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    let invitationViewModel: InvitationViewModel = InvitationViewModel()
    var arrOfFiltersHeaders = [String]()
    var arrOfFiltersValues = [[String]]()
    var expandedSectionArray = [Int]()
    var completionHandlerGoToInvitationScreen: (() -> Void)?
    var completionHandlerGoToInvitationScreenClearFilter: (() -> Void)?
    
    var completionHandlerGoToOnGoingProjectsCOClearFilter: (() -> Void)?
    var completionHandlerGoToPastProjectsCOClearFilter: (() -> Void)?
    var completionHandlerGoToArchiveProjectsCOClearFilter: (() -> Void)?
    var completionHandlerGoToOnGoingProjectsHOClearFilter: (() -> Void)?
    var completionHandlerGoToOnGoingProjectsCO: (() -> Void)?
    var completionHandlerGoToPastProjectsCO: (() -> Void)?
    var completionHandlerGoToArchiveProjectsCO: (() -> Void)?
    var completionHandlerGoToOnGoingProjectsHO: (() -> Void)?
    
    var selectedFilters = [[String: [String]]]()
    //var selectedFiltersWork = [String]()
    var selectedFiltersLocation = [String]()
    var dateArr = ["1"]
    var selectedFromDatesValue = String()
    var selectedToDatesValue = String()
    var allFiltersWorkIds = [Int]()
    var selectedFiltersWorkIds = [Int]()
    
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        
        self.filterTblVw.separatorColor = UIColor.clear
        self.filterTblVw.rowHeight = UITableView.automaticDimension
        self.filterTblVw.estimatedRowHeight = 80.0
        self.filterTblVw.tableFooterView = UIView()
        self.filterTblVw.separatorStyle = .none
        
        self.filterTblVw.delegate = self
        self.filterTblVw.dataSource = self

        if self.isFrom == "OnGoingProjectsCO" {
            if let workArr = UserDefaults.standard.value(forKey: "FilterWorkOngoingProjects") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationOngoingProjects") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
        }else if self.isFrom == "PastProjectsCO"{
            if let workArr = UserDefaults.standard.value(forKey: "FilterWorkPastProjectCO") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationPastProjectCO") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
            if let isFromDateArr = UserDefaults.standard.value(forKey: "FilterFromDatePastProjectCO") as? String {
                if isFromDateArr.count > 0 {
                    selectedFromDatesValue = isFromDateArr
                }
            }
            if let isToDateArr = UserDefaults.standard.value(forKey: "FilterToDatePastProjectCO") as? String {
                if isToDateArr.count > 0 {
                    selectedToDatesValue = isToDateArr
                }
            }

        }else if self.isFrom == "ArchiveProjectsCO"{
            if let workArr = UserDefaults.standard.value(forKey: "FilterWorkArchiveProjectCO") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationArchiveProjectCO") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
        }
        else if self.isFrom == "OngoingProjectHO" {
            if let workArr = UserDefaults.standard.value(forKey: "FilterWorkOngoingProjectHO") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocationOngoingProjectHO") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
        } else {
            if let workArr = UserDefaults.standard.value(forKey: "FilterWork") as? [Int] {
                if workArr.count > 0 {
                    selectedFiltersWorkIds = workArr
                }
            }
            
            if let locationArr = UserDefaults.standard.value(forKey: "FilterLocation") as? [String] {
                if locationArr.count > 0 {
                    selectedFiltersLocation = locationArr
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isFrom == "OnGoingProjectsCO" {
            self.filterOngoingProjects()
        }else if self.isFrom == "PastProjectsCO" {
            self.filterPastProjectsCO()
        }else if self.isFrom == "ArchiveProjectsCO" {
            self.filterPastProjectsCO()
        }else if self.isFrom == "OngoingProjectHO" {
            self.filterOngoingProjectsHO()
        } else {
            self.filterInvitation()
        }
    }
    
    func filterOngoingProjectsHO() {
        invitationViewModel.getOngoingProjectsHOFilterApi([:]) { response in
            self.selectedFilters.removeAll()
            self.arrOfFiltersHeaders.removeAll()
            self.expandedSectionArray.removeAll()
            self.arrOfFiltersValues.removeAll()
            self.allFiltersWorkIds.removeAll()
            
            if response?.data?.work?.count ?? 0 > 0 {
                var skillsArray = [String]()
                skillsArray.removeAll()
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
    
    func filterOngoingProjects() {
        invitationViewModel.getOngoingProjectsFilterApi(["status":"0"]) { response in
            self.selectedFilters.removeAll()
            self.arrOfFiltersHeaders.removeAll()
            self.expandedSectionArray.removeAll()
            self.arrOfFiltersValues.removeAll()
            if response?.data?.listing?.work?.count ?? 0 > 0 {
                var skillsArray = [String]()
                skillsArray.removeAll()
                for i in 0 ..< (response?.data?.listing?.work?.count ?? 0)  {
                    if response?.data?.listing?.work?[i].id != nil && response?.data?.listing?.work?[i].id != 0 {
                        skillsArray.append(response?.data?.listing?.work?[i].title ?? "")
                        self.allFiltersWorkIds.append(response?.data?.listing?.work?[i].id ?? 0)
                    }
                }
                self.arrOfFiltersHeaders.append("Filter By Work")
                self.arrOfFiltersValues.append(skillsArray)
            }
            if response?.data?.listing?.location?.count ?? 0 > 0 {
                var statesArray = [String]()
                for i in 0 ..< (response?.data?.listing?.location?.count ?? 0)  {
                    statesArray.append(response?.data?.listing?.location?[i] ?? "")
                }
                self.arrOfFiltersHeaders.append("Filter By Location")
                self.arrOfFiltersValues.append(statesArray)
            }
            self.filterTblVw.reloadData()
        }
    }
    
    func filterPastProjectsCO() {
        invitationViewModel.getOngoingProjectsFilterApi(["status":"1"]) { response in
            self.selectedFilters.removeAll()
            self.arrOfFiltersHeaders.removeAll()
            self.expandedSectionArray.removeAll()
            self.arrOfFiltersValues.removeAll()
            if response?.data?.listing?.work?.count ?? 0 > 0 {
                var skillsArray = [String]()
                skillsArray.removeAll()
                for i in 0 ..< (response?.data?.listing?.work?.count ?? 0)  {
                    if response?.data?.listing?.work?[i].id != nil && response?.data?.listing?.work?[i].id != 0 {
                        skillsArray.append(response?.data?.listing?.work?[i].title ?? "")
                        self.allFiltersWorkIds.append(response?.data?.listing?.work?[i].id ?? 0)
                    }
                }
                self.arrOfFiltersHeaders.append("Filter By Work")
                self.arrOfFiltersValues.append(skillsArray)
            }
            if response?.data?.listing?.location?.count ?? 0 > 0 {
                var statesArray = [String]()
                for i in 0 ..< (response?.data?.listing?.location?.count ?? 0)  {
                    statesArray.append(response?.data?.listing?.location?[i] ?? "")
                }
                self.arrOfFiltersHeaders.append("Filter By Location")
                self.arrOfFiltersValues.append(statesArray)
            }
            if self.dateArr.count > 0 {
                var dateArray = [String]()
                for i in 0 ..< (self.dateArr.count )  {
                    dateArray.append(self.dateArr[i] )
                }
                self.arrOfFiltersHeaders.append("Filter By Date")
                self.arrOfFiltersValues.append(dateArray)
            }
//            self.arrOfFiltersHeaders.append("Filter By Date")
//            self.arrOfFiltersValues.append(dateArray)
//
            self.filterTblVw.reloadData()
        }
    }
    
    func filterInvitation() {
        invitationViewModel.getFilterApi([:]) { response in
            self.selectedFilters.removeAll()
            self.arrOfFiltersHeaders.removeAll()
            self.expandedSectionArray.removeAll()
            self.arrOfFiltersValues.removeAll()
            if response?.data?.skills?.count ?? 0 > 0 {
                var skillsArray = [String]()
                skillsArray.removeAll()
                for i in 0 ..< (response?.data?.skills?.count ?? 0)  {
                    if response?.data?.skills?[i].id != nil && response?.data?.skills?[i].id != 0 {
                        skillsArray.append(response?.data?.skills?[i].title ?? "")
                        self.allFiltersWorkIds.append(response?.data?.skills?[i].id ?? 0)
                    }
                }
                self.arrOfFiltersHeaders.append("Filter By Work")
                self.arrOfFiltersValues.append(skillsArray)
            }
            if response?.data?.states?.count ?? 0 > 0 {
                var statesArray = [String]()
                for i in 0 ..< (response?.data?.states?.count ?? 0)  {
                    statesArray.append(response?.data?.states?[i] ?? "")
                }
                self.arrOfFiltersHeaders.append("Filter By Location")
                self.arrOfFiltersValues.append(statesArray)
            }
            self.filterTblVw.reloadData()
        }
    }
    
    //MARK:- Register Cell
    func registerCell() {
        filterTblVw.register(UINib.init(nibName: "InvitationFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "InvitationFilterTableViewCell")
     }
    
    //MARK:- ACTION CANCEL
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: ACTION CLEAR FILTER
    @IBAction func actionClearAllFilter(_ sender: Any) {
        if self.isFrom == "OnGoingProjectsCO" {
            UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjects")
            UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjects")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToOnGoingProjectsCOClearFilter?()
            
        }else if self.isFrom == "PastProjectsCO" {
            UserDefaults.standard.removeObject(forKey: "FilterWorkPastProjectCO")
            UserDefaults.standard.removeObject(forKey: "FilterLocationPastProjectCO")
            UserDefaults.standard.removeObject(forKey: "FilterDatePastProjectCO")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToPastProjectsCOClearFilter?()
            
        }else if self.isFrom == "ArchiveProjectsCO" {
            UserDefaults.standard.removeObject(forKey: "FilterWorkArchiveProjectCO")
            UserDefaults.standard.removeObject(forKey: "FilterLocationArchiveProjectCO")
            UserDefaults.standard.removeObject(forKey: "FilterDateArchivetProjectCO")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToArchiveProjectsCOClearFilter?()
            
        }
        else if self.isFrom == "OngoingProjectHO" {
            UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjectHO")
            UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjectHO")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToOnGoingProjectsHOClearFilter?()
            
        } else {
            UserDefaults.standard.removeObject(forKey: "FilterWork")
            UserDefaults.standard.removeObject(forKey: "FilterLocation")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToInvitationScreenClearFilter?()
        }
    }
    
    //MARK: ACTION APPLY FILTER
    @IBAction func actionApplyFilter(_ sender: Any) {
        if self.selectedFiltersWorkIds.count > 0 {
            if self.isFrom == "OnGoingProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjects")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWorkOngoingProjects")
            }else if self.isFrom == "PastProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkPastProjectCO")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWorkPastProjectCO")
            }else if self.isFrom == "ArchiveProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkArchiveProjectCO")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWorkArchiveProjectCO")
            }else if self.isFrom == "OngoingProjectHO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjectHO")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWorkOngoingProjectHO")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterWork")
                UserDefaults.standard.set(self.selectedFiltersWorkIds, forKey: "FilterWork")
            }
        } else {
            if self.isFrom == "OnGoingProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjects")
            }else if self.isFrom == "PastProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkPastProjectCO")
            }else if self.isFrom == "ArchiveProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkArchiveProjectCO")
            }else if self.isFrom == "OngoingProjectHO" {
                UserDefaults.standard.removeObject(forKey: "FilterWorkOngoingProjectHO")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterWork")
            }
        }
        
        if self.selectedFiltersLocation.count > 0 {
            if self.isFrom == "OnGoingProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjects")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocationOngoingProjects")
            } else if self.isFrom == "PastProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationPastProjectCO")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocationPastProjectCO")
            }else if self.isFrom == "ArchiveProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationArchiveProjectCO")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocationArchiveProjectCO")
            }else if self.isFrom == "OngoingProjectHO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjectHO")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocationOngoingProjectHO")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterLocation")
                UserDefaults.standard.set(self.selectedFiltersLocation, forKey: "FilterLocation")
            }
        } else {
            if self.isFrom == "OnGoingProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjects")
            } else if self.isFrom == "PastProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationPastProjectCO")
            }else if self.isFrom == "ArchiveProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationArchiveProjectCO")
            } else if self.isFrom == "OngoingProjectHO" {
                UserDefaults.standard.removeObject(forKey: "FilterLocationOngoingProjectHO")
            } else {
                UserDefaults.standard.removeObject(forKey: "FilterLocation")
            }
        }
        if selectedFromDatesValue.count > 0{
            if self.isFrom == "PastProjectsCO"{
                UserDefaults.standard.removeObject(forKey: "FilterFromDatePastProjectCO")
                UserDefaults.standard.set(self.selectedFromDatesValue, forKey: "FilterFromDatePastProjectCO")
               
            }else if self.isFrom == "ArchiveProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterDateArchivetProjectCO")
                UserDefaults.standard.set(self.selectedFromDatesValue, forKey: "FilterDateArchivetProjectCO")
               
            }
        }else{
            if self.isFrom == "PastProjectsCO"{
                UserDefaults.standard.removeObject(forKey: "FilterFromDatePastProjectCO")
            }else if self.isFrom == "ArchiveProjectsCO"{
                UserDefaults.standard.removeObject(forKey: "FilterDateArchivetProjectCO")
            }
        }
        
        if selectedToDatesValue.count > 0{
            if self.isFrom == "PastProjectsCO"{
                UserDefaults.standard.removeObject(forKey: "FilterToDatePastProjectCO")
                UserDefaults.standard.set(self.selectedToDatesValue, forKey: "FilterToDatePastProjectCO")
               
            }else if self.isFrom == "ArchiveProjectsCO" {
                UserDefaults.standard.removeObject(forKey: "FilterDateArchivetProjectCO")
                UserDefaults.standard.set(self.selectedToDatesValue, forKey: "FilterDateArchivetProjectCO")
               
            }
        }else{
            if self.isFrom == "PastProjectsCO"{
                UserDefaults.standard.removeObject(forKey: "FilterToDatePastProjectCO")
            }else if self.isFrom == "ArchiveProjectsCO"{
                UserDefaults.standard.removeObject(forKey: "FilterDateArchivetProjectCO")
            }
        }
        
        
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
        if self.isFrom == "OnGoingProjectsCO" {
            self.completionHandlerGoToOnGoingProjectsCO?()
        } else if self.isFrom == "PastProjectsCO" {
            self.completionHandlerGoToPastProjectsCO?()
        }else if self.isFrom == "ArchiveProjectsCO" {
            self.completionHandlerGoToArchiveProjectsCO?()
        } else if self.isFrom == "OngoingProjectHO" {
            self.completionHandlerGoToOnGoingProjectsHO?()
        } else {
            self.completionHandlerGoToInvitationScreen?()
        }
    }
}


extension InvitationFilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrOfFiltersHeaders.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UINib(nibName: "FilterHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterHeader
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
        if section == 1 {
            view.bottomLine.isHidden = true
            view.topLine.isHidden = false
        }
        if section == 2 {
            view.bottomLine.isHidden = true
            view.topLine.isHidden = false
        }
        //view.backgroundColor = UIColor.red
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationFilterTableViewCell", for: indexPath) as! InvitationFilterTableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row % 2 == 0{
                cell.backgroundColor = UIColor.yellow
            } else{
                cell.backgroundColor = UIColor.red
            }
            cell.dateStackVw.isHidden = true
            cell.lblFilter.isHidden = false
            cell.imgCheckBox.isHidden = false
            if self.selectedFiltersWorkIds.contains(allFiltersWorkIds[indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
                
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
                
            }
        } else if indexPath.section == 1 {
            cell.dateStackVw.isHidden = true
            cell.lblFilter.isHidden = false
            cell.imgCheckBox.isHidden = false
            
            if self.selectedFiltersLocation.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
                
            } else {
                cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled-1")
                
            }
            
        }
        else if indexPath.section == 2{
            
            cell.dateStackVw.isHidden = false
            cell.lblFilter.isHidden = true
            cell.imgCheckBox.isHidden = true
            self.selectedFromDatesValue = cell.selectedFromDate
            self.selectedToDatesValue = cell.selectedToDate
            
            //            if self.dateArr.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
            //                self.selectedDatesArr = cell.selectedDateArray
            //
            ////                var fromDate =  cell.fromDateTxtfield.text
            ////                var toDate = cell.toDateTxtField.text
            //            } else {
            //
            //                print("lll")
            //            }
            
        }
        
        cell.lblFilter.text = arrOfFiltersValues[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 50.0
        } else if indexPath.section == 2 {
            return 120
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.selectedFiltersWorkIds.contains(allFiltersWorkIds[indexPath.row]) {
                let indx = self.selectedFiltersWorkIds.firstIndex(of: allFiltersWorkIds[indexPath.row])
                self.selectedFiltersWorkIds.remove(at: indx!)
            } else {
                self.selectedFiltersWorkIds.append(self.allFiltersWorkIds[indexPath.row])
            }
        } else if indexPath.section == 1 {
            if self.selectedFiltersLocation.contains(arrOfFiltersValues[indexPath.section][indexPath.row]) {
                let indx = self.selectedFiltersLocation.firstIndex(of: arrOfFiltersValues[indexPath.section][indexPath.row])
                self.selectedFiltersLocation.remove(at: indx!)
            } else {
                self.selectedFiltersLocation.append(arrOfFiltersValues[indexPath.section][indexPath.row])
            }
            
        }else if indexPath.section == 2{
//            if self.dateArr.contains(arrOfFiltersValues[indexPath.section][indexPath.row]){
//                self.selectedDatesArr.append(arrOfFiltersValues[indexPath.section][indexPath.row])
//            }
        }
        self.filterTblVw.reloadData()
    }
}
