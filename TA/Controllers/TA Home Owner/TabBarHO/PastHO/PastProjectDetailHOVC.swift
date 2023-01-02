//
//  PastProjectDetailHOVC.swift
//  TA
//
//  Created by Applify on 01/03/22.
//

import UIKit

class PastProjectDetailHOVC: BaseViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var projectDeliverableLabel: UILabel!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var projectFilesLabel: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var subtaskTittleLbl: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMainProject: UIButton!
    @IBOutlet weak var btnTask: UIButton!
    @IBOutlet weak var bottomvwMainProject: UIView!
    @IBOutlet weak var bottomVwOrderlist: UIView!
    @IBOutlet weak var mainVwMainProject: UIView!
    
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet weak var lblContractDoc: UILabel!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBInspectable public lazy var textColor: UIColor = UIColor.black
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ongoingTittleLbl: UILabel!
    @IBOutlet weak var ongoingDescriptionLbl: UILabel!
    @IBOutlet weak var ongoingAmountLbl: UILabel!
    @IBOutlet weak var ongoingStateOnLbl: UILabel!
    @IBOutlet weak var ongoingEndOnLbl: UILabel!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var tblVwTasks: UITableView!
    
    @IBOutlet weak var emojiVw1: UIView!
    @IBOutlet weak var emojiVw2: UIView!
    @IBOutlet weak var emojiVw3: UIView!
    @IBOutlet weak var emojiVw4: UIView!
    @IBOutlet weak var emojiVw5: UIView!
    
    let pastProjectsHOViewModel: PastProjectVM = PastProjectVM()
    var pastProjectData: pastProjectHODetailData?
    var downloadFileName = ""
    var downloadFileUrl = ""
    var id = 0
    var selectedType = ""
    
    var arrRating = [ContractorRatingHO]()
    var user_name = ""
    var profile_Img = ""
    var user_Id = 0
    var diverableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.setRoundCorners(radius: profileImg.layer.frame.height / 2)
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        buttonView.layer.masksToBounds = false
        buttonView.layer.shadowColor = UIColor.lightGray.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttonView.layer.shadowRadius = 3.0
        buttonView.layer.shadowOpacity = 0.5
        buttonView.layer.shadowOffset = CGSize.zero
        
        selectedType = "Main"
        self.tblVwTasks.isHidden = true
        self.mainDataFetch()
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnTask, selectedView: bottomvwMainProject, unselectedView1: bottomVwOrderlist)
        
        btnSendMsg.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        btnSendMsg.layer.borderWidth = 1.5
        
        self.collectionVw.delegate = self
        self.collectionVw.dataSource = self
        self.tblVwTasks.delegate = self
        self.tblVwTasks.dataSource = self
        self.registerCells()
        
        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(self.downloadContractTapped(_:)))
        self.lblContractDoc.isUserInteractionEnabled = true
        self.lblContractDoc.addGestureRecognizer(downloadTap)
    }
    
    func registerCells() {
        self.collectionVw.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        self.tblVwTasks.register(UINib.init(nibName: "TasksTblVwCell", bundle: nil), forCellReuseIdentifier: "TasksTblVwCell")
    }
    
    @IBAction func actionViewTransaction(_ sender: Any) {
        let destinationViewController = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
        destinationViewController!.isFrom = "HO"
        destinationViewController!.projectId = id
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
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
    func handleSelection(selectedBtn:UIButton, unselectedButton1:UIButton, selectedView:UIView, unselectedView1:UIView) {
        selectedBtn.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton1.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        
        selectedBtn.setTitleColor(UIColor.appSelectedBlack, for: .normal)
        unselectedButton1.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView1.backgroundColor = UIColor.appUnSelectedgrey
    }
    
    func mainDataFetch(){
        let param = ["id":id]
        pastProjectsHOViewModel.getPastProjectDetailsApi(param) { model in
            self.pastProjectData = model?.data?.allProjects
            self.subtaskTittleLbl.text = model?.data?.allProjects?.title ?? ""
            self.lblTitle.text = model?.data?.allProjects?.title ?? ""
            if self.pastProjectData?.projectFiles?.count == 0 || self.pastProjectData?.projectFiles == nil {
                self.projectFilesLabel.text = "Project Files"
            } else {
                self.projectFilesLabel.text = "Project Files (\(self.pastProjectData?.projectFiles?.count ?? 0))"
            }
            if model?.data?.allProjects?.projectAgreement?.count ?? 0 > 0 {
                let countt = model?.data?.allProjects?.projectAgreement?.count ?? 0
                self.lblContractDoc.text = "\(model?.data?.allProjects?.projectAgreement?[countt - 1].title ?? "")"
            }
            
            if model?.data?.allProjects?.contractorProject?.count ?? 0 > 0 {
                if let imgStr = model?.data?.allProjects?.contractorProject?[0].contractorDetails?.profilePic ?? "" as? String{
                    self.profileImg.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed: nil)
                }
                self.lblName.text = "\(model?.data?.allProjects?.contractorProject?[0].contractorDetails?.firstName ?? "") \((model?.data?.allProjects?.contractorProject?[0].contractorDetails?.lastName ?? ""))"
                self.user_name = self.lblName.text ?? ""
                self.user_Id = model?.data?.allProjects?.contractorProject?[0].contractorDetails?.id ?? 0
                self.profile_Img = model?.data?.allProjects?.contractorProject?[0].contractorDetails?.profilePic ?? ""
            }
            self.addressLabel.text = "\(model?.data?.allProjects?.addressLine1 ?? "" )"
            
            if let str = model?.data?.allProjects?.projectAgreement?[0].title ?? "" as? String {
                if (str.contains(".png")) || (str.contains(".jpeg")) || (str.contains(".jpg")) {
                    self.lblContractDoc.text = "\(model?.data?.allProjects?.projectAgreement?[0].title ?? "").png"
                } else {
                    self.lblContractDoc.text = "\(model?.data?.allProjects?.projectAgreement?[0].title ?? "").pdf"
                }
            } else {
                self.lblContractDoc.text = "\(model?.data?.allProjects?.projectAgreement?[0].title ?? "").pdf"
            }
            self.downloadFileName = model?.data?.allProjects?.projectAgreement?[0].title ?? ""
            self.downloadFileUrl = model?.data?.allProjects?.projectAgreement?[0].file ?? ""
//            if model?.data?.allProjects?.addressLine1 ?? "" == model?.data?.allProjects?.addressLine2 ?? "" {
//                self.addressLabel.text = "\(model?.data?.allProjects?.addressLine2 ?? "" ), \(model?.data?.allProjects?.zipCode ?? "")"
//            } else {
//                self.addressLabel.text = "\(model?.data?.allProjects?.addressLine1 ?? "" ), \(model?.data?.allProjects?.city ?? "" ), \(model?.data?.allProjects?.state ?? ""), \(model?.data?.allProjects?.zipCode ?? "")"
//            }
            
            self.projectTypeLabel.text = "\(model?.data?.allProjects?.type ?? "" )"
            
            for i in 0..<(model?.data?.allProjects?.projectDeliverable?.count ?? 0) {
                self.diverableData.append("\(String(describing: model?.data?.allProjects?.projectDeliverable?[i].deliveralble ?? ""))")
            }
            self.diverableData.removingDuplicates()
            self.diverableData.removeDuplicates()
            let diverable = self.diverableData.map{String($0)}.joined(separator: ", ")
            self.projectDeliverableLabel.text = "\(diverable)"
            self.diverableData.removeAll()
            self.emojiVw1.isHidden = false
            self.emojiVw2.isHidden = false
            self.emojiVw3.isHidden = false
            self.emojiVw4.isHidden = false
            self.emojiVw5.isHidden = false
            
            let rating = 0
            let ratingValue = Double(rating)
            if ratingValue == 5 {
                self.emojiVw1.isHidden = true
            } else if ratingValue >= 4 {
                self.emojiVw2.isHidden = true
            } else if ratingValue >= 3 {
                self.emojiVw3.isHidden = true
            } else if ratingValue >= 2 {
                self.emojiVw4.isHidden = true
            } else if ratingValue >= 0 {
                self.emojiVw5.isHidden = true
            }
            
            self.ongoingTittleLbl.text = model?.data?.allProjects?.title ?? ""
            self.ongoingDescriptionLbl.text = model?.data?.allProjects?.allProjectsDescription ?? ""
//            self.ongoingAmountLbl.text = "$\(model?.data?.allProjects?.price ?? 0)"
            
            var realAmount = "\(model?.data?.allProjects?.price ?? 0)"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.ongoingAmountLbl.text =  "$ \(formattedString ?? "")"
            
            if model?.data?.allProjects?.createdAt != ""{
                self.ongoingStateOnLbl.text = DateHelper.convertDateString(dateString: model?.data?.allProjects?.createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            if model?.data?.allProjects?.updatedAt != ""{
                self.ongoingEndOnLbl.text = DateHelper.convertDateString(dateString: model?.data?.allProjects?.updatedAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            self.arrRating.removeAll()
            if (model?.data?.allProjects?.contractorRating != nil) {
                self.arrRating.append((model?.data?.allProjects?.contractorRating)!)
                self.messageLbl.text = self.arrRating[0].overAllFeedback ?? ""
             }
            
            self.collectionVw.reloadData()
        }
    }
    
    func taskDataFetch(){
        self.tblVwTasks.reloadData()
    }
    
    func handleMainProjectTap() {
        
        selectedType = "Main"
        btnSendMsg.isHidden = false
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnTask, selectedView: bottomvwMainProject, unselectedView1: bottomVwOrderlist)
        self.mainDataFetch()
        self.tblVwTasks.isHidden = true
        self.mainVwMainProject.isHidden = false
    }
    
    func orderTaskListTap(){
        selectedType = "Task"
        btnSendMsg.isHidden = true
        self.handleSelection(selectedBtn: btnTask, unselectedButton1: btnMainProject, selectedView: bottomVwOrderlist, unselectedView1: bottomvwMainProject)
        self.taskDataFetch()
        self.tblVwTasks.isHidden = false
        self.mainVwMainProject.isHidden = false
    }
    
    @IBAction func actionMainProject(_ sender: Any) {
        handleMainProjectTap()
    }
    
    @IBAction func actionOrderlist(_ sender: Any) {
        orderTaskListTap()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendMessageBtnAction(_ sender: Any) {
        let id = user_Id
        let user_id = String("ID_\(id ?? 0)")
        let firstName = user_name
//        var lastName = self.newProjectsListing?.contractorProject?[0].contractorDetails?.lastName ?? ""
//        let user_name = (firstName + " " + lastName)
        let user_img = profile_Img
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
}

extension PastProjectDetailHOVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastProjectData?.projectFiles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath)as? ProjectFileCollecrtionView
        {
            var imgStr = self.pastProjectData?.projectFiles?[0].file ?? ""
            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            cell.projectTitleLabel.text = self.pastProjectData?.projectFiles?[0].title ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.pastProjectData?.projectFiles?.count ?? 0 > 0 {
                if self.pastProjectData?.projectFiles?[indexPath.row].type == "png" || self.pastProjectData?.projectFiles?[indexPath.row].type == "jpg" || self.pastProjectData?.projectFiles?[indexPath.row].type == "jpeg" {
                    if let imgStr = self.pastProjectData?.projectFiles?[indexPath.row].file {
                        
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = imgStr
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                        
                    }
                } else {
                    if let imgStr = self.pastProjectData?.projectFiles?[indexPath.row].file {
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

//MARK:- TableViewDelagate and DataSource
extension PastProjectDetailHOVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwTasks{
            return pastProjectData?.mainProjectTasks?.count ?? 0
//            return arrofPastProjectOrderList.count
        }
        else{
            return self.arrRating.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwTasks {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTblVwCell", for: indexPath) as!TasksTblVwCell
                cell.btnDelete.isHidden = true
                cell.btnEdit.isHidden = true
            cell.lblTitle.text = self.pastProjectData?.mainProjectTasks?[indexPath.row].task ?? ""
//            cell.assignLbl.isHidden = true
//            cell.assignLbl.text = "\(self.pastProjectData?.projectFiles?[0].userDetail?.firstName ?? "") \(self.pastProjectData?.projectFiles?[0].userDetail?.lastName ?? "")"
                return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as!AllReviewTableViewCell
            cell.descriptionLbl.text = self.arrRating[indexPath.row].overAllFeedback ?? ""
            
            var firstName = self.pastProjectData?.projectFiles?[0].userDetail?.firstName ?? ""
            var lastName = self.pastProjectData?.projectFiles?[0].userDetail?.lastName ?? ""
            cell.nameLbl.text = "\(firstName) \(lastName)"

            if let imgStr = self.pastProjectData?.projectFiles?[0].userDetail?.profilePic{

                cell.profileImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }

            var rating = self.arrRating[indexPath.row].rating ?? 0
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

            if self.arrRating[indexPath.row].ratingImages?.count != 0{
                cell.collectionView.reloadData()
            }
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
