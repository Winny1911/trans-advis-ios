//
//  HelpAndSupportVC.swift
//  TA
//
//  Created by applify on 08/03/22.
//

import UIKit

class HelpAndSupportVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contactNoLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    var helpAndSupportViewModel :  HelpAndSupportVM = HelpAndSupportVM()
    var faq = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        topView.addCustomShadow()
        heplAndSupportAPI()
        self.FAQAPI()
    }
    

    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func FAQAPI(){
        helpAndSupportViewModel.helpAndSupportApi([:]){ response in
            self.faq = response?.data.faqURL ?? "https://p2-testweb.ta123test.com/faq"
            let myUrl = URL(string: self.faq)
            let myRequest = URLRequest(url: myUrl!)
        }
    }
    
    func heplAndSupportAPI(){
        helpAndSupportViewModel.helpAndSupportApi([:]){ response in
            self.emailLbl.text = response?.data.supportEmail ?? ""
            self.contactNoLbl.text = response?.data.supportNumber ?? ""
            self.titleLbl.text = response?.data.contactText ?? ""
            
        }
    }
    
    @IBAction func FAQBtnAction(_ sender: Any) {
        let destinationVC = Storyboard.profileHO.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
        destinationVC?.faq = self.faq
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
}
