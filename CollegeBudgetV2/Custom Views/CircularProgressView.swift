import UIKit
//TODO: Need refactor and make so that it nice
class CircularProgressView: UIView, CAAnimationDelegate {
    
    var bgPath1: UIBezierPath!
    var bgPath2: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var fowardProgressLayer: CAShapeLayer!
    var backwardProgressLayer: CAShapeLayer!
    var start : Float = 0.0
    var end : Float = 0.0
    var duration : Double = 0.0
    var forwardDuration : Double = 0.0
    var backwardDuration : Double = 0.0
    var forwardProgressBarColor : UIColor = UIColor(named:"ExpenseGreenColor")!
    var backwardProgressBarColor : UIColor = UIColor.red
    var x : CGFloat = 0
    var y : CGFloat = 0
    var postiveToNegative = false
    var negativeToPostitive = false
    
    
    var progress: Float = 0 {
        willSet(newValue)
        {
            fowardProgressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    var negativeProgress : Float = 0 {
        willSet(newValue) {
            backwardProgressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath1 = UIBezierPath()
        self.simpleShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        bgPath1 = UIBezierPath()
        bgPath2 = UIBezierPath()
        
        self.backgroundColor = UIColor.clear
        self.simpleShape()
    }
    
    func simpleShape() {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath1.cgPath
        shapeLayer.lineWidth = 18
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor(named: "FrameColor")!.cgColor
        
        fowardProgressLayer = CAShapeLayer()
        fowardProgressLayer.path = bgPath1.cgPath
        fowardProgressLayer.lineCap = CAShapeLayerLineCap.round
        fowardProgressLayer.lineWidth = 8
        fowardProgressLayer.fillColor = nil
        fowardProgressLayer.strokeColor = forwardProgressBarColor.cgColor
        fowardProgressLayer.strokeEnd = 0.0
        
        backwardProgressLayer = CAShapeLayer()
        backwardProgressLayer.path = bgPath2.cgPath
        backwardProgressLayer.lineCap = CAShapeLayerLineCap.round
        backwardProgressLayer.lineWidth = 8
        backwardProgressLayer.fillColor = nil
        backwardProgressLayer.strokeColor = forwardProgressBarColor.cgColor
        backwardProgressLayer.strokeEnd = 0.0
        
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(backwardProgressLayer)
        self.layer.addSublayer(fowardProgressLayer)
        
    }
    
    private func createCirclePath() {
        x = self.frame.width/2
        y = self.frame.height/2
        
        let center = CGPoint(x: x, y: y)
        bgPath1.addArc(withCenter: center, radius: x/CGFloat(1.1), startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(Double.pi*3/2), clockwise: true)
        bgPath1.close()
        bgPath2.addArc(withCenter: center, radius: x/CGFloat(1.1), startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(-Double.pi/2), clockwise: false)
        bgPath2.close()
    }
    
    
    func animateView(from start: Float, to end: Float, in duration: Double, secondRun: Bool) {
        // Initalize class variables
        self.start = start
        self.end = end
        self.duration = duration
        // self.forwardProgressBarColor = (start >= 0) ? forwardProgressBarColor : UIColor.red
        if(start > 0 && end < 0) {
            print("Start Postive and end Negative")
            postiveToNegative = true
            // Need duration to be the fraction of each
            // Lets say for now that each % is a 0.1 of a second
            let distance = abs(start) + abs(end)
            
            self.forwardDuration = Double((Float(duration)*(abs(start)/distance)))
            self.backwardDuration = Double((Float(duration)*(abs(end)/distance)))
            print("Forward Duration: \(forwardDuration) \n Backward Duration: \(backwardDuration)")
            
            fowardProgressLayer.strokeColor = forwardProgressBarColor.cgColor
            fowardProgressLayer.strokeEnd = CGFloat(self.start)
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = 0
            
            basicAnimation.duration = self.forwardDuration
            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.delegate = self
            
            fowardProgressLayer.add(basicAnimation, forKey: "urSoBasic")
            fowardProgressLayer.strokeColor = UIColor.yellow.cgColor
            let animcolor = CABasicAnimation(keyPath: "strokeColor")
            animcolor.fromValue         = forwardProgressBarColor.cgColor
            animcolor.toValue           = UIColor.yellow.cgColor
            animcolor.duration          = duration;
            animcolor.repeatCount       = 0;
            
            fowardProgressLayer.add(animcolor, forKey: "strokeColor")
            return
            
        } else if(start >= 0 && end >= 0) {
            print("Start Postive and End Postive")
            fowardProgressLayer.strokeColor = forwardProgressBarColor.cgColor
            
            fowardProgressLayer.strokeEnd = CGFloat(start)
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = end
            
            basicAnimation.duration = duration
            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.delegate = self
            fowardProgressLayer.add(basicAnimation, forKey: "urSoBasic")
            
            fowardProgressLayer.strokeColor = forwardProgressBarColor.cgColor
            if secondRun {
                let animcolor = CABasicAnimation(keyPath: "strokeColor")
                animcolor.fromValue         = UIColor.yellow.cgColor
                animcolor.toValue           = forwardProgressBarColor.cgColor
                animcolor.duration          = duration;
                animcolor.repeatCount       = 0;
                
                fowardProgressLayer.add(animcolor, forKey: "strokeColor")
            }
            return
            
        } else if(end > 0 && start < 0) {
            print("Start Negative and End Postive")
            negativeToPostitive = true
            let distance = abs(start) + abs(end)
            self.backwardDuration = Double((Float(duration)*(abs(start)/distance)))
            self.forwardDuration = Double((Float(duration)*(abs(end)/distance)))
            print("Forward Duration: \(forwardDuration) \n Backward Duration: \(backwardDuration)")
            
            
            backwardProgressLayer.strokeEnd = CGFloat(abs(self.start))
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = 0
            
            basicAnimation.duration = self.backwardDuration
            
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.delegate = self
            
            backwardProgressLayer.add(basicAnimation, forKey: "urSoBasic")
            backwardProgressLayer.strokeColor = UIColor.yellow.cgColor
            let animcolor = CABasicAnimation(keyPath: "strokeColor")
            animcolor.fromValue         = UIColor.red.cgColor
            animcolor.toValue           = UIColor.yellow.cgColor
            animcolor.duration          = duration;
            animcolor.repeatCount       = 0;
            
            backwardProgressLayer.add(animcolor, forKey: "strokeColor")
            return
            
        } else {
            print("Start Negative End Negative")
            let start = abs(start)
            let end = abs(end)
            backwardProgressLayer.strokeColor = backwardProgressBarColor.cgColor
            
            backwardProgressLayer.strokeEnd = CGFloat(start)
            let basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation2.toValue = end
            
            basicAnimation2.duration = duration
            
            basicAnimation2.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation2.isRemovedOnCompletion = false
            basicAnimation2.delegate = self
            backwardProgressLayer.add(basicAnimation2, forKey: "urSoBasic")
            let animcolor = CABasicAnimation(keyPath: "strokeColor")
            animcolor.fromValue         = UIColor.red.cgColor
            animcolor.toValue           = UIColor.red.cgColor
            animcolor.duration          = duration
            
            animcolor.repeatCount       = 0
            
            backwardProgressLayer.add(animcolor, forKey: "strokeColor")
            fowardProgressLayer.add(animcolor, forKey: "strokeColor")
            backwardProgressLayer.strokeColor = UIColor.red.cgColor
            if secondRun {
                let animcolor = CABasicAnimation(keyPath: "strokeColor")
                animcolor.fromValue         = forwardProgressBarColor.cgColor
                animcolor.toValue           = UIColor.red.cgColor
                animcolor.duration          = duration;
                animcolor.repeatCount       = 0;
                
                fowardProgressLayer.add(animcolor, forKey: "strokeColor")
            }
            return
        }
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        
        if postiveToNegative {
            self.fowardProgressLayer.strokeColor = UIColor.red.cgColor
            postiveToNegative = false
            self.animateView(from: 0, to: end, in: backwardDuration, secondRun: true)
        } else if negativeToPostitive {
            self.fowardProgressLayer.strokeColor = forwardProgressBarColor.cgColor
            negativeToPostitive = false
            self.animateView(from: 0, to: end, in: forwardDuration, secondRun: true)
        } else {
            if self.end == 0 {
                self.fowardProgressLayer.strokeColor = UIColor.clear.cgColor
                self.backwardProgressLayer.strokeColor = UIColor.clear.cgColor
            }
            
        }
    }
    
}

