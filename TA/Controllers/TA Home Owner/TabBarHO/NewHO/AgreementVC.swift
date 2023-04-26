//
//  AgreementVC.swift
//  TA
//
//  Created by applify on 14/01/22.
//

import UIKit
import WebKit

class AgreementVC: BaseViewController {
    
    @IBOutlet weak var whiteBlurvw: UIView!
    @IBOutlet weak var webVww: WKWebView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var viewBidsVM: ViewBidsVM = ViewBidsVM()
    var activityIndicator: UIActivityIndicatorView!
    var projectId = Int()
    var bidId = Int()
    var userId = Int()
    var linkStr = ""
    var completionHandlerGoToBidDetailScreen: (() -> Void)?
    var webViewCookieStore: WKHTTPCookieStore!
        let webViewConfiguration = WKWebViewConfiguration()
    
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webVww.navigationDelegate = self
        webVww.uiDelegate = self
        navigationController?.navigationBar.isHidden = true
        bgView.addCustomShadow()
        saveBtn.setRoundCorners(radius: 6.0)
        saveBtn.isEnabled = true
        nextBtn.setRoundCorners(radius: 6.0)
        
        setIndicator()
                
        if self.isFrom == "InvitedTaskCO" {
            linkStr = "\(APIUrl.UserApis.agreementTaskDocument)projectId=\(projectId)&userId=\(userId)&bidId=\(bidId)"
            self.saveAreementSubtaskApiCall()
//            self.saveAreementApiCall()
            
        } else {
            self.saveAreementApiCall()
            linkStr = "\(APIUrl.UserApis.agreementDocument)projectId=\(projectId)&userId=\(userId)&bidId=\(bidId)"
        }
        
