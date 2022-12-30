//
//  SelfTaskDetailVC.swift
//  TA
//
//  Created by Applify  on 12/02/22.
//

import UIKit

class SelfTaskDetailVC: BaseViewController {
    @IBOutlet weak var imgTickHeight: NSLayoutConstraint!
    
    @IBOutlet weak var blackVw: UIView!
    @IBOutlet weak var stckVwHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var popUpStckVw: UIStackView!
    @IBOutlet weak var imgPopUpDesc: UILabel!
    @IBOutlet weak var imgPopUpTitke: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var popUpVw: UIView!
    
    @IBOutlet weak var btnMarkComplete: UIButton!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lbltaskName: UILabel!
    
    var taskName = ""
    var taskBudget = ""
    var taskId = 0
    var isComplete = false
    var popUpType = ""
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popUpVw.setRoundCorners(radius: 10.0)
        popUpVw.isHidden = true
        self.lbltaskName.text = self.taskName
        self.lblBudget.text = self.taskBudget
        
        self.handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
        if self.isComplete == false {
            btnMarkComplete.setTitle("Mark Complete", for: .normal)
        } else {
            btnMarkComplete.setTitle("Mark Incomplete", for: .normal)
        }
        
    }
    
    func handlePopUp(isHiddenObj:Bool , isTickHide: Bool, tickHeight: CGFloat, isStackHide:Bool, stackHeight:CGFloat, progressTitle:String, progressDesc:String) {
        self.btnCancel.isHidden = isStackHide
        self.btnComplete.isHidden = isStackHide
        
        self.stckVwHeight.constant = stackHeight
        self.popUpStckVw.isHidden = isStackHide
        
        self.imgPopUpDesc.isHidden = isHiddenObj
        self.imgPopUpTitke.isHidden = isHiddenObj
        
        self.imgPopUpTitke.text = progressTitle
        self.imgPopUpDesc.text = progressDesc
        
        self.popUpVw.isHidden = isHiddenObj
        self.blackVw.isHidden = isHiddenObj
        
        self.imgTickHeight.constant = tickHeight
        self.imgTick.isHidden = isTickHide
    }
    
    func updateStatusTask() {
        var params = [String:Any]()
        if self.popUpType == "Incomplete" {
            params = ["id":"\(self.taskId)","status": "0"]
        } else {
            params = ["id":"\(self.taskId)","status": "1"]
        }
        ongoingProejctsCOViewModel.updateTaskApi(params) { [self] model in
            if self.popUpType == "Incomplete"  {
                handlePopUp(isHiddenObj: false, isTickHide: false, tickHeight: 56.0, isStackHide: true, stackHeight: 0.0, progressTitle: "Tasks Marked Inompleted", progressDesc: "The task has been marked incompleted")
            } else {
                handlePopUp(isHiddenObj: false, isTickHide: false, tickHeight: 56.0, isStackHide: true, stackHeight: 0.0, progressTitle: "Tasks Marked Completed", progressDesc: "The task has been marked completed")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                popUpType = ""
                handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMarkComplete(_ sender: Any) {
        self.popUpType = ""
        if self.isComplete == false {
            self.btnComplete.setTitle("Complete", for: .normal)
            self.btnCancel.setTitle("Cancel", for: .normal)
            self.popUpType = "Complete"
            self.handlePopUp(isHiddenObj: false, isTickHide: true, tickHeight: 0.0, isStackHide: false, stackHeight: 56.0, progressTitle: "Task Complete!", progressDesc: "Are you sure, you want to complete the task?")
            
        } else {
            self.btnComplete.setTitle("Incomplete", for: .normal)
            self.btnCancel.setTitle("Cancel", for: .normal)
            self.popUpType = "Incomplete"
            self.handlePopUp(isHiddenObj: false, isTickHide: true, tickHeight: 0.0, isStackHide: false, stackHeight: 56.0, progressTitle: "Task Incomplete!", progressDesc: "Are you sure, you want to incomplete the task?")
        }
    }
    
    @IBAction func actionComplete(_ sender: Any) {
        updateStatusTask()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.popUpType = ""
        self.handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
    }
    
}
