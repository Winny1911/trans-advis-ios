//
//  OngoingProjectDetailVC.swift
//  TA
//
//  Created by Applify  on 11/01/22.
//

import UIKit
import SDWebImage

class OngoingProjectDetailVC: BaseViewController {

    @IBOutlet weak var projectDiscriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var topConstraintFiles: NSLayoutConstraint!

    @IBOutlet weak var attachedFilesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var lblNoRecords: UILabel!
    @IBOutlet weak var lineProjectFIles: UIView!
    @IBOutlet weak var lblStaticProjectProgress: UILabel!
    @IBOutlet weak var vwwTasks: UIView!
    @IBOutlet weak var blurVwBtn: UIView!
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var stckVwHeight: NSLayoutConstraint!
    @IBOutlet weak var stckVw: UIStackView!
    @IBOutlet weak var lblPopUpDesc: UILabel!
    @IBOutlet weak var lblPopUpTitle: UILabel!
    @IBOutlet weak var imgTickHeight: NSLayoutConstraint!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var popUpVw: UIView!
    @IBOutlet weak var blackVw: UIView!
    
    @IBOutlet weak var btnAddtask: UIButton!
    @IBOutlet weak var tblVwTasks: UITableView!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var btnMarkCompleted: UIButton!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var collVwFiles: UICollectionView!
    @IBOutlet weak var progressVw: CircularProgressView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblContract: UILabel!
    @IBOutlet weak var lblContractAmt: UILabel!
    @IBOutlet weak var lblProjectDesc: UILabel!
    @IBOutlet weak var lblProjectTitle: UILabel!
    @IBOutlet weak var btnTransactions: UIButton!
    @IBOutlet weak var btnOrderMaterial: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var mainVwMainProject: UIView!
    @IBOutlet weak var bottomVwOrderlist: UIView!
    @IBOutlet weak var btnOrderlist: UIButton!
    @IBOutlet weak var bottomVwTasks: UIView!
    @IBOutlet weak var btnTasks: UIButton!
    @IBOutlet weak var bottomvwMainProject: UIView!
    @IBOutlet weak var btnMainProject: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topView: UIView!

    @IBOutlet weak var lblTasksCompleted: UITextView!
    
    @IBOutlet weak var pvTasksProgressCompleted: UIProgressView!
    
    var subtaskComptedId = 0
    var subTaskOrderListId = 0
    var subTaskOrderId = 0
    var isFromNotificationAcceptProject = false
    var dataPass = [String]()
    var floatProgress = Double(0.0)
    var completionHandlerGoToOnPastListing: (() -> Void)?
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var projectId = 0
    var projectIdComplete = 0
    var selectedType = "Main"
    var ongoingProjectDetail = OngoingProjectsDetail()
    var idOfTask = ""
    var popUpType = ""
    
    var downloadFileName = ""
    var downloadFileUrl = ""
    var projectstatus = 0
    
    var arrSubTaskList = [SubTaskListReponseModelDetail]()
    
    var arrOfOrderList = [OrderListResponseModelDetails]()
    var isFrom = ""
    var idOfSubTask = 0
    var mainprojectID = 0
    var diverableData = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.isHidden = true
        infoLabel.isHidden = true
        infoView.addCustomShadow()
        lblNoRecords.isHidden = true
        blurVwBtn.isHidden = true
        popUpVw.setRoundCorners(radius: 5.0)
        btnAddtask.setRoundCorners(radius: btnAddtask.frame.height / 2)
        btnOrderMaterial.setRoundCorners(radius: 5.0)
        btnTransactions.setRoundCorners(radius: 5.0)
        imgVwProfile.setRoundCorners(radius: imgVwProfile.frame.height / 2)
        btnSendMsg.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        btnSendMsg.layer.borderWidth = 1.5
        bottomVw.addCustomShadow()
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        pvTasksProgressCompleted.transform = pvTasksProgressCompleted.transform.scaledBy(x: 1, y: 3)
        
//        selectedType = "Main"
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnTasks, unselectedButton2: btnOrderlist, selectedView: bottomvwMainProject, unselectedView1: bottomVwTasks, unselectedView2: bottomVwOrderlist)
        
        self.handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
        registerCells()
        
        self.tblVwTasks.delegate = self
        self.tblVwTasks.dataSource = self
