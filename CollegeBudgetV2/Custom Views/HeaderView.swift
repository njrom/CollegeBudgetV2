//
//  HeaderView.swift
//  BudgetHeader
//
//  Created by Nicholas Romano on 3/11/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit


class HeaderView: UIView {
    let kCONTENT_XIB_NAME = "HeaderView"
    let animationDuration: Double = 2.0
    
  
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var currentBalanceTitleLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var secondaryTitleLabel: UILabel!
    @IBOutlet weak var secondaryBalanceLabel: UILabel!
    @IBOutlet weak var circularProgressView: CircularProgressView!
    var startingBalance : Double = 0.0
    var currentBalance : Double = 0.0
    var secondaryBalance : Double = 0.0
    var isSavings = false
    @IBOutlet var contentView: UIView!
    
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        
    }
    
    var headerTitle: String? {
        get { return headerTitleLabel?.text }
        set { headerTitleLabel.text = newValue }
    }
    
    func setHeaderInfo(headerTitle: String, currentBalence: Double, secondaryBalence: Double, isSavings: Bool) {
        self.headerTitle = headerTitle
        self.isSavings = isSavings
        currentBalanceLabel.text = String(format: "$%.02f", currentBalence)
        secondaryBalanceLabel.text = String(format: "$%.02f", secondaryBalence)
        self.currentBalance = currentBalence
        self.secondaryBalance = secondaryBalence
        if !isSavings {
            currentBalanceLabel.textColor = UIColor(named: "ExpenseGreenColor")!
            secondaryBalanceLabel.textColor = UIColor(named: "ExpenseGreenColor")!
            circularProgressView.forwardProgressBarColor = UIColor(named: "ExpenseGreenColor")!
            secondaryTitleLabel.text = "Initial Balance"
            
        } else {
            
            currentBalanceLabel.textColor = UIColor(named: "IncomeBlueColor")!
            secondaryBalanceLabel.textColor = UIColor(named: "IncomeBlueColor")!
            circularProgressView.forwardProgressBarColor = UIColor(named: "IncomeBlueColor")!
            secondaryTitleLabel.text = "Savings Goal"
            
        }
        
        let currentRatio = Float(currentBalence/secondaryBalence)
        print(currentRatio)
        circularProgressView.animateView(from: 0, to: currentRatio, in: animationDuration, secondRun: false)
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .default)
        
    }
    
    func updateBalance(currentBalance: Double) {
        self.startingBalance = self.currentBalance // Record previous for animation
        self.currentBalance = currentBalance
        print("\(startingBalance), \(currentBalance)")
        let ratio1 = Float(startingBalance/secondaryBalance)
        let ratio2 = Float(currentBalance/secondaryBalance)
        circularProgressView.animateView(from: ratio1, to: ratio2, in: animationDuration, secondRun: false)
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .default)
        animationStartDate = Date()
    }
    
    var displayLink: CADisplayLink?
    
    
    
    var animationStartDate = Date()
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            if currentBalance < 0 {
                self.currentBalanceLabel.text = String(format: "-$%.02f", abs(currentBalance))
            } else {
                self.currentBalanceLabel.text = String(format: "$%.02f", currentBalance)
            }
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let percentage = elapsedTime / animationDuration
            var value = 0.0
            if(startingBalance <= currentBalance) {
                value = startingBalance + percentage * (currentBalance - startingBalance)
            }
            if(startingBalance > currentBalance) {
                value = startingBalance - percentage * (startingBalance - currentBalance)
            }
            if value < 0 {
                currentBalanceLabel.textColor = UIColor.red
            } else {
                currentBalanceLabel.textColor = isSavings ? UIColor(named: "IncomeBlueColor") : UIColor(named: "ExpenseGreenColor")
            }
            if value < 0 {
                self.currentBalanceLabel.text = String(format: "-$%.02f", abs(value))
            } else {
                self.currentBalanceLabel.text = String(format: "$%.02f", value)
            }
            
        }
    }
        
    

    

    

}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

