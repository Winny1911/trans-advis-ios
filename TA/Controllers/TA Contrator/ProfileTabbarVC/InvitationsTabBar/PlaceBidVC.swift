//
//  PlaceBidVC.swift
//  TA
//
//  Created by Applify  on 01/01/22.
//

import UIKit
import GBFloatingTextField
import Photos
import SDWebImage
import MobileCoreServices
import UniformTypeIdentifiers
import WebKit
import PDFKit

class PlaceBidVC: BaseViewController {

    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var lblSuccess: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var viewInfo: UIView!
//    @IBOutlet weak var projectImageWidth: NSLayoutConstraint!
//    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var imgInvitation: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var collVwFiles: UICollectionView!
    @IBOutlet weak var btnAddFiles: UIButton!
    @IBOutlet weak var txtVwDetail: GBFloatingTextView!
    @IBOutlet weak var txtEndDate: FloatingLabelInput!
    @IBOutlet weak var txtStartDate: FloatingLabelInput!
    @IBOutlet weak var txtFldamountReceivable: FloatingLabelInput!
    @IBOutlet weak var txtFldBidAmount: FloatingLabelInput!
    @IBOutlet weak var vwBidetail: UIView!
    
    @IBOutlet weak var btnSucces: UIButton!
    @IBOutlet weak var successFulView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var viewPDF: UIView!
    @IBOutlet weak var webviewForm: WKWebView!
    
    
    //MARK : New fields form
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var txtHomeOwner: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerB: FloatingLabelInput!
    @IBOutlet weak var txtStreetAddress: FloatingLabelInput!
    @IBOutlet weak var txtMailingAddress: FloatingLabelInput!
    @IBOutlet weak var txtCellPhone: FloatingLabelInput!
    @IBOutlet weak var txtEmail: FloatingLabelInput!
    @IBOutlet weak var txtHOA: FloatingLabelInput!
    @IBOutlet weak var txtInsurance: FloatingLabelInput!
    @IBOutlet weak var txtClaimNumber: FloatingLabelInput!
    @IBOutlet weak var txtMainDwellingRoof: FloatingLabelInput!
    @IBOutlet weak var txtDetachedGarage: FloatingLabelInput!
    @IBOutlet weak var txtShed: FloatingLabelInput!
    @IBOutlet weak var txtDecking: FloatingLabelInput!
    @IBOutlet weak var txtFlatRoof: FloatingLabelInput!
    @IBOutlet weak var txtTotal: FloatingLabelInput!
    @IBOutlet weak var txtDeducible: FloatingLabelInput!
    @IBOutlet weak var txtFe: FloatingLabelInput!
    @IBOutlet weak var txtRetail: FloatingLabelInput!
    @IBOutlet weak var txtBe: FloatingLabelInput!
    @IBOutlet weak var txtBrand: FloatingLabelInput!
    @IBOutlet weak var txtStyle: FloatingLabelInput!
    @IBOutlet weak var txtColor: FloatingLabelInput!
    @IBOutlet weak var txtPermaBoot: FloatingLabelInput!
    @IBOutlet weak var txtPermaBootB: FloatingLabelInput!
    @IBOutlet weak var txtPipeJack: FloatingLabelInput!
    @IBOutlet weak var txtPipeJackB: FloatingLabelInput!
    @IBOutlet weak var txtColorB: FloatingLabelInput!
    @IBOutlet weak var txtMaterialLocation: FloatingLabelInput!
    @IBOutlet weak var txtDumpsterLocation: FloatingLabelInput!
    @IBOutlet weak var txtSpecialInstructions: FloatingLabelInput!
    @IBOutlet weak var txtNotes: FloatingLabelInput!
    @IBOutlet weak var txtRoofing: FloatingLabelInput!
    @IBOutlet weak var txtRoofingPrice: FloatingLabelInput!
    @IBOutlet weak var txtDebrisRemoval: FloatingLabelInput!
    @IBOutlet weak var txtDebrisRemovalPrice: FloatingLabelInput!
    @IBOutlet weak var txtOverheadProfit: FloatingLabelInput!
    @IBOutlet weak var txtOverheadProfitPrice: FloatingLabelInput!
    @IBOutlet weak var txtCodeUpgrades: FloatingLabelInput!
    @IBOutlet weak var txtCodeUpgradesPrice: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerBA: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerBB: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerBADate: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerBBDate: FloatingLabelInput!
    @IBOutlet weak var txtAegcRepresentative: FloatingLabelInput!
    @IBOutlet weak var txtAegcRepresentativeDate: FloatingLabelInput!
    
