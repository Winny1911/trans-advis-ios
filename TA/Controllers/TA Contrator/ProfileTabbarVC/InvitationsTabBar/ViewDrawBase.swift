//
//  ViewDrawBase.swift
//  TA
//
//  Created by Roberto Veiga Junior on 28/03/23.
//

import UIKit

class ViewDrawBase: UIView {
    
    var lastPoint: CGPoint = .zero
    var brushWidth: CGFloat = 2.0
    var brushColor: UIColor = .blue
    var strokes: [CGPoint] = []
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(brushColor.cgColor)
        for i in 0..<strokes.count {
            if i == 0 {
                context?.move(to: strokes[i])
            } else {
                context?.addLine(to: strokes[i])
            }
        }
        context?.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
            strokes.append(lastPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let newPoint = touch.location(in: self)
            
            strokes.append(newPoint)
            setNeedsDisplay()
        }
    }
    
    func clear() {
        strokes.removeAll()
        setNeedsDisplay()
    }
    
    
    func setStrokeColor(_ color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = color.cgColor
    }
    
    
}
