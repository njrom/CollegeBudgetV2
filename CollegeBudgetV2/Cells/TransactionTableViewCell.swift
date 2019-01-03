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
}
class TransactionTableViewCell: UITableViewCell, UITextFieldDelegate{


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
   
    weak var delegate: TransactionCellDelegate?
    
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

}