    //MARK : Checkbox
    @IBOutlet weak var ckbPaymentTermsFinance: UIButton!
    @IBOutlet weak var ckbPaymentTermsDeductible: UIButton!
    @IBOutlet weak var ckbInsFullyApproved: UIButton!
    @IBOutlet weak var ckbInsPartialApproved: UIButton!
    @IBOutlet weak var ckbRetail: UIButton!
    @IBOutlet weak var ckbRetailDepreciation: UIButton!
    @IBOutlet weak var ckbWhiteDripEdge: UIButton!
    @IBOutlet weak var ckbBrown: UIButton!
    @IBOutlet weak var ckbAlmond: UIButton!
    @IBOutlet weak var ckbBlack: UIButton!
    @IBOutlet weak var ckbBrownB: UIButton!
    @IBOutlet weak var ckbAegc: UIButton!
    @IBOutlet weak var ckbIko: UIButton!
    @IBOutlet weak var ckbOc: UIButton!
    @IBOutlet weak var ckbOCb: UIButton!
    @IBOutlet weak var ckbGaf: UIButton!
    @IBOutlet weak var ckbAirVent: UIButton!
    @IBOutlet weak var ckbBlackB: UIButton!
    @IBOutlet weak var ckbBrownC: UIButton!
    @IBOutlet weak var ckbWhite: UIButton!
    @IBOutlet weak var ckbCopper: UIButton!
    @IBOutlet weak var ckbBlackC: UIButton!
    @IBOutlet weak var ckbBrownD: UIButton!
    @IBOutlet weak var ckbWhiteB: UIButton!
    @IBOutlet weak var ckbGrey: UIButton!
    @IBOutlet weak var ckbRemoveReplace: UIButton!
    @IBOutlet weak var ckbDetachReset: UIButton!
    @IBOutlet weak var ckbRemoveCoverHoles: UIButton!
    @IBOutlet weak var ckbRemoveReplaceB: UIButton!
    @IBOutlet weak var ckbDetachResetB: UIButton!
    @IBOutlet weak var ckbSatelliteDish: UIButton!
    @IBOutlet weak var ckbAntenna: UIButton!
    @IBOutlet weak var ckbDetach: UIButton!
    @IBOutlet weak var ckbDetachDispose: UIButton!
    @IBOutlet weak var ckbPermit: UIButton!
    @IBOutlet weak var ckbCutInstallRidgVent: UIButton!
    
    var wkWeb : WKWebView!
    var projectTitle = String()
    var projectDesc = String()
    var projectId = 0
    var imageUrl = String()
    let placeBidViewModel: PlaceBidViewModel = PlaceBidViewModel()
    var listFieds = [String]()
    var cellReuseIdentifier = "cellReuse"
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    var arrOfFiles = [[String : Any]]()
    var arrOfImages = [UIImage]()
    var arrOfImagesNames = [String]()
    private var userImage: String?
    var docURL:URL?
    var fullViewImge = [String]()
    var imageNameArray = [String]()
    var bidId = 0
    let manageBidDetailViewModel: ManageBidDetailViewModel = ManageBidDetailViewModel()
    var arrOfFilesFetchedFromServer = [[String:Any]]()
    var arrOfFilesManually = [[String:Any]]()
    var bidFilesArray : [BidsDocumentsDetails]?
    var amount = ""
    
    var completionHandlerGoToInvitationDetailScreenFromPlaceBid: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.arrOfFilesFetchedFromServer.removeAll()
        //self.arrOfFilesManually.removeAll()
        //viewInfo.isHidden = true
        //lblInfo.isHidden = true
        //viewInfo.addCustomShadow()
        self.lblTitle.text = self.projectTitle
        //        self.lblDesc.text = self.projectDesc
        //        self.projectImageWidth.constant = 0.0
        //        if self.imageUrl != "" {
        //            projectImageWidth.constant = 65.0
        //            imgInvitation.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "doc"), completed:nil)
        //        } else {
        //            projectImageWidth.constant = 0.0
        //        }
        //        addCustomButtonOnTextField()
        //        btnSucces.isHidden = true
        //        successFulView.setRoundCorners(radius: 14.0)
        //        successFulView.isHidden = true
        //        blackView.isHidden = true
        //
        //        self.collVwFiles.register(UINib(nibName: "PlaceBidCollVwCell", bundle: nil), forCellWithReuseIdentifier: "PlaceBidCollVwCell")
        //
        //        self.collVwFiles.delegate = self
        //        self.collVwFiles.dataSource = self
        //
        //        self.txtFldBidAmount.delegate = self
        //        self.txtFldamountReceivable.delegate = self
        //        self.txtEndDate.delegate = self
        //        self.txtStartDate.delegate = self
        //        self.txtVwDetail.setLeftPadding(14.0)
        //        self.setFloatingTextVw()
        //
        //        self.btnAddFiles.setRoundCorners(radius: 8.0)
        //        txtFldBidAmount.setLeftPadding(14)
        //        txtFldamountReceivable.setLeftPadding(14)
        //        txtStartDate.setLeftPadding(14)
        //        txtEndDate.setLeftPadding(14)
        //
        //        vwBidetail.addCustomShadow()
        //        bottomVw.addCustomShadow()
        //
        //        self.showStartDatePicker()
        //        self.showEndDatePicker()
        //        if self.bidId != 0 {
        //            self.btnSubmit.setTitle("Update Bid", for: .normal)
        //            self.lblTopTitle.text = "Edit Bid"
        //            self.fetchBidDetails()
        //        }
    
//        self.openUrlWebview(url: "http://ta123-webapp.s3-website-us-east-1.amazonaws.com/contractors/invitations")
        //self.displayPdf()
        buildFieldsForm()
    }
    
    private func buildFieldsForm() {
        datePickerView.datePickerMode = .date
    }
    
