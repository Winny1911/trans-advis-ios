//
//  PastProjectSubTaskCOVC.swift
//  TA
//
//  Created by Applify on 07/02/22.
//

import UIKit

class PastProjectSubTaskCOVC: BaseViewController {

    @IBOutlet weak var projectFilesLabel: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var subtaskTittleLbl: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMainProject: UIButton!
    @IBOutlet weak var btnOrderlist: UIButton!
    @IBOutlet weak var bottomvwMainProject: UIView!
    @IBOutlet weak var bottomVwOrderlist: UIView!
    @IBOutlet weak var mainVwMainProject: UIView!
    
    @IBOutlet weak var lblContractDoc: UILabel!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBInspectable public lazy var textColor: UIColor = UIColor.black
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ongoingNameLbl: UILabel!
    @IBOutlet weak var ongoingTittleLbl: UILabel!
    @IBOutlet weak var ongoingDescriptionLbl: UILabel!
    @IBOutlet weak var ongoingAmountLbl: UILabel!
    @IBOutlet weak var ongoingStateOnLbl: UILabel!
    @IBOutlet weak var ongoingEndOnLbl: UILabel!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var tblVwTasks: UITableView!
    
    var selectedType = ""
    var pastProejctsCOViewModel:PastProjectCOViewModel = PastProjectCOViewModel()
    var arrofPastProjects: PastProjectCOProjectDetail?
    var arrofPastProjectOrderList = [PastPRojectOrderListCO]()
    var id = 0
    var projectID = 0
    var downloadFileName = ""
    var downloadFileUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        selectedType = "Sub Task"
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnOrderlist, selectedView: bottomvwMainProject, unselectedView1: bottomVwOrderlist)
        
        btnSendMsg.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        btnSendMsg.layer.borderWidth = 1.5
        print(arrofPastProjects)
        self.tblVwTasks.isHidden = true
        self.tblVwTasks.delegate = self
        self.tblVwTasks.dataSource = self
