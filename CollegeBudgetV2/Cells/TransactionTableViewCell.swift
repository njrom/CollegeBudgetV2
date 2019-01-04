//
//  TransactionTableViewCell.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 1/1/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit
protocol TransactionCellDelegate: class  {
    func newTransactions(from: UITextField, name: String?, amountString: String?)
    func transactionToggle(toggle: Bool, tag: Int)
}
class TransactionTableViewCell: UITableViewCell, UITextFieldDelegate{


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!

    @IBOutlet weak var incomeToggleSwitch: UISwitch!
    

    weak var delegate: TransactionCellDelegate?
    
    let defaultHeight = 60
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.delegate = self
        amountTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.newTransactions(from: textField, name: nameTextField.text, amountString: amountTextField.text)
        return true
    }
    
    
    func collapse() {
        UIView.animate(withDuration:0.3, delay: 0.0, options: .curveLinear, animations: {
            
     
            self.layoutIfNeeded()
            
        }, completion: { finished in
            
        })
    }

    @IBAction func incomeToggleSwitchHit(_ sender: UISwitch) {
        delegate?.transactionToggle(toggle: sender.isOn, tag: self.tag)
    }
}
