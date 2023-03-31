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
    //@IBOutlet weak var imgInvitation: UIImageView!
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
    
    @IBOutlet weak var viewDrawSign: UIView!
    
    @IBOutlet weak var btnSucces: UIButton!
    @IBOutlet weak var successFulView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var imgDrawSignature: UIImageView!
    
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
    @IBOutlet weak var txtCodeUpgrades: FloatingLabelInput!
    @IBOutlet weak var txtCodeUpgradesPrice: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerBA: FloatingLabelInput!
    @IBOutlet weak var txtHomeOwnerBB: FloatingLabelInput!
    @IBOutlet weak var txtAegcRepresentative: FloatingLabelInput!
    @IBOutlet weak var datePickerAEGCDate: UIDatePicker!
    @IBOutlet weak var datePickerHomeOwnerBBDate: UIDatePicker!
    @IBOutlet weak var datePickerHomeOwnerBADate: UIDatePicker!
    
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
    //    @IBOutlet weak var collectionProjectFiles: UICollectionView!
    
    var wkWeb : WKWebView!
    var projectTitle = String()
    var projectDesc = String()
    var projectId: Int = 0
    var imageUrl = String()
    let placeBidViewModel: PlaceBidViewModel = PlaceBidViewModel()
    var listFieds = [String]()
    var cellReuseIdentifier = "cellReuse"
    
    var fetchHomeOwner = String()
    var fetchHomeOwnerB = String()
    var fetchStreetAddress = String()
    var fetchCellPhone = String()
    var fetchMailingAddress = String()
    var fetchEmail = String()
    
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
    var manageBidDetailViewModel: ManageBidDetailViewModel = ManageBidDetailViewModel()
    var arrOfFilesFetchedFromServer = [[String:Any]]()
    var arrOfFilesManually = [[String:Any]]()
    var bidFilesArray : [BidsDocumentsDetails]?
    var manageBids: ManageBidsResponseDetailsV2?
    var amount = ""
    var base64StringSignature = String()
    
    var completionHandlerGoToInvitationDetailScreenFromPlaceBid: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgDrawSignature.isHidden = true
        txtFldBidAmount.backgroundColor = .red
        //        collectionProjectFiles.delegate = self
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
        addCustomButtonOnTextField()
        btnSucces.isHidden = true
        successFulView.setRoundCorners(radius: 14.0)
        successFulView.isHidden = true
        blackView.isHidden = true
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
        if self.bidId != 0 {
            self.btnSubmit.setTitle("Update Bid", for: .normal)
            self.lblTopTitle.text = "Edit Bid"
            self.fetchBidDetails()
        }
        
        buildFieldsForm()
        self.fetchFirstItems()
    }
    
    private func fetchFirstItems() {
        self.txtHomeOwner.text = self.fetchHomeOwner
        self.txtHomeOwnerB.text = self.fetchHomeOwnerB
        self.txtStreetAddress.text = self.fetchStreetAddress
        self.txtCellPhone.text = self.fetchCellPhone
        self.txtMailingAddress.text = self.fetchMailingAddress
        self.txtEmail.text = self.fetchEmail
        
        self.txtHomeOwner.resetFloatingLable()
        self.txtHomeOwnerB.resetFloatingLable()
        self.txtStreetAddress.resetFloatingLable()
        self.txtCellPhone.resetFloatingLable()
        self.txtMailingAddress.resetFloatingLable()
        self.txtEmail.resetFloatingLable()
    }
    
    private func resetFloatingLabel(){
        DispatchQueue.main.async {
            self.txtHOA.resetFloatingLable()
            self.txtInsurance.resetFloatingLable()
            self.txtClaimNumber.resetFloatingLable()
            self.txtMainDwellingRoof.resetFloatingLable()
            self.txtShed.resetFloatingLable()
            self.txtDecking.resetFloatingLable()
            self.txtFlatRoof.resetFloatingLable()
            self.txtTotal.resetFloatingLable()
            self.txtDeducible.resetFloatingLable()
            self.txtFe.resetFloatingLable()
            self.txtRetail.resetFloatingLable()
            self.txtBe.resetFloatingLable()
            self.txtBrand.resetFloatingLable()
            self.txtStyle.resetFloatingLable()
            self.txtColor.resetFloatingLable()
            self.txtDetachedGarage.resetFloatingLable()
            self.txtPermaBoot.resetFloatingLable()
            self.txtPermaBootB.resetFloatingLable()
            self.txtPipeJack.resetFloatingLable()
            self.txtPipeJackB.resetFloatingLable()
            self.txtColorB.resetFloatingLable()
            self.txtMaterialLocation.resetFloatingLable()
            self.txtDumpsterLocation.resetFloatingLable()
            self.txtSpecialInstructions.resetFloatingLable()
            self.txtNotes.resetFloatingLable()
            self.txtRoofing.resetFloatingLable()
            self.txtRoofingPrice.resetFloatingLable()
            self.txtDebrisRemoval.resetFloatingLable()
            self.txtDebrisRemovalPrice.resetFloatingLable()
            self.txtOverheadProfit.resetFloatingLable()
            self.txtCodeUpgrades.resetFloatingLable()
            self.txtHomeOwnerBB.resetFloatingLable()
            self.txtAegcRepresentative.resetFloatingLable()
            self.txtCodeUpgradesPrice.resetFloatingLable()
        }
    }
    
    func buildParams(model: PlaceBidModel) -> [String : Any]{
        let params = [
            "date": model.date,
            
            //"startDate": date,
            //"endDate": date,
            //"amount": amount,
            
            "homeOwner1":  model.homeOwnerFirst,
            "homeOwner2": model.homeOwnerSecond,
            "streetAddress": model.streetAddress,
            "mailingAddress": model.mailingAddress,
            "cellPhone": model.cellPhone,
            "email": model.email,
            "hoa": model.hoa,
            "permit": model.permit,
            "insurance": model.insurance,
            "claimNumber": model.claimNumber,
            "insFullyApproved": model.insFullyApproved,
            "insPartialApproved": model.insPartialApproved,
            "retail1": model.retail,
            "retailDepreciation": model.retailWDepreciation,
            "mainDwellingRoofSQ": model.mainDwellingRoof,
            "detachedGarageSQ": model.detachedGarageSQ,
            "shedSQ": model.shedSQ,
            "decking": model.decking,
            "flatRoofSQ": model.flatRoofSQ,
            "totalSQ": model.totalSQ,
            "total": model.total,
            "deducible": model.deducible,
            "fe": model.fe,
            "retail2": model.retailB,
            "be": model.be,
            "brand": model.brand,
            "style": model.style,
            "color1": model.color,
            "dripEdgeF55": placeBidViewModel.setDripEdgeF55(checkedWhite: self.ckbWhiteDripEdge.isSelected,
                                                            checkedBrown: self.ckbBrown.isSelected,
                                                            checkedAlmond: self.ckbAlmond.isSelected),
            "counterFlashing": placeBidViewModel.setCounterFlashing(checkedBlack: self.ckbBlack.isSelected,
                                                                    checkedBrown: self.ckbBrownB.isSelected),
            "syntheticUnderlayment": placeBidViewModel.setSyntheticUnderlayment(checkedAegc: self.ckbAegc.isSelected,
                                                                                checkedIko: self.ckbIko.isSelected,
                                                                                checkedOc: self.ckbOc.isSelected),
            "ridgeVent": placeBidViewModel.setRidgeVent(checkedOc: self.ckbOCb.isSelected,
                                                        checkedGaf: self.ckbGaf.isSelected,
                                                        checkedAirVent: self.ckbAirVent.isSelected),
            "cutInstallRidgeVent": model.cutInstallRidgeVent,
            "chimneyFlashing": placeBidViewModel.setChimneyFlashing(checkedBlack: self.ckbBlackC.isSelected,
                                                                    checkedBrown: self.ckbBrownB.isSelected,
                                                                    checkedWhite: self.ckbWhite.isSelected,
                                                                    checkedCopper: self.ckbCopper.isSelected),
            "sprayPaint": placeBidViewModel.setSprayPaint(checkedBlack: self.ckbBlackC.isSelected,
                                                          checkedBrown: self.ckbBlackC.isSelected,
                                                          checkedWhite: self.ckbWhiteB.isSelected,
                                                          checkedGrey: self.ckbGrey.isSelected),
            "turtleVents": placeBidViewModel.setTurtleVents(checkedRemoveReplace: self.ckbRemoveReplace.isSelected, checkedDetachReset: self.ckbDetachReset.isSelected, checkedRemoveCoverHoles: ckbRemoveCoverHoles.isSelected),
            "permaBoot123": model.permaBoot,
            "permaBoot34": model.permaBootB,
            "pipeJack123": model.pipeJack,
            "pipeJack34": model.pipeJackB,
            "atticFan": placeBidViewModel.setAtticFan(checkedRemoveReplace: self.ckbRemoveReplaceB.isSelected,
                                                      checkedDetachReset: self.ckbDetachResetB.isSelected),
            "color2": model.colorB,
            "satelliteDish": model.satelliteDish,
            "antenna": model.antenna,
            "lightningRod": placeBidViewModel.setLightningRod(checkedDetachOnly: self.ckbDetach.isSelected,
                                                              checkedDetachDispose: self.ckbDetachDispose.isSelected),
            "materialLocation": model.materialLocation,
            "dumpsterLocation": model.dumpsterLocation,
            "specialInstructions": model.specialInstructions,
            "notes": model.notes,
            "roofing1": model.roofing,
            "roofing2": model.roofingPrice,
            "debrisRemoval1": model.debrisRemoval,
            "debrisRemoval2": model.debrisRemovalPrice,
            "overheadProfit1": model.overheadProfit,
            "overheadProfit2": "",
            "codeUpgrades": model.codeUpgrades,
            "paymentTerms1": model.paymentTermsFinance,
            "paymentTerms2": model.paymentTermsDeductible,
            "homeOwnerSign1": self.base64StringSignature,
            "homeOwnerSignDate1": model.dateHomeOwner1,
            "homeOwnerSignDate2": model.dateHomeOwner2,
            "aegcRepresentativeDate": model.dateAEGC,
            "ProjectFiles" : "",
            "homeOwnerInitial1": model.homeOwnerFirst,
            "homeOwnerInitial2": model.homeOwnerSecond] as [String : Any]
        return addParamsID(params: params)
    }
    
    
    private func buildFieldsForm() {
        txtCellPhone.delegate = self
        if bidId == 0 {
            datePickerView.datePickerMode = .date
            datePickerAEGCDate.datePickerMode = .date
            datePickerHomeOwnerBADate.datePickerMode = .date
            datePickerHomeOwnerBBDate.datePickerMode = .date
        }
    }
    
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
    
    
    
    //    func fetchBidDetails() {
    //        self.arrOfFilesFetchedFromServer.removeAll()
    //        self.arrOfFilesManually.removeAll()
    //        let params = ["id": self.bidId]
    //        manageBidDetailViewModel.getManageBidsDetailApi(params) { model in
    //            self.fillWithData(model: model)
    //            //            self.projectImageWidth.constant = 0.0
    //            //            if model?.data?.project_details?.project_files?.count ?? 0 > 0 {
    //            //                self.projectImageWidth.constant = 65.0
    //            //                self.imgInvitation.sd_setImage(with: URL(string: model?.data?.project_details?.project_files?[0].file ?? ""), placeholderImage: UIImage(named: "doc"), completed:nil)
    //            //            } else {
    //            //                self.projectImageWidth.constant = 0.0
    //            //            }
    //            self.lblTitle.text = model?.data?.project_details?.title ?? ""
    //            //            self.lblDesc.text = model?.data?.project_details?.description ?? ""
    
    //            self.txtFldBidAmount.text = "$ \(model?.data?.bidAmount ?? "0.0")"
    //            self.txtFldamountReceivable.text = "$ \(model?.data?.amountRecievable ?? "0.0")"
    //            self.txtStartDate.text = DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
    //            self.txtEndDate.text = DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
    //            self.txtVwDetail.text = model?.data?.description ?? ""
    //
    //            self.txtFldBidAmount.resetFloatingLable()
    //            self.txtFldamountReceivable.resetFloatingLable()
    //            self.txtStartDate.resetFloatingLable()
    //            self.txtEndDate.resetFloatingLable()
    //            self.setFloatingTextVw()
    var dateString = Date()
    var aegcDateString = Date()
    var homeOwnerBADateString = Date()
    var homeOwnerBBDateString = Date()
    
    func dateFormtterBid(model: ManageBidsResponseDetailsV2?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        DispatchQueue.main.async {
            self.aegcDateString = dateFormatter.date(from: model?.aegcRepresentativeDate ?? "")!
            self.dateString = dateFormatter.date(from: model?.date ?? "")!
            self.homeOwnerBADateString = dateFormatter.date(from: model?.homeOwnerSignDate1 ?? "")!
            self.homeOwnerBBDateString = dateFormatter.date(from: model?.homeOwnerSignDate2 ?? "")!
            
            self.datePickerAEGCDate.setDate(self.aegcDateString, animated: false)
            self.datePickerHomeOwnerBADate.setDate(self.homeOwnerBADateString, animated: false)
            self.datePickerHomeOwnerBBDate.setDate(self.homeOwnerBBDateString, animated: false)
            self.datePickerView.setDate(self.dateString, animated: false)
        }
    }
    
    func fetchBidDetails() {
        let params = ["id": self.bidId]
        manageBidDetailViewModel.getManageBidsDetailApiV2(params) { model in
            if model?.data?.project_details?.project_files?.count ?? 0 > 0 {
                //                self.imgInvitation.sd_setImage(with: URL(string: model?.data?.project_details?.project_files?[0].file ?? ""), placeholderImage: UIImage(named: "doc"), completed:nil)
            }
            var arrOfImgStrings = [String]()
            let userImgVw = UIImageView()
            if model?.data?.bids_documents?.count ?? 0 > 0 {
                self.fullViewImge.removeAll()
                for i in 0 ..< (model?.data?.bids_documents!.count)! {
                    arrOfImgStrings.append(model?.data?.bids_documents?[i].file ?? "")
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
            DispatchQueue.main.async {
                self.dateFormtterBid(model: model?.data)
            }
            
            self.manageBids = model?.data
            self.lblTopTitle.text = "Bid Details" //model?.data?.project_details?.title ?? ""
            //self.bidStatus = model?.data?.bidStatus ?? 0
            self.projectId = model?.data?.project_details?.id ?? 0
            self.projectTitle = model?.data?.project_details?.title ?? ""
            //self.btnRecallBid.isUserInteractionEnabled = true
            
            self.lblTitle.text = model?.data?.project_details?.title ?? ""
            
            //self.lblDesc.text = model?.data?.description ?? ""
            //self.addressLabel.text = "\(model?.data?.project_details?.addressLine1 ?? "" )"
            //            if model?.data?.project_details?.addressLine1 ?? "" == model?.data?.project_details?.addressLine2 ?? "" {
            //                self.addressLabel.text = "\(model?.data?.project_details?.addressLine2 ?? "" ), \(model?.data?.project_details?.zipCode ?? "")"
            //            } else {
            //                self.addressLabel.text = "\(model?.data?.project_details?.addressLine1 ?? "" ), \(model?.data?.project_details?.city ?? "" ), \(model?.data?.project_details?.state ?? ""), \(model?.data?.project_details?.zipCode ?? "")"
            //            }
            
            //self.projectTypeLabel.text = "\(model?.data?.project_details?.type ?? "" )"
            //            for i in 0..<(model?.data?.project_details?.project_deliverable?.count ?? 0) {
            //                self.diverableData.append("\(String(describing: model?.data?.project_details?.project_deliverable?[i].deliveralble ?? ""))")
            //            }
            //            var diverable = self.diverableData.map{String($0)}.joined(separator: ", ")
            //            self.projectDeliverableLabel.text = "\(diverable)"
            //            self.diverableData.removeAll()
            //            self.lblAmount.text = "$ \(model?.data?.bidAmount ?? "")"
            
            var realAmount = "\(model?.data?.bidAmount ?? "")"
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            
            let amount = Double(realAmount)
            let formattedString = formatter.string(for: amount)
            self.txtFldBidAmount.text = "$ \(formattedString ?? "")"
            
            //self.startDatePicker.date.stringValue = model.data.proposedStartDate
            //self.endDatePicker.date.stringValue = model?.data?.proposedEndDate
            //self.lblNotableItems.text = model?.data?.description ?? ""
            
            //            if model?.data?.project_details?.projectType == 1 {
            //                self.topLeftVw.backgroundColor = UIColor.appColorBlue
            //                self.topLeftTitle.text = "Sub Task"
            //                self.inviteTask = true
            //                self.projectDeliverable.text = "Description"
            //                self.projectDeliverableLabel.text = model?.data?.project_details?.taskDescription ?? ""
            //                self.projectTypeLabel.text = model?.data?.project_details?.projectCategory?.title ?? ""
            //            } else {
            //                self.inviteTask = false
            //                self.topLeftTitle.text = "Main Project"
            //                self.topLeftVw.backgroundColor = UIColor.appBtnColorOrange
            //                self.projectDeliverable.text = "Project deliverables"
            //            }
            
            
            //self.lblAcceptedStartEndDate.text = "\(DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM"))-\(DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM"))"
            
            //                self.lblAcceptedBidAmount.text = "$ \(model?.data?.bidAmount ?? "0.0")"
            
            //var realAmount = "\(model?.data?.bidAmount ?? "0.0")"
            //let formatter = NumberFormatter()
            //formatter.numberStyle = NumberFormatter.Style.decimal
            
            //let amount = Double(realAmount)
            //let formattedString = formatter.string(for: amount)
            //self.lblAcceptedBidAmount.text = "$ \(formattedString ?? "")"
            
            //self.imgHomeOwner.sd_setImage(with: URL(string: model?.data?.project_details?.user_ProjectDetail?.profilePic ?? ""), placeholderImage: UIImage(named: "ic_HO_profile"), completed:nil)
            self.txtHomeOwner.text = "\(model?.data?.project_details?.user_ProjectDetail?.firstName ?? "")"
            self.txtHomeOwner.resetFloatingLable()
            self.txtHomeOwnerB.text = "\(model?.data?.project_details?.user_ProjectDetail?.lastName ?? "" )"
            self.txtStreetAddress.text = "\(model?.data?.project_details?.addressLine1 ?? "" )"
            self.txtMailingAddress.text = "\(model?.data?.mailingAddress ?? "" )"
            self.txtCellPhone.text = "\(model?.data?.cellPhone ?? "" )"

//            self.txtHomeOwnerBA.text = "\(model?.data?.homeOwner1 ?? "" )"
            self.setImageSignature(imageSignatureBase64: model?.data?.homeOwnerSign1 ?? "")
            self.txtHomeOwnerBB.text = "\(model?.data?.homeOwner2 ?? "" )"
            self.txtEmail.text = "\(model?.data?.email ?? "" )"
            self.txtHOA.text = "\(model?.data?.hoa ?? "" )"
            self.ckbPermit.isSelected = model?.data?.permit == 1
            self.ckbCutInstallRidgVent.isSelected = model?.data?.cutInstallRidgeVent == 1
            self.txtInsurance.text = "\(model?.data?.insurance ?? "" )"
            self.txtClaimNumber.text = "\(model?.data?.claimNumber ?? "" )"
            self.ckbInsFullyApproved.isSelected = model?.data?.insFullyApproved == 1
            self.ckbInsPartialApproved.isSelected = model?.data?.insPartialApproved == 1
            self.ckbRetail.isSelected = model?.data?.retail1 == 1
            self.ckbRetailDepreciation.isSelected = model?.data?.retailDepreciation == 1
            self.txtMainDwellingRoof.text = "\(model?.data?.mainDwellingRoofSQ ?? "")"
            self.txtShed.text = "\(model?.data?.shedSQ ?? "")"
            self.txtDecking.text = "\(model?.data?.decking ?? "")"
            self.txtFlatRoof.text = "\(model?.data?.flatRoofSQ ?? "")"
            self.txtTotal.text = "\(model?.data?.total ?? "")"
            self.txtDeducible.text = "\(model?.data?.deducible ?? "")"
            self.txtFe.text = "\(model?.data?.fe ?? "")"
            self.txtRetail.text = "\(model?.data?.retail2 ?? "")"
            self.ckbRetailDepreciation.isSelected = model?.data?.retailDepreciation == 1
            self.txtBe.text = "\(model?.data?.be ?? "")"
            self.txtBrand.text = "\(model?.data?.brand ?? "")"
            self.txtStyle.text = "\(model?.data?.style ?? "")"
            self.txtColor.text = "\(model?.data?.color1 ?? "")"
            self.txtPermaBoot.text = "\(model?.data?.permaBoot123 ?? "")"
            self.txtPermaBootB.text = "\(model?.data?.permaBoot34 ?? "")"
            self.txtPipeJack.text = "\(model?.data?.pipeJack123 ?? "")"
            self.txtPipeJackB.text = "\(model?.data?.pipeJack34 ?? "")"
            self.txtColorB.text = "\(model?.data?.color2 ?? "")"
            self.txtMaterialLocation.text = "\(model?.data?.materialLocation ?? "")"
            self.txtDumpsterLocation.text = "\(model?.data?.dumpsterLocation ?? "")"
            self.txtSpecialInstructions.text = "\(model?.data?.specialInstructions ?? "")"
            self.txtNotes.text = "\(model?.data?.notes ?? "")"
            self.txtRoofing.text = "\(model?.data?.roofing1 ?? "")"
            self.txtRoofingPrice.text = "\(model?.data?.roofing2 ?? "")"
            self.txtDebrisRemoval.text = "\(model?.data?.debrisRemoval1 ?? "")"
            self.txtDebrisRemovalPrice.text = "\(model?.data?.debrisRemoval2 ?? "")"
            self.txtOverheadProfit.text = "\(model?.data?.overheadProfit1 ?? "")"
            self.txtCodeUpgrades.text = "\(model?.data?.codeUpgrades ?? "")"
            self.txtTotal.text = "\(model?.data?.totalSQ ?? "")"
            self.txtCodeUpgradesPrice.text = "\(model?.data?.total ?? "")"
            self.ckbPaymentTermsDeductible.isSelected = model?.data?.paymentTerms1 == 1
            self.ckbSatelliteDish.isSelected = model?.data?.satelliteDish == 1
            self.ckbPaymentTermsFinance.isSelected = model?.data?.paymentTerms2 == 1
            self.ckbAntenna.isSelected = model?.data?.antenna == 1
            self.txtDetachedGarage.text = "\(model?.data?.detachedGarageSQ ?? "")"
            
            //checkbox
            self.getCodeComboBoxTurtleVents(for: model?.data?.turtleVents ?? "")
            self.getCodeComboBoxDripEdge(for: model?.data?.dripEdgeF55 ?? "")
            self.getCodeComboBoxCounterFlashing(for: model?.data?.counterFlashing ?? "")
            self.getCodeComboBoxUnderlayment(for: model?.data?.syntheticUnderlayment ?? "")
            self.getCodeComboBoxRidgeVent(for: model?.data?.ridgeVent ?? "")
            self.getCodeComboBoxChimneyFlashing(for: model?.data?.chimneyFlashing ?? "")
            self.getCodeComboBoxSprayPaint(for: model?.data?.sprayPaint ?? "")
            self.getCodeComboBoxAtticFan(for: model?.data?.atticFan ?? "")
            
            //self.lblDateEndsOnTwo.text = DateHelper.convertDateString(dateString: model?.data?.proposedEndDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            //self.lblNotableItems.text = DateHelper.convertDateString(dateString: model?.data?.proposedStartDate ?? "", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
            //self.arrProjectFiles = model?.data?.bids_documents ?? [BidsDocumentsDetails]()
            //self.arrProjectUploadFiles = model?.data?.project_details?.project_files ?? [ProjectFiles]()
            //var count = self.arrProjectFiles.count + self.arrProjectUploadFiles.count
            //            if count == 0 || count == nil {
            //                self.lblAttachedFiles.text = "Attached Files"
            //            } else {
            //                self.lblAttachedFiles.text = "Attached Files (\(count))"
            //            }
            //
            //            if model?.data?.project_details?.project_files?.count ?? 0 > 0 {
            //                self.lblAttachedFiles.isHidden = false
            //            } else {
            //                self.lblAttachedFiles.isHidden = false
            //            }
            //self.collectionVw.reloadData()
            arrOfImgStrings.removeAll()
            self.resetFloatingLabel()
        }
    }
    
    func setImageSignature(imageSignatureBase64: String) {
        if imageSignatureBase64 != ""{
            if let imageData = Data(base64Encoded: imageSignatureBase64), let image = UIImage(data: imageData) {
                self.imgDrawSignature.isHidden = false
                self.imgDrawSignature.image = image
                self.base64StringSignature = imageSignatureBase64
            }
        }
    
    }
    
    func getCodeComboBoxTurtleVents(for buttonValue: String) {
        switch buttonValue {
        case "Remove & Replace":
            self.ckbRemoveReplace.isSelected = true
        case "Detach & Reset":
            self.ckbDetachReset.isSelected = true
        case "Remove & Cover Holes":
            self.ckbRemoveCoverHoles.isSelected = true
        default:
            self.ckbRemoveReplace.isSelected = false
            self.ckbDetachReset.isSelected = false
            self.ckbDetachReset.isSelected = false
        }
    }
    
    func getCodeComboBoxDripEdge(for buttonValue: String) {
        switch buttonValue {
        case "White":
            self.ckbWhiteDripEdge.isSelected = true
        case "Brown":
            self.ckbBrown.isSelected = true
        case "Almond":
            self.ckbAlmond.isSelected = true
        default:
            self.ckbWhiteDripEdge.isSelected = false
            self.ckbBrown.isSelected = false
            self.ckbAlmond.isSelected = false
        }
    }
    
    func getCodeComboBoxCounterFlashing(for buttonValue: String) {
        switch buttonValue {
        case "Black":
            self.ckbBlack.isSelected = true
        case "Brown":
            self.ckbBrownB.isSelected = true
        default:
            self.ckbBlack.isSelected = false
            self.ckbBrownB.isSelected = false
        }
    }
    
    func getCodeComboBoxUnderlayment(for buttonValue: String) {
        switch buttonValue {
        case "AEGC":
            self.ckbAegc.isSelected = true
        case "IKO":
            self.ckbIko.isSelected = true
        case "OC":
            self.ckbOc.isSelected = true
        default:
            self.ckbAegc.isSelected = false
            self.ckbIko.isSelected = false
            self.ckbOc.isSelected = false
        }
    }
    
    func getCodeComboBoxRidgeVent(for buttonValue: String) {
        switch buttonValue {
        case "OC":
            self.ckbOCb.isSelected = true
        case "GAF":
            self.ckbGaf.isSelected = true
        case "AIR VENT":
            self.ckbAirVent.isSelected = true
        default:
            self.ckbOCb.isSelected = false
            self.ckbGaf.isSelected = false
            self.ckbAirVent.isSelected = false
        }
    }
    
    func getCodeComboBoxChimneyFlashing(for buttonValue: String) {
        switch buttonValue {
        case "Black":
            self.ckbBlackB.isSelected = true
        case "Brown":
            self.ckbBrownC.isSelected = true
        case "White":
            self.ckbWhite.isSelected = true
        case "Copper":
            self.ckbCopper.isSelected = true
        default:
            self.ckbBlackB.isSelected = false
            self.ckbBrownC.isSelected = false
            self.ckbWhite.isSelected = false
            self.ckbCopper.isSelected = false
        }
    }
    
    func getCodeComboBoxSprayPaint(for buttonValue: String) {
        switch buttonValue {
        case "Black":
            self.ckbBlackC.isSelected = true
        case "Brown":
            self.ckbBrownD.isSelected = true
        case "Grey":
            self.ckbGrey.isSelected = true
        case "White":
            self.ckbWhiteB.isSelected = true
        default:
            self.ckbBlackC.isSelected = false
            self.ckbBrownD.isSelected = false
            self.ckbGrey.isSelected = false
            self.ckbWhiteB.isSelected = false
        }
    }
    
    func getCodeComboBoxAtticFan(for buttonValue: String) {
        switch buttonValue {
        case "Remove & Replace":
            self.ckbRemoveReplaceB.isSelected = true
        case "Detach & Reset":
            self.ckbDetachResetB.isSelected = true
        default:
            self.ckbRemoveReplaceB.isSelected = false
            self.ckbDetachResetB.isSelected = false
        }
    }
    
    func getCodeComboBoxLightningRod(for buttonValue: String) {
        switch buttonValue {
        case "Detach Only":
            self.ckbDetach.isSelected = true
        case "Detach/Dispose":
            self.ckbDetachDispose.isSelected = true
        default:
            self.ckbDetach.isSelected = false
            self.ckbDetachDispose.isSelected = false
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
    
    @IBAction func btnAsignHomeOwner(_ sender: Any) {
        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "AsignDrawVC") as? SignDrawVC
        destinationViewController!.delegate = self
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
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
    
    @IBAction func openTerm(_ sender: Any) {
        let destinationViewController = Storyboard.invitation.instantiateViewController(withIdentifier: "TermAgreement") as? PlaceBidTermVC
        self.navigationController?.pushViewController(destinationViewController!, animated: true)
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
        let count = arrOfImages.count
        let limit  = 149
        if count < limit {
            handleCameraOptions()
        }else{
            print("limit is 150")
        }
        // handleCameraOptions()
    }
    
    func addParamsID(params: [String: Any]) -> [String:Any] {
        var param = params
        if self.bidId == 0 {
            param["projectId"] = "\(self.projectId)"
        } else {
            param["id"] = self.bidId
        }
        return param
    }
    
    
    //MARK: ACTION SUBMIT
    @IBAction func actionSubmit(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: datePickerView.date)
        let stringDateHomeOwnerA = formatter.string(from: datePickerHomeOwnerBADate.date)
        let stringDateHomeOwnerB = formatter.string(from: datePickerHomeOwnerBBDate.date)
        let stringDateAEGC = formatter.string(from: datePickerAEGCDate.date)
        
        var mediaArrCount = 0
        if self.bidId == 0 {
            mediaArrCount = self.arrOfFiles.count
        } else {
            mediaArrCount = self.arrOfFilesManually.count + self.arrOfFiles.count
        }
        
        let permit : Bool = ckbPermit.isSelected
        
        let placeBidModel  = PlaceBidModel(date: stringDate, homeOwnerFirst: txtHomeOwner.text ?? "", homeOwnerSecond: txtHomeOwnerB.text ?? "", streetAddress: txtStreetAddress.text ?? "", mailingAddress: txtMailingAddress.text ?? "", cellPhone: txtCellPhone.text ?? "", email: txtEmail.text ?? "", hoa: txtHOA.text ?? "", permit: permit , insurance: txtInsurance.text ?? "", claimNumber: txtClaimNumber.text ?? "", insFullyApproved: ckbInsFullyApproved.isSelected, insPartialApproved: ckbInsPartialApproved.isSelected, retail: ckbRetail.isSelected, retailWDepreciation: ckbRetailDepreciation.isSelected, mainDwellingRoof: txtMainDwellingRoof.text ?? "", shedSQ: txtShed.text ?? "", decking: txtDecking.text ?? "", flatRoofSQ: txtFlatRoof.text ?? "", total: txtTotal.text ?? "", totalSQ: txtCodeUpgradesPrice.text ?? "", deducible: txtDeducible.text ?? "", fe: txtFe.text  ?? "", retailB: txtRetail.text ?? "", be: txtBe.text  ?? "", brand: txtBrand.text ?? "", style: txtStyle.text ?? "", color: txtColor.text ?? "", white: String(ckbWhiteDripEdge.isSelected), brown: String(ckbBrown.isSelected), aegc: String(ckbAegc.isSelected), iko: String(ckbIko.isSelected), oc: String(ckbOc.isSelected), ocB: String(ckbOCb.isSelected), gaf: String(ckbGaf.isSelected), airVent: String(ckbAirVent.isSelected), cutInstallRidgeVent: ckbCutInstallRidgVent.isSelected, black: String(ckbBlack.isSelected), brownB: String(ckbBrownB.isSelected), whiteB: String(ckbWhite.isSelected), copper: String(ckbCopper.isSelected), blackB: String(ckbBlackB.isSelected), brownC: String(ckbBrownC.isSelected), grey: String(ckbGrey.isSelected), whiteC: String(ckbWhiteB.isSelected), removeReplace: String(ckbRemoveReplace.isSelected), deatchReset: String(ckbDetachReset.isSelected), removeCoverHoles: String(ckbRemoveCoverHoles.isSelected), permaBoot: txtPermaBoot.text ?? "", permaBootB: txtPermaBootB.text ?? "", pipeJack: txtPipeJack.text ?? "", pipeJackB: txtPipeJackB.text ?? "", removeReplaceB: String(ckbRemoveReplaceB.isSelected), deatchResetB: String(ckbDetachResetB.isSelected), colorB: txtColorB.text ?? "", satelliteDish: ckbSatelliteDish.isSelected, antenna: ckbAntenna.isSelected, detachOnly: String(ckbDetach.isSelected), detachDispose: String(ckbDetachDispose.isSelected), materialLocation: txtMaterialLocation.text ?? "", dumpsterLocation: txtDumpsterLocation.text ?? "", specialInstructions: txtSpecialInstructions.text ?? "", notes: txtNotes.text ?? "", roofing: txtRoofing.text ?? "", roofingPrice: txtRoofingPrice.text  ?? "", debrisRemoval: txtDebrisRemoval.text ?? "", debrisRemovalPrice : txtDebrisRemovalPrice.text ?? "", overheadProfit: txtOverheadProfit.text ?? "", codeUpgrades: txtCodeUpgrades.text ?? "", paymentTermsDeductible: ckbPaymentTermsDeductible.isSelected, paymantTermsFinance: ckbPaymentTermsFinance.isSelected, homeOwner: txtHomeOwner.text ?? "", homeOwnerDate: stringDateHomeOwnerA, homeOwnerDateBA: txtHomeOwnerBB.text ?? "", aegcRepresentative: txtAegcRepresentative.text ?? "", aegcRepresentativeBA: "", dateHomeOwner1: stringDateHomeOwnerA, dateHomeOwner2: stringDateHomeOwnerB, dateAEGC: stringDateAEGC, detachedGarageSQ: txtDetachedGarage.text ?? "")
        placeBidViewModel.model = placeBidModel
        //        placeBidViewModel.validatePlaceBidnModel {[weak self] (success, error) in
        //            guard let strongSelf = self else { return }
        //            if error == nil {
        if self.bidId == 0 {
            placeBidViewModel.submitBidApi(self.buildParams(model: placeBidViewModel.model)) { response in
                self.handleSuccessApi()
            }
        } else {
            placeBidViewModel.updateBidApi(self.buildParams(model: placeBidViewModel.model)) { response in
                self.handleSuccessApi()
            }
        }
        //            } else {
        //                let alertController: UIAlertController = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
        //                let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
        //                }
        //
        //                alertController.addAction(okAction)
        //                self!.present(alertController, animated: true, completion: nil)
        //            }
        //        }
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

extension PlaceBidVC: SignDrawVCDelegate {
    func signDrawVCDidDismiss(_ controller: SignDrawVC, base64: String?) {
        //print(base64 ?? "Sem imagem")
        if let base64String = base64, let imageData = Data(base64Encoded: base64 ?? ""), let image = UIImage(data: imageData) {
            self.imgDrawSignature.isHidden = false
            self.imgDrawSignature.image = image
            self.base64StringSignature = base64String
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
        } else if textField == txtCellPhone {
            if string.count > 0 {
                self.txtCellPhone.resetFloatingLable()
            }
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = textField.format(with: "(XXX)-XXX-XXXX", phone: newString)
            return false
        }
        else if textField == txtFldBidAmount {
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
                    let realAmount = "\(receiveableAmount)"
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
}
