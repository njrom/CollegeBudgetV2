//
//  BudgetTableViewCell.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 12/29/18.
//  Copyright © 2018 Nicholas Romano. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {


    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
