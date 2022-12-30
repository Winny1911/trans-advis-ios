//
//  CameraBaseViewController.swift
//  OryxHub
//
//  Created by Ankit Goyal on 2019/9/11.
//  Copyright © 2019 Applify Tech Pvt Ltd. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import SKPhotoBrowser
import MobileCoreServices

class AssetModel: NSObject {
    var image: String?
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var duration: CGFloat = 0.0
    var video: String?
    
    init(image: String?,
         width: CGFloat = 0.0,
         height: CGFloat = 0.0,
         duration: CGFloat = 0.0,
         video: String?) {
        self.image = image
        self.width = width
        self.height = height
        self.duration = duration
        self.video = video
    }
}

// MARK: - Asset Delegate
protocol AssetDelegate {
    func selectedAsset(assset:AssetModel)
}

class CameraBaseViewController: UIViewController {
    var delegate: AssetDelegate?
    var images = [AssetModel]()
    var isShowCropper = true
    var localImages = [UIImage]()
    let maxVideoDuration = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIFunction.AGLogs(log: "Jai Shri Ram. JHMPPWPBJASHJH" as AnyObject)
    }
}

// MARK: - Camera Permissions
extension CameraBaseViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func choosePhotoFromCameraAction(isRecordVideo:Bool = false) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showCamera(isRecordVideo: isRecordVideo)
            }
        } else {
            let alertController: UIAlertController = UIAlertController(title: "Error", message: "Device has no camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc
    func showCamera(isRecordVideo:Bool = false) {
        let status  = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            DispatchQueue.main.async {
                self.openCamera(isRecordVideo: isRecordVideo)
            }
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (status) in
                if status == true {
                    DispatchQueue.main.async {
                        self.openCamera(isRecordVideo: isRecordVideo)
                    }
                } else {
                    self.showAlertOfPermissionsNotAvailable()
                }
            })
        } else if status == .restricted || status == .denied {
            self.showAlertOfPermissionsNotAvailable()
        }
    }
    
    
    func openCamera(isRecordVideo:Bool = false) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        if (isRecordVideo == true) {
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.cameraCaptureMode = .video
            imagePicker.videoMaximumDuration = TimeInterval(maxVideoDuration)
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromGalleryAction(selectMultipleImages:Bool, maxImageAllowed:Int, isChooseVideo:Bool = false, isShowCropper: Bool = false) {
        self.isShowCropper = isShowCropper
        self.images.removeAll()
        self.localImages.removeAll()
        let status = PHPhotoLibrary.authorizationStatus()
        if(status == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        if (selectMultipleImages == false) {
                            self.openGallery(isChooseVideo:isChooseVideo)
                        } else {
                           // self.openGalleryForMultipleImageSelection(maxImageAllowed : maxImageAllowed)
                        }
                    }
                } else {
                    self.showAlertOfPermissionsNotAvailable()
                }
            })
        } else if status == .authorized {
            DispatchQueue.main.async {
                if (selectMultipleImages == false) {
                    self.openGallery(isChooseVideo:isChooseVideo)
                } else {
                   // self.openGalleryForMultipleImageSelection(maxImageAllowed : maxImageAllowed)
                }
            }
        } else if status == .restricted || status == .denied {
            self.showAlertOfPermissionsNotAvailable()
        }
    }
    
    func openGallery(isChooseVideo:Bool = false) {
        if (isChooseVideo == false) {
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.videoMaximumDuration = TimeInterval(maxVideoDuration)
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showAlertOfPermissionsNotAvailable() {
        let message = "App does not have access to your camera or Photos. To enable access, tap Settings and turn On Camera and Photos. This allows you to select the photo from the photo library on your phone."
        let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) -> Void in }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL { // video
           // self.addWatermarkOnImage(videoURL: videoURL)
            
            let videoName = UIFunction.getRandomVideoName()
            UIFunction.createTemporaryURLforVideoFile(url: videoURL, name:videoName)
            if let thumbnail = UIFunction.generateThumbnail(path: videoURL) {
                let thumbNailName = UIFunction.getRandomImageName()
                UIFunction.saveImageInLocalDirectory(image: thumbnail, name: thumbNailName)
                let asset = self.createAsset(for: thumbNailName, and: videoName)
                self.delegate?.selectedAsset(assset: asset)
            }
        } else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { // image
            if self.isShowCropper {
               // self.cropImage(image: selectedImage)
            } else {
                self.saveSelectedImage(image: selectedImage)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveSelectedImage(image: UIImage) {
        let fileName = UIFunction.getRandomImageName()
        UIFunction.saveImageInLocalDirectory(image: image, name: fileName)
        let asset = self.createAsset(for: fileName, and: nil)
        self.delegate?.selectedAsset(assset: asset)
    }
}

// MARK: - Open Attachment In Full View
extension CameraBaseViewController {
   
    func openAttachment(image_path: String) {
        if (!image_path.isEmpty) {
            var photos = [SKPhoto]()
            var photo: SKPhoto!
            if (image_path.isServerImage()) { // image from url
                photo = SKPhoto.photoWithImageURL(image_path)
                photos.append(photo)
            } else {
                let local_image = UIFunction.getImageFromPath(path: image_path) ?? UIImage()
                photo = SKPhoto.photoWithImage(local_image)
                photos.append(photo)
            }
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(0)
            SKPhotoBrowserOptions.displayAction = false
            self.present(browser, animated: true, completion: nil)
        }
    }
}

// MARK: - Create Asset
extension CameraBaseViewController {
    func createAsset(for image: String?, and video: String? ) -> AssetModel {
        var width = 0.0
        var height = 0.0
        if let image = image, let localImage = UIFunction.getImageFromPath(path: image) {
            width = localImage.size.width
            height = localImage.size.height
        }
        let asset = AssetModel(image: image,
                               width: width,
                               height: height,
                               duration: 0.0,
                               video: video)
        return asset
    }
}