//    func handelDatePicker()
//    {
//        let dateFormatter = DateFormatter()
//        dateTextView.text = dateFormatter.string(from: datePickerView.date)
//    }
//    
    private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
        if let resourceUrl = URL(string: "https://c8szizga07.execute-api.us-east-1.amazonaws.com/default/delta") {
            return PDFDocument(url: resourceUrl)
        }
        
        return nil
    }
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        let pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin]
        pdfView.autoScales = true
        
        return pdfView
    }
    
    private func displayPdf() {
        let pdfView = self.createPdfView(withFrame: self.viewPDF.bounds)
        
        if let pdfDocument = self.createPdfDocument(forFileName: "heaps") {
            self.viewPDF.addSubview(pdfView)
            pdfView.document = pdfDocument
        }
    }
    
    var arrOfImgStrings = [String]()

    func fetchBidDetails() {
        self.arrOfFilesFetchedFromServer.removeAll()
        self.arrOfFilesManually.removeAll()
        let params = ["id": self.bidId]
        manageBidDetailViewModel.getManageBidsDetailApi(params) { model in
//            self.projectImageWidth.constant = 0.0
//            if model?.data?.project_details?.project_files?.count ?? 0 > 0 {
//                self.projectImageWidth.constant = 65.0
//                self.imgInvitation.sd_setImage(with: URL(string: model?.data?.project_details?.project_files?[0].file ?? ""), placeholderImage: UIImage(named: "doc"), completed:nil)
//            } else {
//                self.projectImageWidth.constant = 0.0
//            }
            self.lblTitle.text = model?.data?.project_details?.title ?? ""
//            self.lblDesc.text = model?.data?.project_details?.description ?? ""
            self.arrOfImgStrings.removeAll()
            self.txtFldBidAmount.text = "$ \(model?.data?.bidAmount ?? "0.0")"
            self.txtFldamountReceivable.text = "$ \(model?.data?.amountRecievable ?? "0.0")"
            self.txtStartDate.text = DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            self.txtEndDate.text = DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            self.txtVwDetail.text = model?.data?.description ?? ""

            self.txtFldBidAmount.resetFloatingLable()
            self.txtFldamountReceivable.resetFloatingLable()
            self.txtStartDate.resetFloatingLable()
            self.txtEndDate.resetFloatingLable()
            self.setFloatingTextVw()

            let userImgVw = UIImageView()
            if model?.data?.bids_documents?.count ?? 0 > 0 {
                self.fullViewImge.removeAll()
                for i in 0 ..< (model?.data?.bids_documents!.count)! {
                    self.arrOfImgStrings.append(model?.data?.bids_documents?[i].file ?? "")
                    let fileStr = model?.data?.bids_documents?[i].file ?? ""
                    self.fullViewImge.append(fileStr)
                    self.imageNameArray.append("\(model?.data?.bids_documents?[i].title ?? "")")
                    userImgVw.image = nil
                    if fileStr.contains(".png") || fileStr.contains(".jpg") || fileStr.contains(".jpeg") {
                        userImgVw.sd_setImage(with: URL(string: fileStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                        let imageStr = model?.data?.bids_documents?[i].file
                        let strOfImage = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/bidUploads/", with: "")
                        let dict = ["image": "\(strOfImage ?? "")", "name":model?.data?.bids_documents?[i].title]
                        self.arrOfFiles.append(dict as [String : Any])
                        let titleImage = model?.data?.bids_documents?[i].title ?? ""
                        if titleImage.contains(".jpg") || titleImage.contains(".jpeg") || titleImage.contains(".png") {
                            self.arrOfImagesNames.append("\(model?.data?.bids_documents?[i].title ?? "")")
                        } else {
                            self.arrOfImagesNames.append("\(model?.data?.bids_documents?[i].title ?? "").png")
                        }
                        self.arrOfImages.append(userImgVw.image!)
                    } else {
                        let imageStr = model?.data?.bids_documents?[i].file
                        let strOfDoc = imageStr?.replacingOccurrences(of: "https://transadvisor-dev.s3.amazonaws.com/bidUploads/", with: "")
                        let dict = ["image": "\(strOfDoc ?? "")", "name":model?.data?.bids_documents?[i].title]
                        self.arrOfFiles.append(dict as [String : Any])
                        let titleDoc = model?.data?.bids_documents?[i].title ?? ""
                        if titleDoc.contains(".pdf") || titleDoc.contains(".doc") {
                            self.arrOfImagesNames.append("\(model?.data?.bids_documents?[i].title ?? "")")
                        } else {
                            self.arrOfImagesNames.append("\(model?.data?.bids_documents?[i].title ?? "").doc")
                        }
                        self.arrOfImages.append(UIImage(named: "doc")!)
                    }
                }
                self.arrOfFilesFetchedFromServer = self.arrOfFiles
                self.bidFilesArray = model?.data?.bids_documents
                self.collVwFiles.reloadData()
            }
        }
    }

    func addCustomButtonOnTextField() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_tootltip_hover"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(txtFldamountReceivable.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.infoBtnTapped), for: .touchUpInside)
        txtFldamountReceivable.rightView = button
        txtFldamountReceivable.rightViewMode = .always
    }

    @objc func infoBtnTapped() {
        if self.viewInfo.isHidden {
            viewInfo.isHidden = false
            lblInfo.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.viewInfo.isHidden = true
                self.lblInfo.isHidden = true
            }
        } else {
            viewInfo.isHidden = true
            lblInfo.isHidden = true
        }
    }

    func setFloatingTextVw() {
        self.txtVwDetail.isFloatingLabel = true
        self.txtVwDetail.placeholder = " Terms / Description"
        self.txtVwDetail.placeholderColor = UIColor.appBtnColorGrey
        self.txtVwDetail.topPlaceholderColor = UIColor.appFloatText
        self.txtVwDetail.selectedColor = UIColor.appFloatText
        self.txtVwDetail.setLeftPadding(14.0)
    }

    func imageSendAPI(imageData: Data, fileName:String) {
        placeBidViewModel.addInvitationImageApi(keyToUploadData: "file", fileNames: "\(fileName)", dataToUpload: imageData, param: [:]) { response in
            print(response!)
            if let a = response?["data"] as? [String: Any] {
                let url = a["url"] as? String
                self.fullViewImge.append(url ?? "")
            }
            self.imageNameArray.append(fileName)
            self.setModelData(response: response!)
        }
    }

    func docSendAPI(docLocalUrl:URL, fileName:String) {
        if self.docURL != nil {
            placeBidViewModel.addInvitationDocApi(localFileUrl: docLocalUrl, keyToUploadData: "file", fileNames: "\(fileName)") { response in
                print(response!)
                if let a = response?["data"] as? [String: Any] {
                    let url = a["url"] as? String
                    self.fullViewImge.append(url ?? "")
                }
                self.imageNameArray.append(fileName)
                self.setModelData(response: response!)
            }
        }
    }

    func setModelData(response: [String:Any]) {
        let dataDict = response["data"] as! NSDictionary
        let randomName = "\(randomString())"
        let dict = ["image":dataDict["name"] as! String, "name": randomName ]
        self.arrOfFiles.append(dict)
        self.arrOfFilesManually.append(dict)
        self.collVwFiles.reloadData()
    }

    @IBAction func actionHideSuccessfulView(_ sender: Any) {
        self.btnSucces.isHidden = true
        self.successFulView.isHidden = true
        self.blackView.isHidden = true
        self.navigationController?.popViewController(animated: true)
        self.completionHandlerGoToInvitationDetailScreenFromPlaceBid?()
    }
    
    //MARK: checkbox action
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.transform = .identity
        sender.titleLabel?.text = " ⃞"
    }

    //MARK: ACTION BACK
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: ACTION ADD FILES
    @IBAction func actionAddFiles(_ sender: Any) {
        var count = arrOfImages.count
        let limit  = 149
        if count < limit {
            handleCameraOptions()
        }else{
            print("limit is 150")
        }
       // handleCameraOptions()
    }

    //MARK: ACTION SUBMIT
    @IBAction func actionSubmit(_ sender: Any) {
        let bidAmount2 = self.txtFldBidAmount.text?.trimmed ?? ""
        let bidAmount3 = bidAmount2.replacingOccurrences(of: "$ ", with: "")
        let bidAmount = bidAmount3.replacingOccurrences(of: ",", with: "")
        let amountReceivable = self.txtFldamountReceivable.text?.trimmed ?? ""
        let startDate = self.txtStartDate.text?.trimmed ?? ""
        let endDate = self.txtEndDate.text?.trimmed ?? ""
        let description = self.txtVwDetail.text ?? ""

        let dateFormatter = DateFormatter()
        let requiredDateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd MMMM yyyy"
        requiredDateFormatter.dateFormat = "yyyy-MM-dd"

        let dateStart = dateFormatter.date(from: startDate)
        let dateEnd = dateFormatter.date(from: endDate)

        let stringStartDate = requiredDateFormatter.string(from: dateStart ?? Date())
        let stringEndDate = requiredDateFormatter.string(from: dateEnd ?? Date())
        var mediaArrCount = 0
        if self.bidId == 0 {
            mediaArrCount = self.arrOfFiles.count
        } else {
            mediaArrCount = self.arrOfFilesManually.count + self.arrOfFiles.count
        }
        let placeBidModel  = PlaceBidModel(homeOwnerFirst: txtHomeOwner.text ?? "",
                                           homeOwnerSecond: txtHomeOwnerB.text ?? "",
                                           streetAddress: txtStreetAddress.text ?? "",
                                           mailingAddress: txtMailingAddress.text ?? "",
                                           cellPhone: txtCellPhone.text ?? "",
                                           email: txtEmail.text ?? "",
                                           hoa: txtHOA.text ?? "",
                                           permit: String(ckbPermit.isSelected),
                                           insurance: txtInsurance.text ?? "",
                                           claimNeumber: txtClaimNumber.text ?? "",
                                           insFullyApproved: String(ckbInsFullyApproved.isSelected),
                                           insPartialApproved: String(ckbInsPartialApproved.isSelected),
                                           retail: String(ckbRetail.isSelected),
                                           retailWDepreciation: String(ckbRetailDepreciation.isSelected),
                                           mainDwellingRoof: txtMainDwellingRoof.text ?? "",
                                           shedSQ: txtShed.text ?? "",
                                           decking: txtDecking.text ?? "",
                                           flatRoofSQ: txtFlatRoof.text ?? "",
                                           total: txtTotal.text ?? "",
                                           deducible: txtDeducible.text ?? "",
                                           fe: txtFe.text  ?? "",
                                           retailB: txtRetail.text ?? "",
                                           be: txtBe.text  ?? "",
                                           brand: txtBrand.text ?? "",
                                           style: txtStyle.text ?? "",
                                           color: txtColor.text ?? "",
                                           white: String(ckbWhiteDripEdge.isSelected),
                                           brown: String(ckbBrown.isSelected),
                                           aegc: String(ckbAegc.isSelected),
                                           iko: String(ckbIko.isSelected),
                                           oc: String(ckbOc.isSelected),
                                           ocB: String(ckbOCb.isSelected),
                                           gaf: String(ckbGaf.isSelected),
                                           airVent: String(ckbAirVent.isSelected),
                                           cutInstallRidgeVent: String(ckbCutInstallRidgVent.isSelected),
                                           black: String(ckbBlack.isSelected),
                                           brownB: String(ckbBrownB.isSelected),
                                           whiteB: String(ckbWhite.isSelected),
                                           copper: String(ckbCopper.isSelected),
                                           blackB: String(ckbBlackB.isSelected),
                                           brownC: String(ckbBrownC.isSelected),
                                           grey: String(ckbGrey.isSelected),
                                           whiteC: String(ckbWhiteB.isSelected),
                                           removeReplace: String(ckbRemoveReplace.isSelected),
                                           deatchReset: String(ckbDetachReset.isSelected),
                                           removeCoverHoles: String(ckbRemoveCoverHoles.isSelected),
                                           permaBoot: txtPermaBoot.text ?? "",
                                           permaBootB: txtPermaBootB.text ?? "",
                                           pipeJack: txtPipeJack.text ?? "",
                                           pipeJackB: txtPipeJackB.text ?? "",
                                           removeReplaceB: String(ckbRemoveReplaceB.isSelected),
                                           deatchResetB: String(ckbDetachResetB.isSelected),
                                           colorB: txtColorB.text ?? "",
                                           satelliteDish: String(ckbSatelliteDish.isSelected),
                                           antenna: String(ckbAntenna.isSelected),
                                           detachOnly: String(ckbDetach.isSelected),
                                           detachDispose: String(ckbDetachDispose.isSelected),
                                           materialLocation: txtMaterialLocation.text ?? "",
                                           dumpsterLocation: txtDumpsterLocation.text ?? "",
                                           specialInstructions: txtSpecialInstructions.text ?? "",
                                           notes: txtNotes.text ?? "",
                                           roofing: txtRoofing.text ?? "",
                                           roofingPrice: txtRoofingPrice.text  ?? "",
                                           debrisRemoval: txtDebrisRemoval.text ?? "",
                                           overheadProfit: txtOverheadProfit.text ?? "",
                                           codeUpgrades: txtCodeUpgrades.text ?? "",
                                           paymentTermsDeductible: String(ckbPaymentTermsDeductible.isSelected),
                                           paymantTermsFinance: String(ckbPaymentTermsFinance.isSelected),
                                           homeOwner: txtHomeOwner.text ?? "",
                                           homeOwnerDate: txtHomeOwnerBADate.text ?? "",
                                           homeOwnerBA: txtHomeOwnerBB.text ?? "",
                                           homeOwnerDateBA: txtHomeOwnerBBDate.text ?? "",
                                           aegcRepresentative: txtAegcRepresentative.text ?? "",
                                           aegcRepresentativeBA: txtAegcRepresentativeDate.text ?? "")
        placeBidViewModel.model = placeBidModel
        placeBidViewModel.validatePlaceBidnModel {[weak self] (success, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                if self?.bidId == 0 {
                    let params = ["projectId": "\(self?.projectId ?? 0)", "amount": bidAmount, "startDate": stringStartDate, "endDate": stringEndDate, "description": description, "ProjectFiles": self?.arrOfFiles.toJSONString() ?? [].toJSONString()] as [String : Any]
                    placeBidViewModel.submitBidApi(params) { response in
                        self?.handleSuccessApi()
                    }
                } else {
                    let params = ["id": "\(self?.bidId ?? 0)", "amount": bidAmount, "startDate": stringStartDate, "endDate": stringEndDate, "description": description, "ProjectFiles": self?.arrOfFilesManually.toJSONString() ?? [].toJSONString()] as [String : Any]
                    placeBidViewModel.updateBidApi(params) { response in
                        self?.handleSuccessApi()
                    }
                }
            }
            else {
                if let errorMsg = strongSelf.placeBidViewModel.error {
                    showMessage(with: errorMsg)
                }
            }
        }
    }

    func handleSuccessApi() {
        if self.bidId == 0 {
            self.lblSuccess.text! = "Bid Placed successfully"
        } else {
            self.lblSuccess.text! = "Bid Updated successfully"
        }
        self.successFulView.isHidden = false
        self.btnSucces.isHidden = false
        self.blackView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.successFulView.isHidden = true
            self.btnSucces.isHidden = true
            self.blackView.isHidden = true
            self.navigationController?.popViewController(animated: true)
            self.completionHandlerGoToInvitationDetailScreenFromPlaceBid?()
        }
    }
}

