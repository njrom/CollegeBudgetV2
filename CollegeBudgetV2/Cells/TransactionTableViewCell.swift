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

        
    @IBOutlet weak var toggleTransactionOutlet: UIButton!
    var isSavings = false
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
        print("Fire")
        return true
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
        delegate?.transactionToggle(toggle: isSavings, tag: self.tag)
    }
}