//
        self.collVwFiles.delegate = self
        self.collVwFiles.dataSource = self
        
        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(self.downloadContractTapped(_:)))
        self.lblContract.isUserInteractionEnabled = true
        self.lblContract.addGestureRecognizer(downloadTap)
        
        if isFrom == "SubTask" {
            self.btnMainProject.setTitle("Sub Task", for: .normal)
            self.vwwTasks.isHidden = true
        } else {
            self.btnMainProject.setTitle("Main Project", for: .normal)
            self.vwwTasks.isHidden = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToTaskList(notification:)), name: Notification.Name("GoToTaskList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedType == "Main" {
            self.handleMainProjectTap()
            self.fetchOngoingProjectDetail()
        } else if selectedType == "Task" {
            self.taskTap()
            self.fetchOngoingProjectTasks()
        } else if selectedType == "Orderlist" {
            self.orderListTap()
        }
    }
    
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
        if self.infoView.isHidden {
            infoView.isHidden = false
            infoLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.infoView.isHidden = true
                self.infoLabel.isHidden = true
            }
        } else {
            infoView.isHidden = true
            infoLabel.isHidden = true
        }
    }
    
    @IBAction func sendMessageBtnAction(_ sender: Any) {
        var id = self.ongoingProjectDetail.project_details?.user_data?.id ?? 0
        let user_id = String("ID_\(id ?? 0)")
        let firstName = self.ongoingProjectDetail.project_details?.user_data?.firstName  ?? ""
        let lastName = self.ongoingProjectDetail.project_details?.user_data?.lastName ?? ""
        let user_name = (firstName + " " + lastName)
        let user_img = self.ongoingProjectDetail.project_details?.user_data?.profilePic ?? ""
       
        openChatWindow(user_id: user_id, user_image: user_img, user_name: user_name)
    }
    
    func openChatWindow(user_id: String?, user_image: String?, user_name: String?) {
        DispatchQueue.main.async {
            if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
                chatController.hidesBottomBarWhenPushed = true
                chatController.viewModel.user_id = user_id
                chatController.viewModel.user_name = user_name
                chatController.viewModel.user_image = user_image
                self.navigationController?.pushViewController(chatController, animated: true)
            }
        }
    }
    @objc func goToTaskList(notification: Notification) {
        self.orderListTap()
    }
    
    @objc func downloadContractTapped(_ sender: UITapGestureRecognizer) {
        if downloadFileUrl != "" && downloadFileName != "" {
            let a = self.downloadFileUrl
            let last4 = String(a.suffix(4))
            if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
                if let url = URL(string: a),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    showMessage(with: "Agreement downloaded successfully.", theme: .success)
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } else {
                self.downLoadImagesAndSave(url: downloadFileUrl, fileName: downloadFileName)
            }
        }
    }
    
    func downLoadImagesAndSave(url:String, fileName:String) {
        DispatchQueue.main.async {
            Progress.instance.show()
        }
        let urlString = url
        //let url = URL(string: urlString)
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
    
    func handlePopUp(isHiddenObj:Bool , isTickHide: Bool, tickHeight: CGFloat, isStackHide:Bool, stackHeight:CGFloat, progressTitle:String, progressDesc:String) {
        self.btncancel.isHidden = isStackHide
        self.btnComplete.isHidden = isStackHide
        
        self.stckVwHeight.constant = stackHeight
        self.stckVw.isHidden = isStackHide
        
        self.lblPopUpDesc.isHidden = isHiddenObj
        self.lblPopUpTitle.isHidden = isHiddenObj
        
        self.lblPopUpTitle.text = progressTitle
        self.lblPopUpDesc.text = progressDesc
        
        self.popUpVw.isHidden = isHiddenObj
        self.blackVw.isHidden = isHiddenObj
        
        self.imgTickHeight.constant = tickHeight
        self.imgTick.isHidden = isTickHide
    }
    
    func registerCells() {
        self.collVwFiles.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        self.tblVwTasks.register(UINib.init(nibName: "TasksTblVwCell", bundle: nil), forCellReuseIdentifier: "TasksTblVwCell")
        self.tblVwTasks.register(UINib.init(nibName: "OrderListItemTbllVwCell", bundle: nil), forCellReuseIdentifier: "OrderListItemTbllVwCell")
    }
    
    func handleSelection(selectedBtn:UIButton, unselectedButton1:UIButton, unselectedButton2:UIButton, selectedView:UIView, unselectedView1:UIView, unselectedView2:UIView) {
        selectedBtn.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton1.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton2.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        
        selectedBtn.setTitleColor(UIColor.appSelectedBlack, for: .normal)
        unselectedButton1.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        unselectedButton2.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView1.backgroundColor = UIColor.appUnSelectedgrey
        unselectedView2.backgroundColor = UIColor.appUnSelectedgrey
    }
    
    func fetchOngoingProjectDetail() {
        ongoingProejctsCOViewModel.getOngoingProjectDetailsApi(["id":self.projectId]) { [self] model in
            dataPass.append(model?.data?.allProjects?.project_details?.user_data?.firstName ?? "")
            dataPass.append(model?.data?.allProjects?.project_details?.user_data?.lastName ?? "")
            dataPass.append("\(model?.data?.allProjects?.project_details?.user_data?.id ?? 0)")
            dataPass.append(model?.data?.allProjects?.project_details?.user_data?.profilePic ?? "")
            dataPass.append("\(model?.data?.allProjects?.project_details?.id ?? 0)")
            self.floatProgress = Double(0.0)
            imgVwProfile.sd_setImage(with: URL(string: model?.data?.allProjects?.project_details?.user_data?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            lblName.text! = "\(model?.data?.allProjects?.project_details?.user_data?.firstName ?? "") \(model?.data?.allProjects?.project_details?.user_data?.lastName ?? "")"
            lblProjectTitle.text! = "\(model?.data?.allProjects?.project_details?.title ?? "")"
            lblTitle.text! = "Project Details" //"\(model?.data?.allProjects?.project_details?.title ?? "")"
            lblProjectDesc.text! = "\(model?.data?.allProjects?.project_details?.description ?? "")"
            if model?.data?.allProjects?.project_details?.bids?.count ?? 0 > 0 {
//                lblContractAmt.text = "$ \(model?.data?.allProjects?.project_details?.bids?[0].bidAmount ?? "0.0")"
                self.addressLabel.text = "\(model?.data?.allProjects?.project_details?.addressLine1 ?? "" )"
//                if model?.data?.allProjects?.project_details?.addressLine1 ?? "" == model?.data?.allProjects?.project_details?.addressLine2 ?? "" {
//                    self.addressLabel.text = "\(model?.data?.allProjects?.project_details?.addressLine2 ?? "" ), \(model?.data?.allProjects?.project_details?.zipCode ?? "")"
//                } else {
//                    self.addressLabel.text = "\(model?.data?.allProjects?.project_details?.addressLine1 ?? "" ), \(model?.data?.allProjects?.project_details?.city ?? "" ), \(model?.data?.allProjects?.project_details?.state ?? ""), \(model?.data?.allProjects?.project_details?.zipCode ?? "")"
//                }
                
                self.projectTypeLabel.text = model?.data?.allProjects?.project_details?.projectCategory?.title ?? "" //"\(model?.data?.allProjects?.project_details?.type ?? "" )"
                var realAmount = "\(model?.data?.allProjects?.project_details?.bids?[0].amountRecievable ?? "0.0")"
                
                for i in 0..<(model?.data?.allProjects?.project_details?.project_deliverable?.count ?? 0) {
                    diverableData.append("\(String(describing: model?.data?.allProjects?.project_details?.project_deliverable?[i].deliveralble ?? ""))")
                }
                diverableData.removingDuplicates()
                diverableData.removeDuplicates()
                var diverable = diverableData.map{String($0)}.joined(separator: ", ")
                self.projectDeliverableLabel.text = "\(diverable)"
                
                realAmount = "\(model?.data?.allProjects?.project_details?.bids?[0].amountRecievable ?? "0.0")"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                lblContractAmt.text =  "$ \(formattedString ?? "")"
                
                if let str = model?.data?.allProjects?.project_details?.bids?[0].bids_documents?[0].title ?? "" as? String {
                    if (str.contains(".png")) || (str.contains(".jpeg")) || (str.contains(".jpg")) {
                        lblContract.text = "\(model?.data?.allProjects?.project_details?.bids?[0].bids_documents?[0].title ?? "").png"
                    } else {
                        lblContract.text = "\(model?.data?.allProjects?.project_details?.bids?[0].bids_documents?[0].title ?? "").doc"
                    }
                } else {
                    lblContract.text = "\(model?.data?.allProjects?.project_details?.bids?[0].bids_documents?[0].title ?? "").doc"
                }
                downloadFileName = "\(model?.data?.allProjects?.project_details?.bids?[0].bids_documents?[0].title ?? "")"
                downloadFileUrl = "\(model?.data?.allProjects?.project_details?.bids?[0].bids_documents?[0].file ?? "")"
                lblStartDate.text = DateHelper.convertDateString(dateString: model?.data?.allProjects?.project_details?.bids?[0].proposedStartDate ?? "2024-04-08T00:00:00.000Z", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
                lblEndDate.text = DateHelper.convertDateString(dateString: model?.data?.allProjects?.project_details?.bids?[0].proposedEndDate ?? "2024-04-08T00:00:00.000Z", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            if model?.data?.allProjects?.project_details?.status == 2 {
                self.btnMarkCompleted.setTitle("Mark Completed", for: .normal)
                self.projectstatus = 2
            }
            if model?.data?.allProjects?.project_details?.status == 9 {
                self.btnMarkCompleted.setTitle("Completed", for: .normal)
                self.projectstatus = 9
            }
            if model?.data?.allProjects?.project_details?.status == 10 {
                self.btnMarkCompleted.setTitle("Completed", for: .normal)
                self.projectstatus = 10
            }
            if model?.data?.allProjects?.project_details?.status == 11 {
                self.projectstatus = 11
            }
            self.mainprojectID = 0
            self.mainprojectID = model?.data?.allProjects?.projectId ?? 0
            self.idOfSubTask = 0
            if model?.data?.allProjects?.project_details?.tasks?.count ?? 0 > 0 {
                self.idOfSubTask = model?.data?.allProjects?.project_details?.tasks?[0].projectId ?? 0
                subTaskOrderListId = model?.data?.allProjects?.project_details?.tasks?[0].mainProjectId ?? 0
                self.subtaskComptedId = model?.data?.allProjects?.project_details?.tasks?[0].id ?? 0
            }

            projectDiscriptionLabel.text = "Project Deliverable"
            if self.isFrom == "SubTask" {
                projectDiscriptionLabel.text = "Description"
                projectTypeLabel.text = model?.data?.allProjects?.project_details?.projectCategory?.title ?? ""
                self.projectDeliverableLabel.text = model?.data?.allProjects?.project_details?.tasks?[0].taskDescription ?? ""
                lblPercentage.isHidden = true
                progressVw.isHidden = true
                blurVwBtn.isHidden = true
                lblStaticProjectProgress.isHidden = true
                lineProjectFIles.isHidden = true
                topConstraintFiles.constant = -60
                if self.projectstatus == 9 || self.projectstatus == 10 {
                    self.btnTransactions.isHidden = true
                    self.btnSendMsg.isHidden = true
                    self.btnMarkCompleted.isUserInteractionEnabled = false
                    self.btnMarkCompleted.backgroundColor = UIColor.appBtnColorWhite
//                    self.btnMarkCompleted.setTitleColor(UIColor.appColorGreen, for: .normal)
                    self.btnMarkCompleted.setTitleColor(UIColor(hex: "#4EC72A"), for: .normal)
                    self.btnMarkCompleted.setTitle("Awaiting Contractor's Approval", for: .normal)
                } else {
                    self.btnSendMsg.isHidden = false
                    self.btnMarkCompleted.isUserInteractionEnabled = true
                    self.btnMarkCompleted.backgroundColor = UIColor.appColorGreen
                    self.btnMarkCompleted.setTitleColor(UIColor.white, for: .normal)
                    self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
                }
            } else {
                lblPercentage.isHidden = false
                progressVw.isHidden = false
                blurVwBtn.isHidden = false
                lblStaticProjectProgress.isHidden = false
                lineProjectFIles.isHidden = false
                //topConstraintFiles.constant = 18
                
                lblPercentage.text = "\(Int(Double(model?.data?.allProjects?.progress ?? "0") ?? Double(0.0)))%"
               
                if let progress = model?.data?.allProjects?.progress {
                    self.floatProgress = (Double(progress)! / Double(100.0))
                    if self.floatProgress >= 1.0 {
                        blurVwBtn.isHidden = true
                    } else {
                        blurVwBtn.isHidden = false
                    }
                    progressVw.setProgressWithAnimation(duration: 1.0, value: Float(floatProgress))
                    
                    self.pvTasksProgressCompleted.progress = Float(floatProgress)
                } else {
                    progressVw.setProgressWithAnimation(duration: 1.0, value: 0.0)
                }
                
                if self.projectstatus == 2 {
                    if model?.data?.allProjects?.progress == "100.0" {
                        self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
                        self.blurVwBtn.isHidden = true
                    } else {
                        self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
                        self.blurVwBtn.isHidden = false
                    }
                } else if self.projectstatus == 9 {
                    self.btnMarkCompleted.setTitle("Completed", for: .normal)
                    self.blurVwBtn.isHidden = false
                } else if self.projectstatus == 10 {
                    self.btnMarkCompleted.setTitle("Accepted", for: .normal)
                    self.blurVwBtn.isHidden = false
                } else if self.projectstatus == 11 {
                    if model?.data?.allProjects?.progress == "100.0" {
                        self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
                        self.blurVwBtn.isHidden = true
                    } else {
                        self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
                        self.blurVwBtn.isHidden = false
                    }
//                    self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
//                    self.blurVwBtn.isHidden = false
                } else {
                    self.btnMarkCompleted.setTitle("Mark Complete", for: .normal)
                    self.blurVwBtn.isHidden = true
                    if let progressFloat = model?.data?.allProjects?.progress {
                        let  progressF = (Double(progressFloat)! / Double(100.0))
                        if progressF >= 1.0 {
                            self.blurVwBtn.isHidden = true
                        } else {
                            self.blurVwBtn.isHidden = true
                        }
                    } else {
                        self.blurVwBtn.isHidden = true
                    }
                }
                
                
                if self.projectstatus == 9 {
                    self.blurVwBtn.isHidden = true //false
                    self.blurVwBtn.backgroundColor = UIColor(hex: "#FFFFFF")
                    self.btnSendMsg.isHidden = true
                    self.btnMarkCompleted.isUserInteractionEnabled = false
                    self.btnMarkCompleted.backgroundColor = UIColor.appBtnColorWhite
//                    self.btnMarkCompleted.setTitleColor(UIColor.appColorGreen, for: .normal)
                    self.btnMarkCompleted.setTitleColor(UIColor(hex: "#4EC72A"), for: .normal)
                    self.btnMarkCompleted.setTitle("Awaiting Homeowner's approval", for: .normal)
                }
                if self.projectstatus == 10 {
                    self.blurVwBtn.isHidden = true //false
                    self.blurVwBtn.backgroundColor = UIColor(hex: "#FFFFFF")
                    self.btnSendMsg.isHidden = true
                    self.btnMarkCompleted.isUserInteractionEnabled = false
                    self.btnMarkCompleted.backgroundColor = UIColor.appBtnColorWhite
//                    self.btnMarkCompleted.setTitleColor(UIColor.appColorGreen, for: .normal)
                    self.btnMarkCompleted.setTitleColor(UIColor(hex: "#4EC72A"), for: .normal)
                    self.btnMarkCompleted.setTitle("Awaiting Addmin Approval", for: .normal)
                }
            }
            
            ongoingProjectDetail = model?.data?.allProjects ?? OngoingProjectsDetail()
            subTaskOrderId = ongoingProjectDetail.projectId ?? 0
            collVwFiles.reloadData()
            fetchOngoingProjectTaskssDetails()
        }
    }
    
    func fetchOngoingProjectTaskssDetails() {
        ongoingProejctsCOViewModel.getOngoingProjectTasksApi(["projectId":self.projectIdComplete]) { [self] model in
            self.arrSubTaskList.removeAll()
            self.lblNoRecords.isHidden = true
            self.arrSubTaskList = model?.data?.getTasks ?? [SubTaskListReponseModelDetail]()
            lblTasksCompleted.text = ""
            for detail in self.arrSubTaskList {
                if detail.status == 1 {
                    lblTasksCompleted.text = lblTasksCompleted.text?.appending("\(detail.task!)\n" ?? "")
                }
            }
            if self.arrSubTaskList.count <= 0 {
                blurVwBtn.isHidden = true
            } else {
                if floatProgress >= 1.0 {
                    blurVwBtn.isHidden = true
                } else {
                    blurVwBtn.isHidden = false
                }
            }
        }
    }
    
    func fetchOngoingProjectTasks() {
        if self.projectstatus == 9 || self.projectstatus == 10 {
            self.btnAddtask.isHidden = true
        } else {
            self.btnAddtask.isHidden = false
        }
        ongoingProejctsCOViewModel.getOngoingProjectTasksApi(["projectId":self.projectIdComplete]) { [self] model in
            self.arrSubTaskList.removeAll()
            self.lblNoRecords.isHidden = true
            self.arrSubTaskList = model?.data?.getTasks ?? [SubTaskListReponseModelDetail]()
            if self.arrSubTaskList.count <= 0 {
                self.lblNoRecords.isHidden = false
            } else {
                self.lblNoRecords.isHidden = true
            }
            self.tblVwTasks.reloadData()
        }
    }
    
    func handleMainProjectTap() {
        selectedType = "Main"
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnTasks, unselectedButton2: btnOrderlist, selectedView: bottomvwMainProject, unselectedView1: bottomVwTasks, unselectedView2: bottomVwOrderlist)
        self.tblVwTasks.isHidden = true
        self.lblNoRecords.isHidden = true
        self.mainVwMainProject.isHidden = false
        self.btnAddtask.isHidden = true
        self.fetchOngoingProjectDetail()
    }
    
    func taskTap() {
        selectedType = "Task"
        self.handleSelection(selectedBtn: btnTasks, unselectedButton1: btnMainProject, unselectedButton2: btnOrderlist, selectedView: bottomVwTasks, unselectedView1: bottomvwMainProject, unselectedView2: bottomVwOrderlist)
        self.tblVwTasks.isHidden = false
        self.mainVwMainProject.isHidden = true
        self.btnAddtask.isHidden = false
        self.fetchOngoingProjectTasks()
    }
    
    func orderListTap() {
        selectedType = "Orderlist"
        self.handleSelection(selectedBtn: btnOrderlist, unselectedButton1: btnMainProject, unselectedButton2: btnTasks, selectedView: bottomVwOrderlist, unselectedView1: bottomvwMainProject, unselectedView2: bottomVwTasks)
        self.tblVwTasks.isHidden = false
        self.mainVwMainProject.isHidden = true
        self.btnAddtask.isHidden = true
        self.fetchOrderList()
        
    }
    
    func fetchOrderList() {
        self.lblNoRecords.isHidden = true
        var params = [String:Any]()
        if isFrom == "SubTask" {
            params = [
            "projectId" : self.subTaskOrderListId,
            "subtaskId": self.subTaskOrderId // self.ongoingProjectDetail.projectId ?? 0 
            ] as [String : Any]
        } else {
            if isFromNotificationAcceptProject == false {
                params = [
                "projectId" : projectIdComplete, //self.ongoingProjectDetail.projectId ?? 0,
                "subtaskId" : 0
                ] as [String : Any]
            } else {
                params = [
                "projectId" : projectIdComplete, //self.ongoingProjectDetail.projectId ?? 0
                "subtaskId" : 0
                ] as [String : Any]
            }
        }
        ongoingProejctsCOViewModel.getOrderListsApi(params) { [self] model in
            self.arrOfOrderList.removeAll()
            self.lblNoRecords.isHidden = true
            self.arrOfOrderList = model?.data ?? [OrderListResponseModelDetails]()
            if self.arrOfOrderList.count <= 0 {
                self.lblNoRecords.isHidden = false
            } else {
                self.lblNoRecords.isHidden = true
            }
            self.tblVwTasks.reloadData()
        }
    }
    
    @IBAction func actionYes(_ sender: Any) {
        if self.isFrom == "SubTask" {
            self.markCompleteTaskAPI()
        } else if self.popUpType == "Delete" {
            self.deleteTask()
        } else {
            self.updateStatusTask()
        }
    }
    
    func markCompleteTaskAPI() {
        ongoingProejctsCOViewModel.markCompletedTaskApi(["id":"\(self.subtaskComptedId)" , "status":"9"]) { [self] model in
            handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
            popUpType = ""
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func deleteTask() {
        ongoingProejctsCOViewModel.deleteTaskApi(["id":self.idOfTask]) { [self] model in
            handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
            showMessage(with: model?.data?.customMessage ?? "", theme: .success)
            popUpType = ""
            fetchOngoingProjectTasks()
        }
    }
    
    func updateStatusTask() {
        var params = [String:Any]()
        if self.popUpType == "Incomplete" {
            params = ["id":self.idOfTask,"status": "0"]
        } else {
            params = ["id":self.idOfTask,"status": "1"]
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
                fetchOngoingProjectTasks()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    fetchOngoingProjectDetail()
                }
            }
        }
    }
    
    @IBAction func actioNo(_ sender: Any) {
        self.popUpType = ""
        self.idOfTask = ""
        self.handlePopUp(isHiddenObj: true, isTickHide: true, tickHeight: 0.0, isStackHide: true, stackHeight: 0.0, progressTitle: "", progressDesc: "")
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMainProject(_ sender: Any) {
        handleMainProjectTap()
    }
    
    @IBAction func actionTask(_ sender: Any) {
        taskTap()
    }
    
    @IBAction func actionOrderlist(_ sender: Any) {
        orderListTap()
    }
    
    @IBAction func actionMarkCompleted(_ sender: Any) {
        if self.isFrom == "SubTask" {
            self.btnComplete.setTitle("Complete", for: .normal)
            self.btncancel.setTitle("Cancel", for: .normal)
            self.popUpType = "Complete"
            self.handlePopUp(isHiddenObj: false, isTickHide: true, tickHeight: 0.0, isStackHide: false, stackHeight: 56.0, progressTitle: "Task Complete!", progressDesc: "Are you sure, you want to complete the task?")
        } else {
            if self.projectstatus == 9 {
                showMessage(with: "You have marked this project completed and currently waiting for Homeowner acceptance")
            } else {
                let vc = Storyboard.project.instantiateViewController(withIdentifier: "ProjectCompletedVC") as? ProjectCompletedVC
                vc!.projectIdComplete = self.projectIdComplete
                vc!.dataPass = self.dataPass ?? []
                vc!.completionHandlerGoToOnPastListing = { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                    self!.completionHandlerGoToOnPastListing?()
                }
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    @IBAction func actionOrderMaterial(_ sender: Any) {
        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderMaterialPopupViewController") as? OrderMaterialPopupViewController
        destinationViewController?.btnTapAction3 = {
            () in
            let destinationViewControllers = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "VendorListViewController") as? VendorListViewController
            if self.isFrom == "SubTask" {
                destinationViewControllers?.mainProejctId = self.subTaskOrderListId
                destinationViewControllers?.subTaskId = self.idOfSubTask
            } else {
                destinationViewControllers?.mainProejctId = self.mainprojectID
            }
            destinationViewControllers?.category = destinationViewController?.vendorId ?? "" //categoryTextField.text ?? ""
                self.navigationController?.pushViewController(destinationViewControllers!, animated: true)
        }
//        destinationViewController?.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(destinationViewController!, animated: true, completion: nil)
//        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @IBAction func actionTransaction(_ sender: Any) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "CO"
        if self.ongoingProjectDetail.project_details?.projectType == 1 {
            destinationViewController!.isType = "SubTask"
        } else {
            destinationViewController!.isType = "MainProject"
        }
        destinationViewController!.projectId = self.ongoingProjectDetail.projectId ?? 0
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
    }
    
    @IBAction func actionAddTask(_ sender: Any) {
//        let vc = Storyboard.project.instantiateViewController(withIdentifier: "AddNewTaskVC") as? AddNewTaskVC
        let vc = Controllers.addNewTaskVC
        vc!.completionHandlerGoToTaskListingOngoing = { [weak self] in
            self!.fetchOngoingProjectTasks()
        }
        vc!.projectId = self.ongoingProjectDetail.project_details?.id ?? 0
        vc!.isFrom = "AddNew"
        vc!.isEditableFlag = true
        NotificationCenter.default.post(name: Notification.Name("IsCreateNewTask"), object: nil)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension OngoingProjectDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFrom == "SubTask" {
            if self.ongoingProjectDetail.project_details?.project_files?.count == 0 || self.ongoingProjectDetail.project_details?.project_files == nil {
                self.attachedFilesLabel.text = "Attached Files"
            } else {
                self.attachedFilesLabel.text = "Attached Files (\(self.ongoingProjectDetail.project_details?.project_files?.count ?? 0))"
            }
            return ((self.ongoingProjectDetail.project_details?.project_files?.count ?? 0))
        } else {
            if self.ongoingProjectDetail.project_details?.bids?.count ?? 0 > 0 {
                self.attachedFilesLabel.text = "Attached Files (\((self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) + (self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?.count ?? 0)))"
                return ((self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) + (self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?.count ?? 0))
            } else {
                if self.ongoingProjectDetail.project_details?.project_files?.count == 0 || self.ongoingProjectDetail.project_details?.project_files == nil {
                    self.attachedFilesLabel.text = "Attached Files"
                } else {
                    self.attachedFilesLabel.text = "Attached Files (\(self.ongoingProjectDetail.project_details?.project_files?.count ?? 0))"
                }
                return ((self.ongoingProjectDetail.project_details?.project_files?.count ?? 0))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFrom == "SubTask" {
            if self.ongoingProjectDetail.project_details?.project_files?.count ?? 0 > 0 {
                if self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "png" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpg" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpeg" {
                    if let imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = imgStr
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                } else {
                    if let imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                        if let url = URL(string: imgStr) {
                            UIApplication.shared.open(url)
                        }
                    }
//                    let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                    destinationViewController!.isImage = true
//                    destinationViewController?.imsgeStrURL = ""
//                    destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
//                    self.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            }
        } else {
            if indexPath.row < (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) {
                if self.ongoingProjectDetail.project_details?.project_files?.count ?? 0 > 0 {
                    if self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "png" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpg" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpeg" {
                        if let imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                            destinationViewController!.isImage = false
                            destinationViewController?.imsgeStrURL = imgStr
                            destinationViewController?.img = UIImage()
                            self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        }
                    } else {
                        if let imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                            if let url = URL(string: imgStr) {
                                UIApplication.shared.open(url)
                            }
                        }
//                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                        destinationViewController!.isImage = true
//                        destinationViewController?.imsgeStrURL = ""
//                        destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
//                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                }
            } else if self.ongoingProjectDetail.project_details?.bids?.count ?? 0 > 0 {
                if self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?.count ?? 0 > 0 {
                    if self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].type == "png" || self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].type == "jpg" || self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].type == "jpeg" {
                        if let imgStr = self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].file {
                            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                            destinationViewController!.isImage = false
                            destinationViewController?.imsgeStrURL = imgStr
                            destinationViewController?.img = UIImage()
                            self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        }
                    } else {
                        if let imgStr = self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].file {
                            if let url = URL(string: imgStr) {
                                UIApplication.shared.open(url)
                            }
                        }
//                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
//                        destinationViewController!.isImage = true
//                        destinationViewController?.imsgeStrURL = ""
//                        destinationViewController?.img = UIImage(named: "doc") ?? UIImage()
//                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath) as? ProjectFileCollecrtionView
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        if isFrom == "SubTask" {
            cell!.projectImageView.image = nil
            if indexPath.row < (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) {
                cell!.projectTitleLabel.text = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].title ?? ""
                if self.ongoingProjectDetail.project_details?.project_files?.count ?? 0 > 0 {
                    if self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "png" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpg" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpeg" {
                        if var imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
                    } else {
                        if var imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
//                        cell!.projectImageView.image = UIImage(named: "doc")
                    }
                }
            }
        } else {
            cell!.projectImageView.image = nil
            if indexPath.row < (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) {
                cell!.projectTitleLabel.text = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].title ?? ""
                if self.ongoingProjectDetail.project_details?.project_files?.count ?? 0 > 0 {
                    if self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "png" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpg" || self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].type == "jpeg" {
                        if var imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
                    } else {
                        if var imgStr = self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].file {
                            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                            cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                        }
//                        cell!.projectImageView.image = UIImage(named: "doc")
                    }
                }
            } else {
                if self.ongoingProjectDetail.project_details?.bids?.count ?? 0 > 0 {
                    var a = (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)
                    var count = (self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?.count ?? 0) - a
                    cell!.projectTitleLabel.text = self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].title ?? ""
                    if self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?.count ?? 0 > 0 {
                        if self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].type == "png" || self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].type == "jpg" || self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].type == "jpeg" {
                            if var imgStr = self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].file {
                                imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                            }
                        } else {
                            if var imgStr = self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].file {
                                imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                cell!.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed:nil)
                            }
//                            cell!.projectImageView.image = UIImage(named: "doc")
                        }
                    }
                }
            }
        }
        
        
        
        return cell!
    }
}

