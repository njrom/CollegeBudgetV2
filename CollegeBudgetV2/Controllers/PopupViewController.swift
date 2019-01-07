//
//  PopupViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 1/5/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var checkingLabel: UILabel!
    @IBOutlet weak var savings1Label: UILabel!
    @IBOutlet weak var savings2Label: UILabel!
    
    var budgets : [Budget]? {
        didSet{
            loadItems()
        }
    }
    
    var totalCheck = 0.0
    var totalSavings1 = 0.0
    var totalSavings2 = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 20
        popupView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        checkingLabel.text = String(format: "Checking: $%.02f", totalCheck)
        savings1Label.text = String(format: "Savings: $%.02f", totalSavings1)
        savings2Label.text = String(format: "Semester: $%.02f", totalSavings2)
        
    }
    
    func loadItems(){
        
        
        for budget in budgets! {
            switch budget.name! {
            case "Entertainment":
                totalCheck = totalCheck + budget.currentBalence
                break
                
            case "Groceries":
                totalCheck = totalCheck + budget.currentBalence
                break
                
            case "Gas":
                totalCheck = totalCheck + budget.currentBalence
                break
            
            case "Emergency":
                totalSavings1 = totalSavings1 + budget.currentBalence
                break
            case "Monitor":
                totalSavings1 = totalSavings1 + budget.currentBalence
                break
            case "Semester":
                totalSavings2 = budget.currentBalence
                break
            default:
                break

        }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}
