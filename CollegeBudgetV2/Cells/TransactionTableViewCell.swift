//
//  TransactionTableViewCell.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 1/1/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit
protocol TransactionCellDelegate: class  {
    func newTransactions(from: Int, name: String?, amountString: String?)
    func transactionToggle(toggle: Bool, tag: Int)
}
class TransactionTableViewCell: UITableViewCell, UITextFieldDelegate{


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: CurrencyField!

        
    @IBOutlet weak var toggleTransactionOutlet: UIButton!
    var isSavings = false
    weak var delegate: TransactionCellDelegate?
    
    let defaultHeight = 60
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.delegate = self
        amountTextField.delegate = self
        
        amountTextField.addDoneButtonOnKeyboard()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.becomeFirstResponder()
        return true
    }
    
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
        delegate?.newTransactions(from: self.tag, name: nameTextField.text, amountString: amountTextField.text)
        }
    }

    
    @IBAction func toggleTransactionType(_ sender: UIButton) {
        if !isSavings {
            sender.setTitle("Savings", for: .normal)
            sender.setTitleColor(UIColor(named: "IncomeBlueColor"), for: .normal)
            isSavings = !isSavings
        } else {
            sender.setTitle("Expense", for: .normal)
            sender.setTitleColor(UIColor(named: "ExpenseGreenColor"), for: .normal)
            
            isSavings = !isSavings
        }
        delegate?.newTransactions(from: self.tag, name: nameTextField.text, amountString: amountTextField.text)
        delegate?.transactionToggle(toggle: isSavings, tag: self.tag)
    }
}
