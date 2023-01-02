//
//  AddPortfolioImageVC.swift
//  TA
//
//  Created by Applify on 18/01/22.
//

import UIKit
import Photos
import SDWebImage

class AddPortfolioImageVC: BaseViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var portfolioImageHeight: NSLayoutConstraint!
    @IBOutlet weak var portfolioImageCollectionView: UICollectionView!
    @IBOutlet weak var newPortfolioHeight: NSLayoutConstraint!
    @IBOutlet weak var newPortfolioCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var portfilioImage: UIImageView!{
        didSet {
            portfilioImage.clipsToBounds = true
        }
    }
    
    var userFilesArray = [[String : Any]]()
    var addPortfolioImageVM : AddPortfolioImageVM = AddPortfolioImageVM()
    var ratingImageVM: CORatingImageVM = CORatingImageVM()
    
    var portfolioImages = [CORatingImageListing]()
    var addedImage = [UIImage]()
    var id  = 0
    var isselected = true
    var isselect = [Int]()
    
    var isUserImageChangedFromEdit = false
    var userImageNotChangedStringFromEdit = ""
    var isImageSelected = false
    var isFromEdit = false
    private var userImage: String?
    var count = 0
    var imgArr = [String]()
    var newPortfolioImages = [String]()
    var newPortfolioImage = [String]()
//    var newPortfolioImage: Set<String>
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let image  = addedImage.first
       // print("Image size \(image!.getSizeIn(.megabyte)) mb")

//        for i in 0..<portfolioImages.count{
//            var portImage = portfolioImages[i].file
//            var last4 = portImage?.suffix(4)
//            print("hello")
//            if last4 == ".png" || last4 == ".jpg"{
//                newPortfolioImages.append(portImage ?? "")
//            }
//        }
//        //remove Duplicated item from the Array
//        newPortfolioImage = removeDuplicates(array: newPortfolioImages)
        
        self.doneButton.isEnabled = false
        self.doneButton.alpha = 0.7
//        self.portfolioImageHeight.constant = CGFloat((self.newPortfolioImage.count/3) * 80)
//        self.portfolioImageCollectionView.reloadData()
        
        self.newPortfolioHeight.constant = CGFloat(0)
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 3.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.portfolioImageCollectionView.delegate = self
        self.portfolioImageCollectionView.dataSource = self
        
        self.newPortfolioCollectionView.delegate = self
        self.newPortfolioCollectionView.dataSource = self
        
        self.portfolioImageCollectionView.register(UINib(nibName: "NewPortfoiloImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewPortfoiloImageCollectionViewCell")
        
        self.newPortfolioCollectionView.register(UINib(nibName: "NewPortfoiloImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewPortfoiloImageCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.ratingImageAPI()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func ratingImageAPI(){
        ratingImageVM.getRatingImageApiCall(id) { model in
            print(model?.data?.listing)
            self.portfolioImages = model?.data?.listing ?? []
            for i in 0..<self.portfolioImages.count{
                var portImage = self.portfolioImages[i].file
                var last4 = portImage?.suffix(4)
                print("hello")
                if last4 == ".png" || last4 == ".jpg"{
                    self.newPortfolioImages.append(portImage ?? "")
                }
            }
            //remove Duplicated item from the Array
            self.newPortfolioImage = self.removeDuplicates(array: self.newPortfolioImages)
            self.portfolioImageHeight.constant = CGFloat((self.newPortfolioImage.count/3) * 80)
            self.portfolioImageCollectionView.reloadData()
        }
    }
    
    
    @IBAction func tapDidBackButtonAction(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func porfolioImage(){
        if portfilioImage.image == nil{
            print(portfilioImage.image)
        }
        else{
            print(portfilioImage)
            self.addedImage.append(portfilioImage.image!)
            self.portfilioImage.image = UIImage(named: "")
            self.newPortfolioCollectionView.reloadData()
        }
        if addedImage.count == 1{
            count = 0
        }
        if count == 0{
            self.newPortfolioHeight.constant = CGFloat(90)
            count = count + 1
            self.newPortfolioCollectionView.reloadData()
        }
    }
    
    
    @IBAction func TapDidDoneButtonAction(_ sender: UIButton) {
        var param = [String: Any]()
        param = [
            "portFolioImagesarr": userFilesArray
            ]
        addPortfolioImageVM.uploadPortfolioApiCall(param) { modal in
            self.navigationController!.popViewController(animated: true)
            
        }
    }
    
    @IBAction func actionChooseAddPortfilioImage(_ sender: Any) {
        var count = addedImage.count
        let limit  = 149
        if count < limit {
            handleCameraOptions()
        }else{
            print("limit is 150")
            showMessage(with: ValidationError.validImageCount, theme: .error)
        }
         //handleCameraOptions()
    }
    
    func uploadProjectImage(fileImageData:Data) {
        let randomName = "\(randomString())"
        addPortfolioImageVM.addPortfolioImageApi(keyToUploadData: "file", fileNames: "\(randomName).png", dataToUpload: fileImageData, param: [:]) { response in
            self.setModelData(response: response!)
            self.doneButton.isEnabled = true
            self.doneButton.alpha = 1.0
        }
    }
    
    func setModelData(response: [String:Any]) {
        let randomName = "\(randomString())"
        let dataDict = response["data"] as! NSDictionary
        let url = dataDict["url"]
        let dict = ["contractorId":"\(id)", "image":dataDict["name"] as! String, "file": url] as [String : Any]
        userFilesArray.append(dict)
    }
    //remove Duplicate item from Array
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
}

// MARK: Extension CollectionDelegateFlowLayout
extension AddPortfolioImageVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height:80)
    }
}