extension OngoingProjectDetailVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isFrom == "SubTask" {
            if indexPath.row < (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) {
                return CGSize(width: getWidth(title: self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].title ?? ""), height:70)
            }
        } else {
            if indexPath.row < (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0) {
                return CGSize(width: getWidth(title: self.ongoingProjectDetail.project_details?.project_files?[indexPath.row].title ?? ""), height:70)
            } else {
                if self.ongoingProjectDetail.project_details?.bids?.count ?? 0 > 0 {
                    if self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?.count ?? 0 > 0 {
                        return CGSize(width: getWidth(title: self.ongoingProjectDetail.project_details?.bids?[0].bids_documents?[indexPath.row - (self.ongoingProjectDetail.project_details?.project_files?.count ?? 0)].title ?? ""), height:70)
                    }
                }
            }
        }
        return CGSize(width: 150.0, height: 70.0)
    }
}

extension OngoingProjectDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == "Orderlist" {
            return self.arrOfOrderList.count
        } else {
            return self.arrSubTaskList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedType == "Orderlist" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListItemTbllVwCell", for: indexPath) as! OrderListItemTbllVwCell
            cell.venderName.text = "\(self.arrOfOrderList[indexPath.row].vendor_detail?.firstName ?? "") \(self.arrOfOrderList[indexPath.row].vendor_detail?.lastName ?? "")"
            cell.itemLbl.text = "\(self.arrOfOrderList[indexPath.row].TotalItem ?? 0)"
            cell.categoryLbl.text = self.arrOfOrderList[indexPath.row].Cart_Item?[0].productsss?.category ?? ""
//            cell.PriceLbl.text = "$ \(self.arrOfOrderList[indexPath.row].TotalPrice ?? Double(0.0))"
            
            var realAmount = "\(self.arrOfOrderList[indexPath.row].TotalPrice ?? Double(0.0))"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            cell.PriceLbl.text =  "$ \(formattedString ?? "")"
            
//            cell.orderByLbl.text = "\(self.arrOfOrderList[indexPath.row].cart_contractor?.firstName ?? "") \((self.arrOfOrderList[indexPath.row].cart_contractor?.lastName ?? ""))"
            cell.dateLbl.text = DateHelper.convertDateString(dateString: "\(self.arrOfOrderList[indexPath.row].createdAt ?? "2024-04-08T00:00:00.000Z")", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            
            cell.btnComplete.tag = indexPath.row
            cell.btnCancel.tag = indexPath.row
            
            cell.btnComplete.addTarget(self, action: #selector(updateComplete(sender:)), for: .touchUpInside)
            cell.btnCancel.addTarget(self, action: #selector(updateCancel(sender:)), for: .touchUpInside)
            cell.vwStatus.backgroundColor = UIColor.appBtnColorOrange
            cell.disputesStackView.isHidden = false
            cell.disputeStatusText.isHidden = true
            cell.vendorView.isHidden = true
            cell.disputeAdminView.isHidden = true

            if self.arrOfOrderList[indexPath.row].vendorRaisedDispute ?? 0 == 0 && self.arrOfOrderList[indexPath.row].vendorDisputeResolved ?? 0 == 0 {
                cell.vendorView.isHidden = true
            } else {
                if self.arrOfOrderList[indexPath.row].vendorRaisedDispute ?? 0 == 1 {
                    if self.arrOfOrderList[indexPath.row].vendorDisputeResolved ?? 0 == 1 {
                        cell.vendorView.isHidden = false
                        cell.vendorStatusLabel.text = "Vendor dispute resolved by admin"
                    } else {
                        cell.vendorView.isHidden = false
                        cell.vendorStatusLabel.text = "Dispute raised by vendor"
                    }
                }
            }
            if self.arrOfOrderList[indexPath.row].dispute?.count ?? 0 > 0 {
                if self.arrOfOrderList[indexPath.row].dispute?[0].isAdminResolved == 0 {
                    
                    if self.arrOfOrderList[indexPath.row].contractorRaisedDispute == 1 {
                        cell.disputeAdminView.isHidden = false
                        cell.disputeLabel.text = "Dispute raised by you"
                    } else {
                        cell.disputeAdminView.isHidden = true
                    }
                    if self.arrOfOrderList[indexPath.row].isContractor == 1 {
                        if self.arrOfOrderList[indexPath.row].status ?? 0 == 4 {
                            cell.btnCancel.isHidden = true
                            cell.btnComplete.isHidden = false
                            cell.btnComplete.setTitle("Mark As Received", for: .normal)
                        } else if self.arrOfOrderList[indexPath.row].status ?? 0 <= 4 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        } else {
                            cell.btnCancel.isHidden = true
                            cell.btnComplete.isHidden = true
                        }
                        if self.arrOfOrderList[indexPath.row].status == 0 {
                            cell.lblStatus.text = "Requested"
                        } else if self.arrOfOrderList[indexPath.row].status == 1 {
                            cell.lblStatus.text = "Quote Received"
                        } else if self.arrOfOrderList[indexPath.row].status == 2 {
                            cell.lblStatus.text = "Accepted"
                        } else if self.arrOfOrderList[indexPath.row].status == 3 {
                            cell.lblStatus.text = "Rejected"
                        } else if self.arrOfOrderList[indexPath.row].status == 4 {
                            cell.lblStatus.text = "Disputed"
                        } else if self.arrOfOrderList[indexPath.row].status == 5 {
                            cell.lblStatus.text = "Delivered"
                        }
                        
//                         if self.arrOfOrderList[indexPath.row].status == 2 {
//                            cell.btnCancel.isHidden = true
//                            cell.btnComplete.isHidden = true
//                            cell.lblStatus.text = "Accepted"
//                        } else  {
//                            cell.btnCancel.isHidden = true
//                            cell.btnComplete.isHidden = false
//                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                            cell.btnComplete.setTitle("Mark As Received", for: .normal)
//                            cell.lblStatus.text = "Disputed"
//                        }
                    } else {
                        cell.btnStckVw.isHidden = false
                        if self.arrOfOrderList[indexPath.row].status == 0 {
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.isHidden = false
                            cell.btnCancel.setTitle("Cancel", for: .normal)
                            cell.lblStatus.text = "Request Sent"
                        } else if self.arrOfOrderList[indexPath.row].status == 1 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = false
                            cell.btnComplete.setTitle("Accept Order", for: .normal)
                            cell.btnCancel.setTitle("Decline", for: .normal)
                            cell.lblStatus.text = "Quote Received"
                        } else if self.arrOfOrderList[indexPath.row].status == 2 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                            cell.lblStatus.text = "Accepted"
                        } else if self.arrOfOrderList[indexPath.row].status == 3 {
                            cell.btnCancel.isHidden = true
                            cell.btnComplete.isHidden = true
                            cell.lblStatus.text = "Declined"
                        } else if self.arrOfOrderList[indexPath.row].status == 4 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = false
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                            cell.btnComplete.setTitle("Mark As Received", for: .normal)
                            cell.lblStatus.text = "Dispatch"
                        } else if self.arrOfOrderList[indexPath.row].status == 5 {
                            cell.btnCancel.isHidden = false
                            cell.btnComplete.isHidden = true
                            cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                            cell.vwStatus.backgroundColor = UIColor.appColorGreen
                            cell.lblStatus.text = "Delivered"
                        }
                    }
                } else {
                    cell.disputesStackView.isHidden = false
                    cell.disputeStatusText.isHidden = false
                    cell.disputeAdminView.isHidden = false
                    cell.btnStckVw.isHidden = false
                    if self.arrOfOrderList[indexPath.row].status == 0 {
                        cell.btnComplete.isHidden = true
                        cell.btnCancel.isHidden = false
                        cell.btnCancel.setTitle("Cancel", for: .normal)
                        cell.lblStatus.text = "Request Sent"
                    } else if self.arrOfOrderList[indexPath.row].status == 1 {
                        cell.btnCancel.isHidden = false
                        cell.btnComplete.isHidden = false
                        cell.btnComplete.setTitle("Accept Order", for: .normal)
                        cell.btnCancel.setTitle("Decline", for: .normal)
                        cell.lblStatus.text = "Quote Received"
                    } else if self.arrOfOrderList[indexPath.row].status == 2 {
                        cell.btnCancel.isHidden = true //false
                        cell.btnComplete.isHidden = true
                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        cell.lblStatus.text = "Accepted"
                    } else if self.arrOfOrderList[indexPath.row].status == 3 {
                        cell.btnCancel.isHidden = true
                        cell.btnComplete.isHidden = true
                        cell.lblStatus.text = "Declined"
                    } else if self.arrOfOrderList[indexPath.row].status == 4 {
                        cell.btnCancel.isHidden = true //false
                        cell.btnComplete.isHidden = false
                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        cell.btnComplete.setTitle("Mark As Received", for: .normal)
                        cell.lblStatus.text = "Dispatch"
                    } else if self.arrOfOrderList[indexPath.row].status == 5 {
                        cell.btnCancel.isHidden = true //false
                        cell.btnComplete.isHidden = true
                        cell.vwStatus.backgroundColor = UIColor.appColorGreen
                        cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                        cell.lblStatus.text = "Delivered"
                    }
                }
            } else {
                cell.btnStckVw.isHidden = false
                if self.arrOfOrderList[indexPath.row].status == 0 {
                    cell.btnComplete.isHidden = true
                    cell.btnCancel.isHidden = false
                    cell.btnCancel.setTitle("Cancel", for: .normal)
                    cell.lblStatus.text = "Request Sent"
                } else if self.arrOfOrderList[indexPath.row].status == 1 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = false
                    cell.btnComplete.setTitle("Accept Order", for: .normal)
                    cell.btnCancel.setTitle("Decline", for: .normal)
                    cell.lblStatus.text = "Quote Received"
                } else if self.arrOfOrderList[indexPath.row].status == 2 {
                    cell.btnCancel.isHidden = true
                    cell.btnComplete.isHidden = true
           //         cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    cell.lblStatus.text = "Accepted"
                } else if self.arrOfOrderList[indexPath.row].status == 3 {
                    cell.btnCancel.isHidden = true
                    cell.btnComplete.isHidden = true
                    cell.lblStatus.text = "Declined"
                } else if self.arrOfOrderList[indexPath.row].status == 4 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = false
                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    cell.btnComplete.setTitle("Mark As Received", for: .normal)
                    cell.lblStatus.text = "Dispatch"
                } else if self.arrOfOrderList[indexPath.row].status == 5 {
                    cell.btnCancel.isHidden = false
                    cell.btnComplete.isHidden = true
                    cell.vwStatus.backgroundColor = UIColor.appColorGreen
                    cell.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    cell.lblStatus.text = "Delivered"
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTblVwCell", for: indexPath) as! TasksTblVwCell
            cell.lblTitle.text = self.arrSubTaskList[indexPath.row].task ?? ""
            cell.btnEdit.isHidden = false
            cell.btnDelete.isHidden = false
            cell.lblDesc.isHidden = false
            if self.arrSubTaskList[indexPath.row].status == 1 {
                cell.btnCheck.setImage(UIImage(named: "ic_tasks_check"), for: .normal)
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
                cell.btnEdit.isUserInteractionEnabled = false
                cell.btnDelete.isUserInteractionEnabled = false
                cell.btnEdit.isEnabled = false
                cell.btnDelete.isEnabled = false
            } else {
                cell.btnEdit.isUserInteractionEnabled = true
                cell.btnDelete.isUserInteractionEnabled = true
                cell.btnEdit.isEnabled = true
                cell.btnDelete.isEnabled = true
                cell.btnCheck.setImage(UIImage(named: "ic_tasks_uncheck"), for: .normal)
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
            }
            
            cell.btnEdit.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
            cell.btnCheck.tag = indexPath.row
            
            cell.btnEdit.addTarget(self, action: #selector(actionEdit(sender:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(actionDelete(sender:)), for: .touchUpInside)
//            cell.btnCheck.addTarget(self, action: #selector(actionCompleteUncomplete(sender:)), for: .touchUpInside)
            if self.arrSubTaskList[indexPath.row].taskType == 1 {
                cell.btnCheck.isUserInteractionEnabled = false
//                cell.btnCheck.isEnabled = false
            } else {
                cell.btnCheck.isUserInteractionEnabled = true
                cell.btnCheck.isEnabled = true
                cell.btnCheck.addTarget(self, action: #selector(actionCompleteUncomplete(sender:)), for: .touchUpInside)
            }
                
            if self.arrSubTaskList[indexPath.row].taskType == 1 {
                if self.arrSubTaskList[indexPath.row].assignedTo == nil {
                    cell.btnEdit.isHidden = false
                    cell.btnDelete.isHidden = false
                    cell.lblDesc.text = "Total Bids: \(self.arrSubTaskList[indexPath.row].bidsCount ?? 0)"
                } else {
                    cell.btnEdit.isHidden = true
                    cell.btnDelete.isHidden = true
                    cell.lblDesc.text = "Assigned To: \(self.arrSubTaskList[indexPath.row].assignedTo?.firstName ?? "") \(self.arrSubTaskList[indexPath.row].assignedTo?.lastName ?? "")"
                }
            } else {
                cell.lblDesc.isHidden = true
//                cell.btnEdit.isHidden = true
//                cell.btnDelete.isHidden = true
            }
            return cell
        }
        
    }
    
    @objc func updateComplete(sender: UIButton) {
        if self.arrOfOrderList[sender.tag].status == 1 {
            self.updateStatus(cardStatus: 2, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 4 {
            self.updateStatus(cardStatus: 5, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
//            showMessage(with: "Marked as received. \nCongratulations! You have successfully marked this order as received.", theme: .success)
        } else if self.arrOfOrderList[sender.tag].status == 5 {
            let params = ["cartId":"\(self.arrOfOrderList[sender.tag].id  ?? 0)" , "cardStatus":"\(2)"]
            ongoingProejctsCOViewModel.updatecartStatusApi(params) { [self] model in
                showMessage(with: "Marked as received. \nCongratulations! You have successfully marked this order as received.", theme: .success)
            }
        }
    }
    
    @objc func updateCancel(sender: UIButton) {
        if self.arrOfOrderList[sender.tag].status == 0 {
            self.updateStatus(cardStatus: 6, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 1 {
            self.updateStatus(cardStatus: 3, cartId: self.arrOfOrderList[sender.tag].id  ?? 0)
        } else if self.arrOfOrderList[sender.tag].status == 2 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        } else if self.arrOfOrderList[sender.tag].status == 4 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        } else if self.arrOfOrderList[sender.tag].status == 5 {
            //raise dispute
            self.goToRaiseDispute(indx: sender.tag)
        }
    }
    
    func goToRaiseDispute(indx:Int) {
        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "RaiseADisputeVC") as? RaiseADisputeVC
        if self.isFrom == "SubTask" {
            destinationViewController?.projectId = self.ongoingProjectDetail.projectId ?? 0
            destinationViewController?.subTaskId = self.idOfSubTask
        } else {
            destinationViewController?.projectId = projectIdComplete //self.ongoingProjectDetail.projectId ?? 0
            destinationViewController?.subTaskId = 0
        }
        
        destinationViewController?.price = self.arrOfOrderList[indx].TotalPrice ?? Double(0.0)
        destinationViewController?.cartId = self.arrOfOrderList[indx].id ?? 0
        destinationViewController?.completionHandlerGoToOrderListing = { [weak self] in
            self?.fetchOrderList()
        }
        self.present(destinationViewController!, animated: true)
    }
    
    func updateStatus(cardStatus:Int, cartId:Int) {
        let params = ["cartId":"\(cartId)" , "cardStatus":"\(cardStatus)"]
        ongoingProejctsCOViewModel.updatecartStatusApi(params) { [self] model in
            if cardStatus == 6 {
                showMessage(with: "Order cancelled successfully")
            } else if cardStatus == 5 {
                showMessage(with: "Marked as received. \nCongratulations! You have successfully marked this order as received.", theme: .success)
            } else if cardStatus == 2 {
                showMessage(with: "Order accepted successfully.", theme: .success)
            }
            self.orderListTap()
        }
    }
    
    @objc func actionCompleteUncomplete(sender: UIButton) {
        self.idOfTask = ""
        self.popUpType = ""
        self.idOfTask = "\(self.arrSubTaskList[sender.tag].id ?? 0)"
        if self.arrSubTaskList[sender.tag].status ?? 0 == 0 {
            self.btnComplete.setTitle("Complete", for: .normal)
            self.btncancel.setTitle("Cancel", for: .normal)
            self.popUpType = "Complete"
            self.handlePopUp(isHiddenObj: false, isTickHide: true, tickHeight: 0.0, isStackHide: false, stackHeight: 56.0, progressTitle: "Task Complete!", progressDesc: "Are you sure, you want to complete the task?")
            
        } else {
            self.btnComplete.setTitle("Incomplete", for: .normal)
            self.btncancel.setTitle("Cancel", for: .normal)
            self.popUpType = "Incomplete"
            self.handlePopUp(isHiddenObj: false, isTickHide: true, tickHeight: 0.0, isStackHide: false, stackHeight: 56.0, progressTitle: "Task Incomplete!", progressDesc: "Are you sure, you want to incomplete the task?")
        }
    }
    
    @objc func actionDelete(sender: UIButton) {
        self.popUpType = ""
        self.btnComplete.setTitle("Yes", for: .normal)
        self.btncancel.setTitle("No", for: .normal)
        self.popUpType = "Delete"
        self.idOfTask = "\(self.arrSubTaskList[sender.tag].id ?? 0)"
        self.handlePopUp(isHiddenObj: false, isTickHide: true, tickHeight: 0.0, isStackHide: false, stackHeight: 56.0, progressTitle: "Are you sure, you want to delete the task?", progressDesc: "")
    }
    
    @objc func actionEdit(sender: UIButton) {
        let vc = Controllers.addNewTaskVC
        //let vc = Storyboard.project.instantiateViewController(withIdentifier: "AddNewTaskVC") as? AddNewTaskVC
        vc!.projectId = self.ongoingProjectDetail.project_details?.id ?? 0
        vc!.isFrom = "Edit"
        vc!.isEditableFlag = false
        if self.arrSubTaskList[sender.tag].taskType == 1 {
            vc!.selectedTypeTask = "OtherCO"
            vc!.projectIdEditTasks = self.arrSubTaskList[sender.tag].projectId ?? 0
        } else {
            vc!.selectedTypeTask = "Self"
            vc!.projectIdEditTasks = 0
        }
        vc!.taskId = "\(self.arrSubTaskList[sender.tag].id ?? 0)"
        vc!.taskStatus = "\(self.arrSubTaskList[sender.tag].status ?? 0)"
        vc!.task = self.arrSubTaskList[sender.tag].task ?? ""
        vc!.budget = "\(self.arrSubTaskList[sender.tag].budget ?? 0)"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedType == "Orderlist" {
            let destinationVC = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
            destinationVC?.orderListItem = self.arrOfOrderList[indexPath.row]
            if self.isFrom == "SubTask" {
                destinationVC?.projectId = self.ongoingProjectDetail.projectId ?? 0
                destinationVC?.subTaskId = self.idOfSubTask
            } else {
                destinationVC?.projectId = self.ongoingProjectDetail.projectId ?? 0
                destinationVC?.subTaskId = 0
            }
            self.navigationController?.pushViewController(destinationVC!, animated: true)
        } else {
            if self.arrSubTaskList[indexPath.row].taskType == 0 {
                let destinationVC = Storyboard.project.instantiateViewController(withIdentifier: "SelfTaskDetailVC") as! SelfTaskDetailVC
                destinationVC.taskName = self.arrSubTaskList[indexPath.row].task ?? ""
//                destinationVC.taskBudget = "$ \(self.arrSubTaskList[indexPath.row].budget ?? Double(0.0))"
                
                var realAmount = "\(self.arrSubTaskList[indexPath.row].budget ?? Double(0.0))"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                destinationVC.taskBudget =  "$ \(formattedString ?? "")"
                
                destinationVC.taskId = self.arrSubTaskList[indexPath.row].id ?? 0
                if self.arrSubTaskList[indexPath.row].status == 1 {
                    destinationVC.isComplete = true
                } else {
                    destinationVC.isComplete = false
                }
                self.navigationController?.pushViewController(destinationVC, animated: true)
            } else {
                if self.arrSubTaskList[indexPath.row].assignedTo == nil {
                    let destinationVC = Storyboard.project.instantiateViewController(withIdentifier: "InviteOtherContractorsDetailVC") as!  InviteOtherContractorsDetailVC
                    destinationVC.projectId = self.arrSubTaskList[indexPath.row].projectId ?? 0
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                } else {
                    let destinationVC = Storyboard.project.instantiateViewController(withIdentifier: "InviteOtherAssignedContractorsDetailVC") as!  InviteOtherAssignedContractorsDetailVC
                    //destinationVC.taskProjectStatus = self.arrSubTaskList[indexPath.row].taskProject?.status ?? 0
                    destinationVC.projectId = self.arrSubTaskList[indexPath.row].projectId ?? 0
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                }
            }
        }
    }
}
