//
//  View.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import Foundation
import UIKit

extension UITableView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
            return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
        }
    
    func scrollToBottom(isAnimated:Bool = true){
            DispatchQueue.main.async {
                let indexPath = IndexPath(
                    row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                    section: self.numberOfSections - 1)
                if self.hasRowAtIndexPath(indexPath: indexPath) {
                    self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
                }
            }
        }
}

extension UIView {
        
    func addCustomShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.cornerRadius = 5.0
    }
    
    func setRoundCorners (radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    //MARK: - UIVIEW BORDER WIDTH
    @IBInspectable var border:CGFloat{
        get{
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {

        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func addDashedBorder() {
        let color = UIColor(hex: "#DCDCDE"  )!.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

class CustomeDasboardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

class CircularProgressView: UIView {
   var progressLyr = CAShapeLayer()
   var trackLyr = CAShapeLayer()
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      makeCircularPath()
   }
   var progressClr = UIColor.appBtnColorOrange {
      didSet {
         progressLyr.strokeColor = progressClr.cgColor
      }
   }
   var trackClr = UIColor.appColorGrey {
      didSet {
         trackLyr.strokeColor = trackClr.cgColor
      }
   }
    
    
   func makeCircularPath() {
       
       let circle = self

       circle.layoutIfNeeded()
       let centerPoint = CGPoint (x: circle.bounds.width / 2, y: circle.bounds.width / 2)
       let circleRadius : CGFloat = circle.bounds.width / 2 * 0.83
       
      self.backgroundColor = UIColor.clear
      self.layer.cornerRadius = self.frame.size.width/2
//      let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
       let circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true    )

      trackLyr.path = circlePath.cgPath
      trackLyr.fillColor = UIColor.clear.cgColor
      trackLyr.strokeColor = trackClr.cgColor
      trackLyr.lineWidth = 3.0
      trackLyr.strokeEnd = 1.0
      layer.addSublayer(trackLyr)
      progressLyr.path = circlePath.cgPath
      progressLyr.fillColor = UIColor.clear.cgColor
      progressLyr.strokeColor = progressClr.cgColor
      progressLyr.lineWidth = 3.0
      progressLyr.strokeEnd = 0.0
      layer.addSublayer(progressLyr)
   }
    
   func setProgressWithAnimation(duration: TimeInterval, value: Float) {
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.duration = duration
      animation.fromValue = 0
      animation.toValue = value
      animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
      progressLyr.strokeEnd = CGFloat(value)
      progressLyr.add(animation, forKey: "animateprogress")
   }
}