extension AddPortfolioImageVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == portfolioImageCollectionView{

//            let imageUrl = portfolioImages[indexPath.row].file
            let imageUrl = newPortfolioImage[indexPath.row]
            if userFilesArray.filter({$0["file"] as? String == imageUrl}).isEmpty{
                let urls = newPortfolioImage[indexPath.row]
                let img = newPortfolioImage[indexPath.row]

                let dict = ["contractorId":"\(id)", "image":img as! String, "file": urls] as [String : Any]
                userFilesArray.append(dict)
                self.doneButton.isEnabled = true
                self.doneButton.alpha = 1.0
            }
            else{
                //remove item
                if let index = userFilesArray.firstIndex(where: { ( $0["file"] as? String == imageUrl ) } ){
                    userFilesArray.remove(at: index)
                    
                    if userFilesArray.count == 0{
                        self.doneButton.isEnabled = false
                        self.doneButton.alpha = 0.7
                    }
                }
            }
            collectionView.reloadData()
        }
    }
}

extension AddPortfolioImageVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newPortfolioCollectionView{
            return addedImage.count
        }
        return newPortfolioImage.count ?? 0
//        return portfolioImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newPortfolioCollectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPortfoiloImageCollectionViewCell", for: indexPath) as? NewPortfoiloImageCollectionViewCell
            {
//                cell.selectedButton.isHidden = true
                cell.selectedImage.isHidden = true
                cell.crossButton.isHidden = false
                cell.portfolioImageView.image = addedImage[indexPath.row]
                
                cell.removeImageTapAction = {
                    () in
                    cell.crossButton.tag = indexPath.row
                    cell.crossButton.addTarget(self, action: #selector(self.crossAction(sender:)), for: .touchUpInside)
                }
                return cell
            }
        }
        else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPortfoiloImageCollectionViewCell", for: indexPath) as? NewPortfoiloImageCollectionViewCell
            {
                cell.selectedImage.isHidden = true
//                cell.selectedButton.isHidden = true
                cell.crossButton.isHidden = true
//                if let imgStr = portfolioImages[indexPath.row].image{
                let imgStr = newPortfolioImage[indexPath.row]
                    cell.portfolioImageView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "doc"), completed: nil)
                
//                let imageUrl = portfolioImages[indexPath.row].file
                let imageUrl = newPortfolioImage[indexPath.row]
                if userFilesArray.filter({$0["file"] as? String == imageUrl}).isEmpty{
                    cell.selectedImage.isHidden = true
                }
                else{
                    cell.selectedImage.isHidden = false
                    //remove item
//                    if let index = userFilesArray.firstIndex(where: { ( $0["file"] as? String == imageUrl ) } ){
//
////                        userFilesArray.remove(at: index)
//                    }
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    @objc func crossAction(sender: UIButton) {
//        self.portfolioImages.remove(at: sender.tag)
        self.userFilesArray.remove(at: sender.tag)
        self.addedImage.remove(at: sender.tag)
        if addedImage.count == 0{
            self.newPortfolioHeight.constant = CGFloat(0)
            self.doneButton.alpha = 0.7
            self.count = 0
        }
        self.newPortfolioCollectionView.reloadData()
    }
}




