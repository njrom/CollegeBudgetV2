//
//  AddPopupView.swift
//  CustomUIViews
//
//  Created by Nicholas Romano on 1/28/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit

@IBDesignable class AddPopupView: UIView {
    
  

    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet var containerView: UIView!

    @IBOutlet weak var addTransactionStack: UIStackView!
    @IBOutlet weak var addBudgetStack: UIStackView!
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    func initNib() {
        let bundle = Bundle(for: AddPopupView.self)
        bundle.loadNibNamed("Feature", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.layer.cornerRadius = containerView.frame.width/2
        
        
    }

}
