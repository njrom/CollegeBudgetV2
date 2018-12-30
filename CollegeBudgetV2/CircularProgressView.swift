//
//  CircularProgressView.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 12/29/18.
//  Copyright © 2018 Nicholas Romano. All rights reserved.
//


import UIKit

class CircularProgressView: UIView {
    
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    
    var progress: Float = 0 {
        willSet(newValue)
        {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
        self.backgroundColor = UIColor.clear
        self.simpleShape()
    }
    
    func simpleShape() {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 12
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = 6
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor(red:0.47, green:1.00, blue:0.45, alpha:1.0).cgColor
        progressLayer.strokeEnd = 0.0
        
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func createCirclePath() {
        
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        print(x,y,center)
        bgPath.addArc(withCenter: center, radius: x/CGFloat(1.1), startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(Double.pi*3/2), clockwise: true)
        bgPath.close()
    }
    
    func animateView(from start: Float, to end: Float, in duration: Double) {
        progressLayer.strokeEnd = CGFloat(start)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = end
        
        basicAnimation.duration = duration
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
}

