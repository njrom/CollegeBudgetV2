//
//  Circle.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 3/13/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit

class Circle: UIView {

    let progressCircle = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: self.bounds)
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.green.cgColor
        progressCircle.fillColor = UIColor.red.cgColor
        progressCircle.lineWidth = 10.0
        
        // Add the circle to the view.
        self.layer.addSublayer(progressCircle)
    }
    
    
    func animateCircle(circleToValue: CGFloat) {
        let fifths:CGFloat = circleToValue / 5
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.25
        animation.fromValue = fifths
        animation.byValue = fifths
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        progressCircle.strokeEnd = fifths
        
        // Create the animation.
        progressCircle.add(animation, forKey: "strokeEnd")
    }

}
