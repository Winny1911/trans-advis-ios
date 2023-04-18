//
//  AsignDrawVC.swift
//  TA
//
//  Created by Roberto Veiga Junior on 28/03/23.
//

import UIKit
import MobileCoreServices

protocol SignDrawVCDelegate: AnyObject {
    func signDrawVCDidDismiss(_ controller: SignDrawVC, base64: String?)
}

class SignDrawVC: UIViewController {
    
    weak var delegate: SignDrawVCDelegate?
    var imageView = UIImageView()
    var base64String = String()
    
    @IBOutlet weak var viewDraw: ViewDrawBase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveSignature(_ sender: Any) {
        if let image = viewDraw.asImage() {
            if let imageBase64 = image.toBase64() {
                self.base64String = imageBase64
                print(self.base64String)
            }
        }
        self.delegate?.signDrawVCDidDismiss(self, base64: self.base64String)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSignature(_ sender: Any) {
        self.viewDraw.clear()
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIView {
    func asImage() -> UIImage? {
        let newBounds = CGRect(origin: .zero, size: CGSize(width: 122, height: 35))
        
        let renderer = UIGraphicsImageRenderer(bounds: newBounds)
        let image = renderer.image { rendererContext in
            rendererContext.cgContext.setFillColor(UIColor.clear.cgColor)
            rendererContext.cgContext.fill(bounds)
            
            layer.render(in: rendererContext.cgContext)
        }
        
        guard let data = image.pngData() else { return nil }
        
        let options: NSDictionary = [
            kCGImageDestinationLossyCompressionQuality: 1
        ]
        
        let compressedData = NSMutableData()
        guard let imageDestination = CGImageDestinationCreateWithData(compressedData, kUTTypePNG, 1, nil) else {
            return nil
        }
        
        CGImageDestinationAddImageFromSource(imageDestination, CGImageSourceCreateWithData(data as CFData, nil)!, 0, options)
        CGImageDestinationFinalize(imageDestination)
        
        return UIImage(data: compressedData as Data)
    }

}

extension UIImage {
    func toBase64() -> String? {
        let imageData = pngData()
        return imageData?.base64EncodedString()
    }
}
