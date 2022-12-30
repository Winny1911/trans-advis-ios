//
//  EditAndDeleteVC.swift
//  TA
//
//  Created by Designer on 20/12/21.
//

import UIKit

class EditAndDeleteVC: BaseViewController {

    @IBOutlet weak var vwDeleteOptions: UIView!
    @IBOutlet weak var vwDEdit: UIView!
    @IBOutlet weak var vwDelete: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var completionHandlerdeleteProject: (() -> Void)?
    var completionHandlerdEditProject: (() -> Void)?
    let viewModel: EditAndDeleteHOVM = EditAndDeleteHOVM()
    var projectId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwDelete.setRoundCorners(radius: 7.0)
        vwDEdit.setRoundCorners(radius: 7.0)
        vwDeleteOptions.setRoundCorners(radius: 8.0)
        vwDeleteOptions.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bottomView.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        vwDeleteOptions.isHidden = true
    }
    
    @IBAction func actionYeseDelete(_ sender: Any) {
        self.deleteProject()
    }
    
    @IBAction func actionNoDelete(_ sender: Any) {
        vwDeleteOptions.isHidden = true
        bottomView.isHidden = false
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        vwDeleteOptions.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDidEditButtonAction(_ sender: UIButton) {
        vwDeleteOptions.isHidden = true
        self.dismiss(animated: true, completion: nil)
        self.completionHandlerdEditProject?()
    }
    
    @IBAction func tapDidDelateButtonAction(_ sender: UIButton) {
        bottomView.isHidden = true
        vwDeleteOptions.isHidden = false
    }
    
    func deleteProject() {
        let param = ["id": self.projectId]
        self.viewModel.deleteProjectHOApiCall(param) { (model) in
            self.vwDeleteOptions.isHidden = true
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerdeleteProject?()
        }
    }
}
