//
//  ArchiveProjectCOMainTask.swift
//  TA
//
//  Created by Applify on 08/02/22.
//

import UIKit

class ArchiveProjectCOMainTask: BaseViewController {

    //MARK:Outlet
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var attachmentFilesLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
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
    
    var selectedType = ""
    var pastProejctsCOViewModel:PastProjectCOViewModel = PastProjectCOViewModel()
    var arrofArchiveProject: PastProjectCOProjectDetail?
    var arrofArchiveProjectCO: ArchiveProjectAllProjectDetail?
    var arrofArchiveProjectOrderList = [PastPRojectOrderListCO]()
    var arrofArchiveProjectTaskList = [GetTask]()
    var id = 0
    var projectID = 0
    var downloadFileName = ""
    var downloadFileUrl = ""
    var diverableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSendMsg.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        btnSendMsg.layer.borderWidth = 1.5
        bottomVw.addCustomShadow()
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        selectedType = "Main"
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnTasks, unselectedButton2: btnOrderlist, selectedView: bottomvwMainProject, unselectedView1: bottomVwTasks, unselectedView2: bottomVwOrderlist)
        
        self.tblVwTasks.delegate = self
        self.tblVwTasks.dataSource = self
        
        self.reviewTableView.delegate = self
        self.reviewTableView.dataSource = self
        
        self.collVwFiles.delegate = self
        self.collVwFiles.dataSource = self
        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(self.downloadContractTapped(_:)))
        self.lblContract.isUserInteractionEnabled = true
        self.lblContract.addGestureRecognizer(downloadTap)
        self.registerCells()
    }

    @objc func downloadContractTapped(_ sender: UITapGestureRecognizer) {
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
    
    func registerCells() {
        self.collVwFiles.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        self.tblVwTasks.register(UINib.init(nibName: "TasksTblVwCell", bundle: nil), forCellReuseIdentifier: "TasksTblVwCell")
        self.tblVwTasks.register(UINib.init(nibName: "SubTaskOrderListCO", bundle: nil), forCellReuseIdentifier: "SubTaskOrderListCO")
        self.reviewTableView.register(UINib.init(nibName: "AllReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "AllReviewTableViewCell")
    }
    
    func fetchdata(){
        var param = [String:Any]()
        param = [
            "id": id
        ]
        pastProejctsCOViewModel.getPastProjectDetailsApi(param) { model in
            self.arrofArchiveProject = model?.data?.allProjects
            self.lblProjectTitle.text = "\(self.arrofArchiveProject?.projectDetails?.title ?? "")"
            self.lblProjectTitle.text! = "\(self.arrofArchiveProject?.projectDetails?.title ?? "")"
            self.lblProjectDesc.text! = "\(self.arrofArchiveProject?.projectDetails?.projectDetailsDescription ?? "")"
            self.lblContractAmt.text = "$\(self.arrofArchiveProject?.projectDetails?.price ?? 0)"
            
            self.projectTypeLabel.text = model?.data?.allProjects?.projectDetails?.title ?? "" //model?.data?.allProjects?.projectDetails?.type ?? ""
            self.addressLabel.text = "\(model?.data?.allProjects?.projectDetails?.addressLine1 ?? "" )"
            
            if let str = model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "" as? String {
                if (str.contains(".png")) || (str.contains(".jpeg")) || (str.contains(".jpg")) {
                    self.lblContract.text = "\(model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "").png"
                } else {
                    self.lblContract.text = "\(model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "").pdf"
                }
            } else {
                self.lblContract.text = "\(model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "").pdf"
            }
            self.downloadFileName = model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? ""
            self.downloadFileUrl = model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].file ?? ""
//            if model?.data?.allProjects?.projectDetails?.addressLine1 ?? "" == model?.data?.allProjects?.projectDetails?.addressLine2 ?? "" {
//                self.addressLabel.text = "\(model?.data?.allProjects?.projectDetails?.addressLine2 ?? "" ), \(model?.data?.allProjects?.projectDetails?.zipCode ?? "")"
//            } else {
//                self.addressLabel.text = "\(model?.data?.allProjects?.projectDetails?.addressLine1 ?? "" ), \(model?.data?.allProjects?.projectDetails?.city ?? "" ), \(model?.data?.allProjects?.projectDetails?.state ?? ""), \(model?.data?.allProjects?.projectDetails?.zipCode ?? "")"
//            }
            
            for i in 0..<(model?.data?.allProjects?.projectDetails?.projectdeliverabless?.count ?? 0) {
                self.diverableData.append("\(String(describing: model?.data?.allProjects?.projectDetails?.projectdeliverabless?[i].deliveralble ?? ""))")
            }
            var diverable = self.diverableData.map{String($0)}.joined(separator: ", ")
            self.projectDeliverableLabel.text = "\(diverable)"
            self.collVwFiles.reloadData()
            
            if self.arrofArchiveProject?.createdAt != ""{
                self.lblStartDate.text = DateHelper.convertDateString(dateString: self.arrofArchiveProject?.projectDetails?.createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            if self.arrofArchiveProject?.projectDetails?.updatedAt != ""{
                self.lblEndDate.text = DateHelper.convertDateString(dateString: self.arrofArchiveProject?.projectDetails?.updatedAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            if self.arrofArchiveProject?.projectDetails?.projectFiles?.count == 0 || self.arrofArchiveProject?.projectDetails?.projectFiles == nil {
                self.attachmentFilesLabel.text = "Attachment Files"
            } else {
                self.attachmentFilesLabel.text = "Attachment Files (\(self.arrofArchiveProject?.projectDetails?.projectFiles?.count ?? 0))"
            }
            
            self.collVwFiles.reloadData()
        }
        
    }
    
    
    @IBAction func sentMaasageBtnAction(_ sender: UIButton) {
        var id = self.arrofArchiveProject?.projectDetails?.userData?.id ?? 0
        let user_id = String("ID_\(id ?? 0)")
        var firstName = self.arrofArchiveProject?.projectDetails?.userData?.firstName ?? ""
        var lastName = self.arrofArchiveProject?.projectDetails?.userData?.lastName ?? ""
        let user_name = (firstName + " " + lastName)
        let user_img = self.arrofArchiveProject?.projectDetails?.userData?.profilePic
        openChatWindow(user_id: user_id, user_image: user_img, user_name: user_name )
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
    
    func orderListDataFetch(){
        var param = [String:Any]()
        param = [
            "projectId": projectID
        ]
        pastProejctsCOViewModel.getPastProjectOrderListApi(param) { model in
            self.arrofArchiveProjectOrderList = model?.data ?? [PastPRojectOrderListCO]()
            self.tblVwTasks.reloadData()
        }
    }
    
    func taskListDataFetch(){
        var param = [String:Any]()
        param = [
            "projectId": projectID
        ]
        pastProejctsCOViewModel.getPastProjectTaskApi(param) { model in
            self.arrofArchiveProjectTaskList = model?.data?.getTasks ?? [GetTask]()
            self.tblVwTasks.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedType == "Main" {
            self.handleMainProjectTap()
        } else if selectedType == "Task" {
            self.taskTap()
        } else if selectedType == "Orderlist" {
            self.orderListTap()
        }
//        self.fetchOngoingProjectDetail()
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
    
    func handleMainProjectTap() {
        selectedType = "Main"
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnTasks, unselectedButton2: btnOrderlist, selectedView: bottomvwMainProject, unselectedView1: bottomVwTasks, unselectedView2: bottomVwOrderlist)
        self.fetchdata()
        self.tblVwTasks.isHidden = true
        self.mainVwMainProject.isHidden = false
    }
    
    func taskTap() {
        selectedType = "Task"
        self.handleSelection(selectedBtn: btnTasks, unselectedButton1: btnMainProject, unselectedButton2: btnOrderlist, selectedView: bottomVwTasks, unselectedView1: bottomvwMainProject, unselectedView2: bottomVwOrderlist)
        self.taskListDataFetch()
        self.tblVwTasks.isHidden = false
        self.mainVwMainProject.isHidden = false
    }
    
    func orderListTap() {
        selectedType = "Orderlist"
        self.handleSelection(selectedBtn: btnOrderlist, unselectedButton1: btnMainProject, unselectedButton2: btnTasks, selectedView: bottomVwOrderlist, unselectedView1: bottomvwMainProject, unselectedView2: bottomVwTasks)
        self.orderListDataFetch()
        self.tblVwTasks.isHidden = false
        self.mainVwMainProject.isHidden = false
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
}

extension ArchiveProjectCOMainTask: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwTasks{
            if selectedType == "Orderlist"{
                return arrofArchiveProjectOrderList.count
            }else{
                return arrofArchiveProjectTaskList.count
            }
        }
        else{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwTasks{
            if selectedType ==  "Orderlist"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubTaskOrderListCO", for: indexPath) as!SubTaskOrderListCO
               let firstName = arrofArchiveProjectOrderList[indexPath.row].vendorDetail?.firstName ?? ""
               let lastName = arrofArchiveProjectOrderList[indexPath.row].vendorDetail?.lastName ?? ""
               cell.venderName.text = "\(firstName) \(lastName)"
               cell.itemLbl.text = "\(arrofArchiveProjectOrderList[indexPath.row].cartItem?.count ?? 0)"
               cell.categoryLbl.text = arrofArchiveProjectOrderList[indexPath.row].cartItem?[0].productsss?.category ?? ""
//               cell.PriceLbl.text = "$\(arrofArchiveProjectOrderList[indexPath.row].totalPrice ?? 0)"
                
                var realAmount = "\(arrofArchiveProjectOrderList[indexPath.row].totalPrice ?? 0)"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal

                let amount = Double(realAmount)
                let formattedString = formatter.string(for: amount)
                cell.PriceLbl.text =  "$ \(formattedString ?? "")"
                
               cell.orderByLbl.text = "\(arrofArchiveProjectOrderList[indexPath.row].cartContractor?.firstName ?? "") \(arrofArchiveProjectOrderList[indexPath.row].cartContractor?.lastName ?? "")"
               cell.dateLbl.text = DateHelper.convertDateString(dateString: arrofArchiveProjectOrderList[indexPath.row].createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
               if arrofArchiveProjectOrderList[indexPath.row].status == 0{
                   cell.statusButton.setTitle("  Request Sent  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 1{
                   cell.statusButton.setTitle("  Request Send  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 2{
                   cell.statusButton.setTitle("  Accpted  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 3{
                   cell.statusButton.setTitle("  Declined  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 4{
                   cell.statusButton.setTitle("  Dispatch  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 5{
                   cell.statusButton.setTitle("  Delivered  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 6{
                   cell.statusButton.setTitle("  Mark Completed  ", for: .normal)
               }
               if arrofArchiveProjectOrderList[indexPath.row].status == 7{
                   cell.statusButton.setTitle("  Rase Dispute  ", for: .normal)
               }
                cell.btnStack.isHidden = true
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTblVwCell", for: indexPath) as!TasksTblVwCell
                cell.btnDelete.isHidden = true
                cell.btnEdit.isHidden = true
                cell.lblTitle.text = "Project Details"//arrofArchiveProjectTaskList[indexPath.row].task ?? ""
                if arrofArchiveProjectTaskList[indexPath.row].assignedTo == nil {
                    cell.lblDesc.isHidden = true
                } else {
                    cell.lblDesc.isHidden = false
                    cell.lblDesc.text = "\(arrofArchiveProjectTaskList[indexPath.row].assignedTo?.firstName ?? "") \(arrofArchiveProjectTaskList[indexPath.row].assignedTo?.lastName ?? "")"
                }
                return cell
            }
           
//            return cell
        }
        else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as? AllReviewTableViewCell
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as!AllReviewTableViewCell
                cell.descriptionLbl.text = self.arrofArchiveProjectCO?.projectDetails?.contractorRating?.overAllFeedback
                
                var firstName = self.arrofArchiveProjectCO?.projectDetails?.userData?.firstName ?? ""
                var lastName = self.arrofArchiveProjectCO?.projectDetails?.userData?.lastName ?? ""
                cell.nameLbl.text = "\(firstName) \(lastName)"

                if let imgStr = self.arrofArchiveProjectCO?.projectDetails?.userData?.profilePic{

                    cell.profileImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                    }

                var rating = self.arrofArchiveProjectCO?.projectDetails?.contractorRating?.rating
                    var ratingValue = Double(rating ?? 0)
                    print("rating--\(ratingValue)")

                    if ratingValue == 5 {
                        cell.emojiVw1.isHidden = true
                    }
                    else if ratingValue == 4 {

                        cell.emojiVw2.isHidden = true
                    }
                    else if ratingValue == 3{

                        cell.emojiVw3.isHidden = true

                    }
                    else if ratingValue == 2{

                        cell.emojiVw4.isHidden = true
                    }
                    else if ratingValue == 0{

                        cell.emojiVw5.isHidden = true
                    }

                if self.arrofArchiveProjectCO?.projectDetails?.contractorRating?.ratingImages?.count != 0{
                    cell.collectionView.reloadData()
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedType == "Task"{
            return 100
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedType == "Task"{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 23, y: 0, width: view.frame.size.width, height: 18)
            myLabel.font = UIFont.boldSystemFont(ofSize: 18)
            myLabel.textColor = UIColor.black
            myLabel.textAlignment = .left
            myLabel.text = "Completed Tasks"
            headerView.addSubview(myLabel)
            return headerView
           }
        else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedType == "Task"{
            return 18
        }
        else{
            return 0
        }
    }
}

extension ArchiveProjectCOMainTask:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrofArchiveProject?.projectDetails?.projectFiles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath)as? ProjectFileCollecrtionView
        {
            var imgStr = self.arrofArchiveProject?.projectDetails?.projectFiles?[0].file ?? ""
            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            cell.projectTitleLabel.text = self.arrofArchiveProject?.projectDetails?.projectFiles?[0].title ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if arrofArchiveProject?.projectDetails?.projectFiles?.count ?? 0 > 0 {
                if self.arrofArchiveProject?.projectDetails?.projectFiles?[0].type == "png" || self.arrofArchiveProject?.projectDetails?.projectFiles?[0].type == "jpg" || self.arrofArchiveProject?.projectDetails?.projectFiles?[0].type == "jpeg" {
                    if let imgStr = self.arrofArchiveProject?.projectDetails?.projectFiles?[indexPath.row].file {
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = imgStr
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                } else {
                    if let imgStr = self.arrofArchiveProject?.projectDetails?.projectFiles?[indexPath.row].file {
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
    }
}