extension PlaceBidVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.txtVwDetail {
            if textView.textColor == UIColor.init(named: "#B2B2B2") {
                textView.text = nil
                textView.textColor = UIColor.appColorText
            }
        }
    }
}

//MARK: SHOW DATE PICKER
extension PlaceBidVC {
    private func showStartDatePicker(){
        //Formate Date
        startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }
        startDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtStartDate.inputAccessoryView = toolbar
        txtStartDate.inputView = startDatePicker
    }

    @objc private func doneStartDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        txtStartDate.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }

    private func showEndDatePicker(){
        //Formate Date
        endDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            endDatePicker.preferredDatePickerStyle = .wheels
        }
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtEndDate.inputAccessoryView = toolbar
        txtEndDate.inputView = endDatePicker
    }

    @objc private func doneEndDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        txtEndDate.text = formatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }

    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

extension PlaceBidVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtStartDate ||  textField == txtEndDate{
            return false
        } else if textField == txtFldBidAmount {
            if (textField.text?.isEmpty ?? true), string == "0" {
                return false
            } else if textField.text?.count ?? 0 > 9 && !string.isEmpty {
                return false
            }

            let str = "\(textField.text!)\(string)"
            let str2 = str.replacingOccurrences(of: "$ ", with: "")
//            textField.text! = "$ \(str2)"

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0

            if let groupingSeparator = formatter.groupingSeparator {

                    if string == groupingSeparator {
                        return true
                    }
                if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                            var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                            if string.isEmpty { // pressed Backspace key
                                totalTextWithoutGroupingSeparators.removeLast()
                            }
                    let totalTextWithoutGroupingSeparator = totalTextWithoutGroupingSeparators.replacingOccurrences(of: "$ ", with: "")
                            if let numberWithoutGroupingSeparator = formatter.number(from: totalTextWithoutGroupingSeparator),
                                let formattedText = formatter.string(from: numberWithoutGroupingSeparator) {

                                textField.text = formattedText
                                amount = formattedText
                                textField.text = "$ " + amount
                                txtFldBidAmount.resetFloatingLable()
                                return false
                            }

                        }
            }

            txtFldBidAmount.resetFloatingLable()
            if str == "$ " {
                textField.text! = ""
                txtFldBidAmount.resetFloatingLable()
                return true
            }
            if str2.count > 0 {
                if string == "" {
                    if str2.count == 1 {
                        textField.text! = ""
                        txtFldBidAmount.resetFloatingLable()
                    }
                    return true
                }
                return false
            } else {
                return true
            }

        } else if textField == txtFldamountReceivable {
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFldBidAmount {
            if txtFldBidAmount.text != "" || txtFldBidAmount.text?.count ?? 0 > 0 {
                let bidAmounts = txtFldBidAmount.text?.replacingOccurrences(of: "$ ", with: "")
                let bidAmount = bidAmounts?.replacingOccurrences(of: ",", with: "")
                if let bidAmntStr = bidAmount {
                    let bidAmnt = Double(bidAmntStr) ?? Double(0.0)
                    let receiveableAmount = (Double(90.0) * bidAmnt) / Double(100.0)

                    var realAmount = "\(receiveableAmount)"
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.decimal

                    let amount = Double(realAmount)
                    let formattedString = formatter.string(for: amount)
//                    lblAMount.text =  "$ \(formattedString ?? "")"

                    self.txtFldamountReceivable.text = "$ \(formattedString ?? "")"
                    self.txtFldamountReceivable.resetFloatingLable()
                }
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldamountReceivable {
            return false
        } else {
            return true
        }
    }
}

extension PlaceBidVC: UICollectionViewDelegateFlowLayout{
    func getWidth(title:String) -> CGFloat{
        let font = UIFont(name: PoppinsFont.medium, size: 14)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = title
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size.width + 25 + 45
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(title: self.arrOfImagesNames[indexPath.row]), height:72)
    }
}

