//
//  ViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 12/23/18.
//  Copyright © 2018 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var budgets = [Budget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 80.0
        //addTestData()
        loadModel()
        
    }
    
    func addTestData() {
        let budgetEntity = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity.setValue("Wegmans", forKey: "name")
        budgetEntity.setValue("shopping-cart", forKey: "imageName")
        budgetEntity.setValue(120.00, forKey: "initialBalence")
        budgetEntity.setValue(120.00, forKey: "currentBalence")
        budgetEntity.setValue(true, forKey: "isSavings")
        saveModel()
    }
    
    func loadModel() {
        let request : NSFetchRequest<Budget> = Budget.fetchRequest()
        
        do {
            budgets = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveModel() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return budgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetTableViewCell
        let budget = budgets[indexPath.row]
        
        var color = UIColor(red:0.47, green:1.00, blue:0.45, alpha:1.0)
        if budget.isSavings {
            color = UIColor(red:0.00, green:0.86, blue:1.00, alpha:1.0)
        }
        
        cell.nameLabel.text = budget.name!
        cell.remainingLabel.text = String(format: "Remaining: $%.02f", budget.currentBalence)
        
        cell.remainingLabel.textColor = color
        cell.progressView.progressLayer.strokeColor = color.cgColor
        cell.iconImageView?.image = UIImage(named: budget.imageName!)
        cell.progressView.progress = Float(CGFloat((budget.currentBalence/budget.initialBalence)))
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        } else {
            cell.backgroundColor = UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.0)
        }
        return cell
    }
    
    


}