        let link = URL(string:linkStr)!
        let request = URLRequest(url: link)
        webViewCookieStore = webVww.configuration.websiteDataStore.httpCookieStore
        webVww.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFrom == "InvitedTaskCO" {
            self.saveAreementSubtaskApiCall()
//            self.saveAreementApiCall()
        } else {
            self.saveAreementApiCall()
        }
    }
    
    func saveAreementSubtaskApiCall() {
        let param = ["projectId": projectId, "bidId": bidId]
        viewBidsVM.saveAgreementSubTaskApiCall(param) { model in
            self.linkStr = model?.data?.app?.downloadURL ?? ""

            let link = URL(string:self.linkStr)!
            let request = URLRequest(url: link)
            self.webViewCookieStore = self.webVww.configuration.websiteDataStore.httpCookieStore
            self.webVww.load(request)
        }
    }
    
    func saveAreementApiCall() {
        let param = ["projectId": projectId, "bidId": bidId]
        viewBidsVM.saveAgreementApiCall(param) { model in
            self.linkStr = model?.data?.app?.downloadURL ?? ""

            if let link = URL(string:self.linkStr) {
                let request = URLRequest(url: link)
                self.webViewCookieStore = self.webVww.configuration.websiteDataStore.httpCookieStore
                self.webVww.load(request)
            }
            
        }
    }

    @IBAction func actionNext(_ sender: Any) {
        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "AcceptBidPaymentVc") as? AcceptBidPaymentVc
        if self.isFrom == "InvitedTaskCO" {
            destinationViewController!.isFrom = "InvitedTaskCO"
        }
        destinationViewController!.completionHandlerGoToAgreementScreen = { [weak self] in
            self?.present(destinationViewController!, animated: true, completion: nil)
            let vc = Storyboard.newHO.instantiateViewController(withIdentifier: "EVerificationHOVC") as? EVerificationHOVC
            if self?.isFrom == "InvitedTaskCO" {
                vc!.isFrom = "InvitedTaskCO"
            }
            vc!.completionHandlerGoToAgreementScreen = { [weak self] in
                self!.navigationController?.popViewController(animated: true)
                self!.completionHandlerGoToBidDetailScreen?()
            }
            vc!.projectId = self?.projectId ?? 0
            vc!.bidId = self?.bidId ?? 0
            vc!.userId = self?.userId ?? 0
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    
    @IBAction func saveAgreementAction(_ sender: UIButton) {
        self.downLoadImagesAndSave(url: linkStr, fileName: "\(randomString()).pdf")
//        self.downloadPdf(url: linkStr, fileName: "\(randomString()).pdf")
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.downLoadImagesAndSave(url: linkStr, fileName: "\(randomString()).pdf")
//        self.downloadPdf(url: linkStr, fileName: "\(randomString()).pdf")
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    func downloadPdf(url:String, fileName:String) {
        let fileUrl : String = "\(url)"
        
        DispatchQueue.main.async {
            let url = URL(string: fileUrl)
            let pdfData = try? Data.init(contentsOf: url!)
            let resDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!) as URL
            let pdfFileName = "Dhiraj_\(fileName)"
            let filePath = resDocPath.appendingPathComponent(pdfFileName)
            
            do {
                try pdfData?.write(to: filePath, options: .atomic)
                print("File Saved")
            } catch {
                print("Some error in code")
            }
            
        }
    }
    
    func downLoadImagesAndSave(url:String, fileName:String) {
        DispatchQueue.main.async {
            Progress.instance.show()
        }
        let urlString = url
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("TA_\(fileName)")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            DispatchQueue.main.async {
                Progress.instance.hide()
            }
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                DispatchQueue.main.async {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    self.present(activityViewController, animated: true, completion: nil)
                                    self.whiteBlurvw.isHidden = true
                                }
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    DispatchQueue.main.async {
                        showMessage(with: "File already exists", theme: .success)
                    }
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                DispatchQueue.main.async {
                    Progress.instance.hide()
                }
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
    
}

extension AgreementVC :WKUIDelegate, WKNavigationDelegate{
    
    //, UIDocumentInteractionControllerDelegate,URLSessionDownloadDelegate
    func setIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        saveBtn.isHidden = true
        view.addSubview(activityIndicator)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
 
    
//    // DOWNLOD FILE
    
    
//    func webView(_ webView: WKWebView,
//                     decidePolicyFor navigationResponse: WKNavigationResponse,
//                     decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//            let url = navigationResponse.response.url
////            if (openInDocumentPreview(url!)) {
//                let documentUrl = url?.appendingPathComponent(navigationResponse.response.suggestedFilename!)
//                loadAndDisplayDocumentFrom(url: documentUrl!)
//                decisionHandler(.cancel)
////            } else {
////                decisionHandler(.allow)
////            }
//        }
//    
//    private func loadAndDisplayDocumentFrom(url downloadUrl : URL) {
//            let localFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(downloadUrl.lastPathComponent)
//
//
//
//            // getAllCookies needs to be called in main thread??? (https://medium.com/appssemble/wkwebview-and-wkcookiestore-in-ios-11-5b423e0829f8)
//    //??? needed?? DispatchQueue.main.async {
//                self.webViewCookieStore.getAllCookies { (cookies) in
//                for cookie in cookies {
//                    if cookie.domain.range(of: "my.domain.xyz") != nil {
//                        HTTPCookieStorage.shared.setCookie(cookie)
//                        debugPrint("Sync cookie [\(cookie.domain)] \(cookie.name)=\(cookie.value)")
//                    } else {
//                        debugPrint("Skip cookie [\(cookie.domain)] \(cookie.name)=\(cookie.value)")
//                    }
//                }
//                debugPrint("FINISHED COOKIE SYNC")
//                
//                debugPrint("Downloading document from url=\(downloadUrl.absoluteString)")
//                URLSession.shared.dataTask(with: downloadUrl) { data, response, err in
//                    guard let data = data, err == nil else {
//                        debugPrint("Error while downloading document from url=\(downloadUrl.absoluteString): \(err.debugDescription)")
//                        return
//                    }
//                    
//                    if let httpResponse = response as? HTTPURLResponse {
//                        debugPrint("Download http status=\(httpResponse.statusCode)")
//                    }
//                    // write the downloaded data to a temporary folder
//                    do {
//                        try data.write(to: localFileURL, options: .atomic)   // atomic option overwrites it if needed
//                        debugPrint("Stored document from url=\(downloadUrl.absoluteString) in folder=\(localFileURL.absoluteString)")
//                        
//                        DispatchQueue.main.async {
//                            print("--------\(localFileURL)")
//                        }
//                    } catch {
//                        debugPrint(error)
//                        return
//                    }
//                }.resume()
//            }
//        }
//    
//    private func openInDocumentPreview(_ url : URL) -> Bool {
//            return url.absoluteString.contains("/APP/connector")
//        }
}

extension AgreementVC: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Download Location", location)
        
        guard let url = downloadTask.originalRequest?.url else {
            return
        }
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        
        try? FileManager.default.removeItem(at: destinationPath)
        
        do {
            var urlss = URL(string: linkStr)
            try FileManager.default.copyItem(at: location, to: destinationPath)
            urlss = destinationPath
            print("File Manager Location- ", urlss ?? "NOT")
        } catch let error {
            print("Copy Eror: \(error.localizedDescription)")
        }
    }
}
