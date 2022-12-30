//
//  FeedBackScreenCOVC.swift
//  TA
//
//  Created by Applify on 28/02/22.
//

import UIKit
import GBFloatingTextField


class FeedBackScreenCOVC: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var feedbackQuestion: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingBtn1: UIButton!
    @IBOutlet weak var ratingBtn2: UIButton!
    @IBOutlet weak var ratingBtn3: UIButton!
    @IBOutlet weak var ratingBtn4: UIButton!
    @IBOutlet weak var ratingBtn5: UIButton!
    @IBOutlet weak var popUpVw: UIView!
    @IBOutlet weak var blackVw: UIView!
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    @IBOutlet weak var fadedSubmitView: UIView!
    @IBOutlet weak var messageTextView: GBFloatingTextView!
    
    var completionHandlerGoToOnPastListing: (() -> Void)?
    
    var feedbackCOViewModel: FeedbackCOViewModel = FeedbackCOViewModel()
    var projectCompletedViewModel:ProjectCompletedViewModel = ProjectCompletedViewModel()
    var dataPass = [String]()
    var rating = 0
    var profileImage = ""
    var projectIdComplete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTextView.isHidden = false
        fadedSubmitView.isHidden = true
        messageTextView.setLeftPadding(14.0)
        messageTextView.isFloatingLabel = true
        messageTextView.placeholder = " Write your Message"
        messageTextView.placeholderColor = UIColor.appBtnColorGrey
        messageTextView.topPlaceholderColor = UIColor.appFloatText
        messageTextView.selectedColor = UIColor.appFloatText
        messageTextView.setLeftPadding(14.0)
        messageTextView.delegate = self
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        popUpVw.setRoundCorners(radius: 8.0)
//        nameLbl.text = "\(dataPass[0]) \(dataPass[1])"
        
        self.feedbackQuestion.text = "How was your working experience with \(dataPass[0]) \(dataPass[1]) ?"
        
        self.popUpVw.isHidden = true
        self.blackVw.isHidden = true
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == messageTextView {
            let currentText = messageTextView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let updateText = currentText.replacingCharacters(in: stringRange, with: text)
            return updateText.count < 1001
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        fadedSubmitView.isHidden = true
          
    }

    @IBAction func backToPriviousControllerButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rating1btnAction(_ sender: UIButton) {
        emojiVw1.isHidden = true
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        rating = 1
    }
    @IBAction func rating2btnAction(_ sender: UIButton) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = true
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        rating = 2
    }
    @IBAction func rating3btnAction(_ sender: UIButton) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = true
        emojiVw4.isHidden = false
        emojiVw5.isHidden = false
        rating = 3
    }
    @IBAction func rating4btnAction(_ sender: UIButton) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = true
        emojiVw5.isHidden = false
        rating = 4
    }
    @IBAction func rating5btnAction(_ sender: UIButton) {
        emojiVw1.isHidden = false
        emojiVw2.isHidden = false
        emojiVw3.isHidden = false
        emojiVw4.isHidden = false
        emojiVw5.isHidden = true
        rating = 5
    }
    
    
    @IBAction func SubmitBtnAction(_ sender: UIButton) {
//        let firstName = dataPass[0]
//        let lastName = dataPass[1]
        let homeId = dataPass[2]
//        let image = dataPass[3]
        let projectId = dataPass[4]
//        if image == ""{
//            profileImage = "hjj"
//        }
//        else{
//            profileImage = image
//        }
//        var arr = [Any]()
//        var ratingImg = [String:Any]()
//        ratingImg = [
//            "name" : firstName + lastName,
//            "image" :  profileImage
//        ] as [String : Any]
//        arr.append(ratingImg)
//
        var param = NSDictionary()
        param = [
            "overAllFeedback": messageTextView.text ?? "",
            "ratingImages": [],
            "rating": "\(rating)",
            "homeownerId": "\(homeId)",
            "projectId": "\(projectId)"
        ] as [String : Any] as NSDictionary
      
        var prms = NSDictionary()
        prms = ["apicontractorrating" : param]
        feedbackCOViewModel.postFeedbackCOApiCall(param as! [String : Any]) { model in
            self.updateStatusOngoingProject()
        }
    }
    
    func updateStatusOngoingProject() {
        let params = ["id": "\(self.projectIdComplete )","status": "9"] as [String : Any]
        projectCompletedViewModel.updateStatus(params: params) { response in
        self.messageTextView.removeFromSuperview()
            self.popUpVw.isHidden = false
            self.blackVw.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.popUpVw.isHidden = true
                self.blackVw.isHidden = true
                self.navigationController?.popViewController(animated: true)
                self.completionHandlerGoToOnPastListing?()
            }
        }
    }
}
