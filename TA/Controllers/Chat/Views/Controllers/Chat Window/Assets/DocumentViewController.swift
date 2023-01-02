//
//  DocumentViewController.swift
//  Business App
//
//  Created by Ankit Goyal on 30/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController
{
    var docController:UIDocumentInteractionController!
    var document_path:String! = ""
    var document_name:String! = ""
    
    // MARK: - View Will Appear and DisAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNeedsStatusBarAppearanceUpdate()
    }
            
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        UIFunction.AGLogs(log: "Jai Shri Ram. JHMPPWPBJASHJH" as AnyObject)
        self.openDocument()
    }

    func openDocument() {
        if (self.document_path.isServerImage()) {
            if let fileUrl = URL(string: self.document_path) {
                UIFunction.downloadDocumentInLocalDirectory(url: fileUrl)
                { (localPath) in
                    if (localPath != nil) {
                        DispatchQueue.main.async {
                            self.openDocumentController(url: localPath!, document_name: self.document_name)
                        }
                    }
                }
            }
        } else {
            if let url = URL(string: self.document_path) {
                DispatchQueue.main.async {
                    self.openDocumentController(url: url, document_name: self.document_name)
                }
            }
        }
    }
}

// MARK: - Delegate
extension DocumentViewController : UIDocumentInteractionControllerDelegate {
   
    func openDocumentController(url:URL, document_name:String) {
        self.docController = UIDocumentInteractionController(url: url)
//        self.docController.name = document_name
        self.docController.delegate = self
        self.docController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
        
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        Progress.instance.hide()
        self.dismiss(animated: true, completion: nil)
    }
    
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        DispatchQueue.main.async {
            Progress.instance.show()
        }
    }
}