extension PlaceBidVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullViewImge.count //arrOfImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceBidCollVwCell", for: indexPath) as!  PlaceBidCollVwCell
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        cell.innerVw.setRoundCorners(radius: 5.0)
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(deleteFile(sender:)), for: .touchUpInside)
        cell.projectImage.setRoundCorners(radius: 5.0)
        cell.projectImage.image = self.arrOfImages[indexPath.row]
        cell.projectTitle.text = self.arrOfImagesNames[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let a = self.fullViewImge[indexPath.row]
        let last4 = String(a.suffix(4))
        if last4 == ".png" || last4 == ".jpg" || last4 == "jpeg" {
            let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC
            destinationViewController!.isImage = false
            destinationViewController?.imsgeStrURL = self.fullViewImge[indexPath.row]
            destinationViewController?.img = UIImage()
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
        } else {
            if let url = URL(string: self.fullViewImge[indexPath.row]) {
                UIApplication.shared.open(url)
            }
        }
    }

//    @objc func deleteFile(sender: UIButton) {
//        self.arrOfFiles.remove(at: sender.tag)
//        self.arrOfImages.remove(at: sender.tag)
//        self.arrOfImagesNames.remove(at: sender.tag)
//        self.collVwFiles.reloadData()
//    }

    @objc func deleteFile(sender: UIButton) {
        if self.bidId != 0 {
            if self.arrOfFilesFetchedFromServer.count > 0 {
                if sender.tag < self.arrOfFilesFetchedFromServer.count {
                    self.deleteProjectFile(fileId: self.bidFilesArray?[sender.tag].id ?? 0, indexOfFile: sender.tag)
                } else {
                    self.arrOfFilesManually.remove(at: (sender.tag - self.arrOfFilesFetchedFromServer.count))
                    handleManualDeleteFile(indexOfFile:sender.tag)
                }
            } else {
                self.arrOfFilesManually.remove(at: (sender.tag - self.arrOfFilesFetchedFromServer.count))
                handleManualDeleteFile(indexOfFile:sender.tag)
            }
        } else {
            self.arrOfFilesManually.remove(at: (sender.tag - self.arrOfFilesFetchedFromServer.count))
            handleManualDeleteFile(indexOfFile:sender.tag)
        }
    }

    func handleManualDeleteFile(indexOfFile:Int) {
        self.arrOfImages.remove(at: indexOfFile)
        self.arrOfImagesNames.remove(at: indexOfFile)
        self.arrOfFiles.remove(at: indexOfFile)
        self.collVwFiles.reloadData()
    }

    func deleteProjectFile(fileId:Int, indexOfFile:Int) {
        let param = ["id":fileId]
        manageBidDetailViewModel.deleteBidFileApi(param) { response in
            self.bidFilesArray?.remove(at: indexOfFile)
            self.arrOfFilesFetchedFromServer.remove(at: indexOfFile)
            self.handleManualDeleteFile(indexOfFile: indexOfFile)
        }
    }

}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PlaceBidVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func handleCameraOptions() {

        self.view.endEditing(true)

        let actionSheetController: UIAlertController = UIAlertController(title: UIFunction.getLocalizationString(text: "Project File"), message: nil, preferredStyle: .actionSheet)

        let actionCamera: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Take photo"), style: .default) { action -> Void in

            self.choosePhotoFromCameraAction()
        }

        let actionGallery: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose from gallery"), style: .default) { action -> Void in

            self.choosePhotoFromGalleryAction()
        }

        let actionDocuments: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose Docs"), style: .default) { action -> Void in

            self.chooseFromDocs()
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Cancel"), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }

        actionCamera.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionGallery.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionDocuments.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")

        if userImage == nil || userImage?.count == 0
        {
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(actionDocuments)
            actionSheetController.addAction(cancelAction)
        }
        else
        {
         //   actionSheetController.addAction(removePhoto)
        //    actionSheetController.addAction(viewPhoto)
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(actionDocuments)
            actionSheetController.addAction(cancelAction)
        }

        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 20, y: self.view.bounds.size.height - 150, width: 1.0, height: 1.0)
        self.present(actionSheetController, animated: true, completion: nil)

    }

    // MARK:-
    // MARK:- -------- Permissions ---------
    func choosePhotoFromCameraAction()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            self.perform(#selector(showCamera), with: nil, afterDelay: 0.3)
        }
        else
        {
            let alertController: UIAlertController = UIAlertController(title: "Error", message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
            }

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func showCamera()
    {
        let status  = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized
        {
            DispatchQueue.main.async {
                self.openCamera()
            }
        }
        else if status == .notDetermined
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (status) in
                if status == true
                {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                    self.showAlertOfPermissionsNotAvailable()
                    }
                }
            })
        }
        else if status == .restricted || status == .denied
        {
            DispatchQueue.main.async {
            self.showAlertOfPermissionsNotAvailable()
            }
        }
    }

    func openCamera()
    {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }

    func chooseFromDocs() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData),String(kUTTypeSpreadsheet),String(kUTTypeImage), String(kUTTypeRTF), String(kUTTypePDF)], in: .import)

            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = true
            }
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            present(importMenu, animated: true)
    }

    func choosePhotoFromGalleryAction()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        if(status == .notDetermined)
        {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized
                {
                    DispatchQueue.main.async {
                        self.openGallery()
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                    self.showAlertOfPermissionsNotAvailable()
                    }
                }
            })

        }
        else if (status == .authorized)
        {
            DispatchQueue.main.async {
                self.openGallery()
            }
        }
        else if (status == .restricted || status == .denied)
        {
            DispatchQueue.main.async {
            self.showAlertOfPermissionsNotAvailable()
            }
        }
    }

    // MARK:-
    // MARK:- Open Gallery
    func openGallery()
    {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    // MARK:-
    // MARK:- Show Alert With No Permissions Message
    func showAlertOfPermissionsNotAvailable()
    {
        let message = UIFunction.getLocalizationString(text: "Camera permission not available")
        let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let cancel_title = UIFunction.getLocalizationString(text: "Cancel")
        let cancelAction = UIAlertAction(title: cancel_title, style: .destructive) { (_) -> Void in
        }

        let settings_title = UIFunction.getLocalizationString(text: "Settings title")
        let settingsAction = UIAlertAction(title: settings_title, style: .default) { (_) -> Void in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK:-
    // MARK:- -------- Image Picker Delegates --------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        picker.dismiss(animated: true, completion: nil)
        let imageName: String = UIFunction.getRandomImageName()
        let fileManager = FileManager.default
        do
        {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(imageName)
            if  UIDevice.current.userInterfaceIdiom == .phone {
                if let imageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage).jpegData(compressionQuality: 0.0)
                {
                    try imageData.write(to: fileURL)
                }
            } else {
                if let imageData = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 0.0) {
                    try imageData.write(to: fileURL)
                }
            }
            userImage = NSString(format:"%@",imageName as CVarArg) as String
            self.arrOfImagesNames.append("\(randomString()).png")
            self.showImageInUserPhotoImageView(fileName: "\(randomString()).png")
        }
        catch
        {}
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK:-
    // MARK:- Show Image in User Image View
    func showImageInUserPhotoImageView(fileName:String)
    {
        self.view.endEditing(true)
        guard let userImage = userImage else
        {
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
        }
        else if ((userImage as String).hasPrefix("http") || (userImage as String).hasPrefix("https"))
        {
            // image from url
        }
        else
        {
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(userImage)
                let image    = UIImage(contentsOfFile: imageURL.path)
                self.arrOfImages.append(image!)
                let imageData = image?.jpegData(compressionQuality: 0.8)
                self.imageSendAPI(imageData: imageData!, fileName: fileName)
            }
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension PlaceBidVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.docURL = myURL
        self.arrOfImagesNames.append("\(randomString()).pdf")
        self.arrOfImages.append(UIImage(named: "doc")!)
        self.docSendAPI(docLocalUrl: myURL, fileName: "\(randomString()).pdf")
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension PlaceBidVC {
    func openUrlWebview(url: String){
        let configuration = WKWebViewConfiguration()
        
        let script = WKUserScript(
            source: "window.localStorage.clear();",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        configuration.userContentController.addUserScript(script)
        
        let localStorageData: [String: Any] = [
            "session": "1675918359863",
            "rememberme": 1,
            "access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDI5LCJlbWFpbCI6InZhbmVzc2EucGluYUBzd2VsbGl0c29sdXRpb25zLmNvbS5iciIsInR5cGUiOiJDTyIsImRldmljZVRva2VuIjoiTk9UT0tFTiIsImRldmljZVR5cGUiOiJXRUIiLCJkZXZpY2VJZGVudGlmaWVyIjoiMjY5ODEyIiwiaWF0IjoxNjc1OTE0NTM0fQ.SmgXWH9TodsK1wbkd89a47rzERmliW5M2xCA-dsKDew",
            "isLoggedIn":"true",
            "loggedInUserId":"429",
            "userProfileStatus": "CO",
            "profileRoute": "/contractors/invitations/place-bids"
        ]
        
        if JSONSerialization.isValidJSONObject(localStorageData),
           let data = try? JSONSerialization.data(withJSONObject: localStorageData, options: []),
           let value = String(data: data, encoding: .utf8) {
            let script = WKUserScript(
                source: "Object.assign(window.localStorage, \(value));",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
            
            configuration.userContentController.addUserScript(script)
        }
        
        let cgRectWK = CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: self.view.frame.height-180)
        
        wkWeb = WKWebView(frame: cgRectWK, configuration: configuration)
        wkWeb.navigationDelegate = self
        wkWeb.uiDelegate = self
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        wkWeb.load(myRequest)
        wkWeb.navigationDelegate = self
        viewPDF.addSubview(wkWeb)
    }
    
    func createCookies(host: String, parameters: [String: Any]) -> [HTTPCookie] {
        parameters.compactMap { (name, value) in
            HTTPCookie(properties: [
                .domain: host,
                .path: "/",
                .name: name,
                .value: "\(value)",
                .secure: "TRUE",
                .expires: Date(timeIntervalSinceNow: 31556952),
            ])
        }
    }
}

extension PlaceBidVC: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = "localStorage.getItem(\"access_token\")"
        let scriptDiv = "document.getElementsByClassName('ng-star-inserted')[0].style.visibility = 'hidden';"
        self.wkWeb.evaluateJavaScript(scriptDiv) { (result, error) in
            if let result = result {
                print("result div = \(result)")
            }
        }
        self.wkWeb.evaluateJavaScript(script) { (token, error) in
            if let error = error {
                print ("localStorage.getitem('token') failed due to \(error)")
                assertionFailure()
            }
            print("token = \(token)")
        }
    }
    
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    //        let req = NSMutableURLRequest(url: navigationAction.request.url!)
    //
    //        for cookie in cookiesWKwebview {
    //            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    //            let values = HTTPCookie.requestHeaderFields(with: cookiesWKwebview)
    //            req.allHTTPHeaderFields = values
    //            decisionHandler(.allow)
    //            webView.load(req as URLRequest)
    //        }
    //    }
}