//
        self.collectionVw.delegate = self
        self.collectionVw.dataSource = self
        
        self.reviewTableView.delegate = self
        self.reviewTableView.dataSource = self
        self.subTaskDataFetch()
        self.registerCells()
        
        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(self.downloadContractTapped(_:)))
        self.lblContractDoc.isUserInteractionEnabled = true
        self.lblContractDoc.addGestureRecognizer(downloadTap)
    }
    
    func registerCells() {
        self.collectionVw.register(UINib(nibName: "ProjectFileCollecrtionView", bundle: nil), forCellWithReuseIdentifier: "ProjectFileCollecrtionView")
        self.tblVwTasks.register(UINib.init(nibName: "SubTaskOrderListCO", bundle: nil), forCellReuseIdentifier: "SubTaskOrderListCO")
        self.reviewTableView.register(UINib.init(nibName: "AllReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "AllReviewTableViewCell")
    }
    
    //MARK: Fetcg SubTask Data
    func subTaskDataFetch() {
        var param = [String:Any]()
        param = [
            "id": id
        ]
        pastProejctsCOViewModel.getPastProjectDetailsApi(param) { model in
            self.arrofPastProjects = model?.data?.allProjects
//            self.subtaskTittleLbl.text = "Project Details" //"\(self.arrofPastProjects?.projectDetails?.title ?? "")"
            self.imgVw.sd_setImage(with: URL(string: self.arrofPastProjects?.projectDetails?.userData?.profilePic ?? ""), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            self.ongoingNameLbl.text! = "\(self.arrofPastProjects?.projectDetails?.userData?.firstName ?? "") \(self.arrofPastProjects?.projectDetails?.userData?.lastName ?? "")"
            self.ongoingTittleLbl.text! = "\(self.arrofPastProjects?.projectDetails?.title ?? "")"
            self.ongoingDescriptionLbl.text! = "\(self.arrofPastProjects?.projectDetails?.projectDetailsDescription ?? "")"
            self.ongoingAmountLbl.text = "$\(self.arrofPastProjects?.projectDetails?.price ?? 0)"
            if self.arrofPastProjects?.createdAt != ""{
                self.ongoingStateOnLbl.text = DateHelper.convertDateString(dateString: self.arrofPastProjects?.projectDetails?.createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            if self.arrofPastProjects?.projectDetails?.updatedAt != ""{
                self.ongoingEndOnLbl.text = DateHelper.convertDateString(dateString: self.arrofPastProjects?.projectDetails?.updatedAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            }
            if self.arrofPastProjects?.projectDetails?.projectFiles?.count == 0 || self.arrofPastProjects?.projectDetails?.projectFiles == nil {
                self.projectFilesLabel.text = "Project Files"
            } else {
                self.projectFilesLabel.text = "Project Files (\(self.arrofPastProjects?.projectDetails?.projectFiles?.count ?? 0))"
            }
            if let str = model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "" as? String {
                if (str.contains(".png")) || (str.contains(".jpeg")) || (str.contains(".jpg")) {
                    self.lblContractDoc.text = "\(model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "").png"
                } else {
                    self.lblContractDoc.text = "\(model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "").pdf"
                }
            } else {
                self.lblContractDoc.text = "\(model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? "").pdf"
            }
            self.downloadFileName = model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].title ?? ""
            self.downloadFileUrl = model?.data?.allProjects?.projectDetails?.projectAgreementssss?[0].file ?? ""
            self.collectionVw.reloadData()
        }
    }
    
    
    @IBAction func sentMassageBtnAction(_ sender: UIButton) {
        var id = self.arrofPastProjects?.projectDetails?.userData?.id ?? 0
        let user_id = String("ID_\(id ?? 0)")
        var firstName = self.arrofPastProjects?.projectDetails?.userData?.firstName ?? ""
        var lastName = self.arrofPastProjects?.projectDetails?.userData?.lastName ?? ""
        let user_name = (firstName + " " + lastName)
        let user_img = self.arrofPastProjects?.projectDetails?.userData?.profilePic
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
            print(model)
            self.arrofPastProjectOrderList = model?.data ?? [PastPRojectOrderListCO]()
            self.tblVwTasks.reloadData()
        }
    }
    
    func handleSelection(selectedBtn:UIButton, unselectedButton1:UIButton, selectedView:UIView, unselectedView1:UIView) {
        selectedBtn.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        unselectedButton1.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
//        unselectedButton2.titleLabel?.font = UIFont(name: PoppinsFont.semiBold, size: 14.0)
        
        selectedBtn.setTitleColor(UIColor.appSelectedBlack, for: .normal)
        unselectedButton1.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
//        unselectedButton2.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        
        selectedView.backgroundColor = UIColor.appColorGreen
        unselectedView1.backgroundColor = UIColor.appUnSelectedgrey
//        unselectedView2.backgroundColor = UIColor.appUnSelectedgrey
    }
    
    func handleMainProjectTap() {
        selectedType = "Sub Task"
        self.handleSelection(selectedBtn: btnMainProject, unselectedButton1: btnOrderlist, selectedView: bottomvwMainProject, unselectedView1: bottomVwOrderlist)
        self.subTaskDataFetch()
        self.tblVwTasks.isHidden = true
        self.mainVwMainProject.isHidden = false
    }
    
    func orderListTap(){
        selectedType = "Orderlist"
        self.handleSelection(selectedBtn: btnOrderlist, unselectedButton1: btnMainProject, selectedView: bottomVwOrderlist, unselectedView1: bottomvwMainProject)
        self.orderListDataFetch()
        self.tblVwTasks.isHidden = false
        self.mainVwMainProject.isHidden = false
    }
    
    @IBAction func actionMainProject(_ sender: Any) {
        handleMainProjectTap()
    }
    
    @IBAction func actionOrderlist(_ sender: Any) {
        orderListTap()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func downloadContractTapped(_ sender: UITapGestureRecognizer) {
        if downloadFileUrl != "" && downloadFileName != "" {
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
}

extension PastProjectSubTaskCOVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrofPastProjects?.projectDetails?.projectFiles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFileCollecrtionView", for: indexPath)as? ProjectFileCollecrtionView
        {
            var imgStr = self.arrofPastProjects?.projectDetails?.projectFiles?[0].file ?? ""
            imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            cell.projectImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "Ic_profile"), completed:nil)
            cell.projectTitleLabel.text = self.arrofPastProjects?.projectDetails?.projectFiles?[0].title ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if arrofPastProjects?.projectDetails?.projectFiles?.count ?? 0 > 0 {
                if self.arrofPastProjects?.projectDetails?.projectFiles?[0].type == "png" || self.arrofPastProjects?.projectDetails?.projectFiles?[0].type == "jpg" || self.arrofPastProjects?.projectDetails?.projectFiles?[0].type == "jpeg" {
                    if let imgStr = self.arrofPastProjects?.projectDetails?.projectFiles?[indexPath.row].file {
                        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
                        destinationViewController!.isImage = false
                        destinationViewController?.imsgeStrURL = imgStr
                        destinationViewController?.img = UIImage()
                        self.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                } else {
                    if let imgStr = self.arrofPastProjects?.projectDetails?.projectFiles?[indexPath.row].file {
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
extension PastProjectSubTaskCOVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwTasks{
            return arrofPastProjectOrderList.count
        }
        else{
            return 0
        }
        return 1
    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwTasks{
             let cell = tableView.dequeueReusableCell(withIdentifier: "SubTaskOrderListCO", for: indexPath) as!SubTaskOrderListCO
            let firstName = arrofPastProjectOrderList[indexPath.row].vendorDetail?.firstName ?? ""
            let lastName = arrofPastProjectOrderList[indexPath.row].vendorDetail?.lastName ?? ""
            cell.venderName.text = "\(firstName) \(lastName)"
            cell.itemLbl.text = "\(arrofPastProjectOrderList[indexPath.row].cartItem?.count ?? 0)"
            cell.categoryLbl.text = arrofPastProjectOrderList[indexPath.row].cartItem?[0].productsss?.category ?? ""
//            cell.PriceLbl.text = "$\(arrofPastProjectOrderList[indexPath.row].totalPrice ?? 0)"
            
            var realAmount = "\(arrofPastProjectOrderList[indexPath.row].totalPrice ?? 0)"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal

            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            cell.PriceLbl.text =  "$ \(formattedString ?? "")"
            
            cell.orderByLbl.text = "\(arrofPastProjectOrderList[indexPath.row].cartContractor?.firstName ?? "") \(arrofPastProjectOrderList[indexPath.row].cartContractor?.lastName ?? "")"
            cell.dateLbl.text = DateHelper.convertDateString(dateString: arrofPastProjectOrderList[indexPath.row].createdAt ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            if arrofPastProjectOrderList[indexPath.row].status == 0{
                cell.statusButton.setTitle("  Request Sent  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 1{
                cell.statusButton.setTitle("  Request Send  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 2{
                cell.statusButton.setTitle("  Accpted  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 3{
                cell.statusButton.setTitle("  Declined  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 4{
                cell.statusButton.setTitle("  Dispatch  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 5{
                cell.statusButton.setTitle("  Dispute  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 6{
                cell.statusButton.setTitle("  Mark Completed  ", for: .normal)
            }
            if arrofPastProjectOrderList[indexPath.row].status == 7{
                cell.statusButton.setTitle("  Rase Dispute  ", for: .normal)
            }
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath) as!AllReviewTableViewCell
            cell.descriptionLbl.text = self.arrofPastProjects?.projectDetails?.contractorRating?.overAllFeedback
            
            var firstName = self.arrofPastProjects?.projectDetails?.userData?.firstName ?? ""
            var lastName = self.arrofPastProjects?.projectDetails?.userData?.lastName ?? ""
            cell.nameLbl.text = "\(firstName) \(lastName)"

            if let imgStr = self.arrofPastProjects?.projectDetails?.userData?.profilePic{

                cell.profileImages.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                }

            var rating = self.arrofPastProjects?.projectDetails?.contractorRating?.rating
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

            if self.arrofPastProjects?.projectDetails?.contractorRating?.ratingImages?.count != 0{
                cell.collectionView.reloadData()
            }
            return cell
        }
        

//        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