//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddPortfolioImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func handleCameraOptions() {
        
        self.view.endEditing(true)
        
        let actionSheetController: UIAlertController = UIAlertController(title: UIFunction.getLocalizationString(text: "User Image"), message: nil, preferredStyle: .actionSheet)
        
        let actionCamera: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Take photo"), style: .default) { action -> Void in
            
            self.choosePhotoFromCameraAction()
        }
        
        let actionGallery: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Choose from gallery"), style: .default) { action -> Void in
            
            self.choosePhotoFromGalleryAction()
        }
        
        let viewPhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "View photo"), style: .default) { action -> Void in
            
            if self.isFromEdit == true {
                if let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
                    if let _userImage = obj.profilePic, _userImage.count > 0 {
                        self.showPhotoBrowser(image: _userImage)
                    }
                }
                
            } else {
                if let _userImage = self.userImage, _userImage.count > 0 {
                    self.showPhotoBrowser(image: _userImage)
                }
            }
            
        }
        
        let removePhoto: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Remove photo"), style: .default) { action -> Void in
            DispatchQueue.main.async {
//                self.portfilioImage.image = #imageLiteral(resourceName: "ic_upload_image")
//                self.editIcone.isHidden = true
                self.isImageSelected = false
                self.portfilioImage.contentMode = .scaleToFill
                self.portfilioImage.setNeedsDisplay()
            }
            self.userImage = nil
            self.showImageInUserPhotoImageView()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: UIFunction.getLocalizationString(text: "Cancel title"), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionCamera.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        actionGallery.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        viewPhoto.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        removePhoto.setValue(UIColor.rbg(r: 255, g: 0, b: 0), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.rbg(r: 0, g: 0, b: 0), forKey: "titleTextColor")
        
        if userImage == nil || userImage?.count == 0
        {
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(cancelAction)
        }
        else
        {
            actionSheetController.addAction(removePhoto)
            actionSheetController.addAction(viewPhoto)
            actionSheetController.addAction(actionCamera)
            actionSheetController.addAction(actionGallery)
            actionSheetController.addAction(cancelAction)
        }
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 20, y: self.view.bounds.size.height - 150, width: 1.0, height: 1.0)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
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
    
    
    func showAlertOfPermissionsNotAvailable()
    {
        let message = UIFunction.getLocalizationString(text: "Camera permission not available")
        let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancel_title = UIFunction.getLocalizationString(text: "Cancel title")
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
    {// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

                picker.dismiss(animated: true, completion: nil)
                
                
                let imageName: String = UIFunction.getRandomImageName()
                let fileManager = FileManager.default
                do
                {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
                    let fileURL = documentDirectory.appendingPathComponent(imageName)
                    portfilioImage.contentMode = .scaleAspectFill
                        if let imageData = (info[convertFromUIImagePickerControllerInfoKey((UIDevice.current.userInterfaceIdiom == .phone) ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 1.0)
                        {
                            
                            let imageData1 =  (imageData.count > 2000000) ? (info[convertFromUIImagePickerControllerInfoKey((UIDevice.current.userInterfaceIdiom == .phone) ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 0.5) : imageData
                            
                            try imageData1?.write(to: fileURL)
                        }
                    
                    
                    
                    userImage = NSString(format:"%@",imageName as CVarArg) as String
                    self.showImageInUserPhotoImageView()
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
    func showImageInUserPhotoImageView()
    {
        self.view.endEditing(true)
        guard let userImage = userImage else
        {
//            let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
            self.portfilioImage.image = nil
//            self.editIcone.isHidden = true
            self.isImageSelected = false
            return
        }

//        self.buttonAddImage .setTitle(nil, for: .normal)

        if (userImage as String).count == 0
        {
           // let add_photo = UIFunction.getLocalizationString(text: "add_photo_title")
//            self.buttonAddImage .setTitle(add_photo, for: .normal)
            self.portfilioImage.image = nil
//            self.editIcone.isHidden = true
            self.isImageSelected = false
        }
        else if ((userImage as String).hasPrefix("http") || (userImage as String).hasPrefix("https"))
        {
            // image from url
            portfilioImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            portfilioImage.sd_setImage(with: URL(string: userImage), placeholderImage: nil)
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
                portfilioImage.image = image
                porfolioImage()
                if self.isFromEdit == true {
                    self.isUserImageChangedFromEdit = true
                }
//                self.editIcone.isHidden = false
                
                self.isImageSelected = true
                self.uploadProjectImage(fileImageData: image?.jpegData(compressionQuality: 0.8) ?? Data())
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

struct portfolio {
    var contractorId: String
    var image: String
    var file: String
}

//extension UIImage {
//    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB,
//                         countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
//        // https://developer.apple.com/documentation/foundation/bytecountformatter
//        let formatter = ByteCountFormatter()
//        formatter.allowedUnits = allowedUnits
//        formatter.countStyle = countStyle
//        return getSizeInfo(formatter: formatter)
//    }
//
////    func getFileSize(allowedUnits: ByteCountFormatter.Units = .useMB,
////                     countStyle: ByteCountFormatter.CountStyle = .memory) -> Double? {
////        guard let num = getFileSizeInfo(allowedUnits: allowedUnits, countStyle: countStyle)?.getNumbers().first else { return nil }
////        return Double(truncating: num)
////    }
//
//    func getSizeInfo(formatter: ByteCountFormatter, compressionQuality: CGFloat = 1.0) -> String? {
//        guard let imageData = jpegData(compressionQuality: compressionQuality) else { return nil }
//        return formatter.string(fromByteCount: Int64(imageData.count))
//    }
//}
//extension Array where Element: Hashable {
//    func removingDuplicates() -> [String] {
//        var addedDict = [Element: Bool]()
//
//        return filter {
//            addedDict.updateValue(true, forKey: $0) == nil
//        }
//    }
//
//    mutating func removeDuplicates() {
//        self = self.removingDuplicates()
//    }
//}
extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> String {

        guard let data = self.pngData() else {
            return ""
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return String(format: "%.2f", size)
    }
}
