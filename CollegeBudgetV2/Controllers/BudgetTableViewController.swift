//
//  ViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 12/23/18.
//  Copyright © 2018 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class BudgetTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var navigationBarAppearace = UINavigationBar.appearance()
    var budgets = [Budget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 80.0
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.toolbar.setValue(true, forKey: "hidesShadow")
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateStyle = DateFormatter.Style.long
        
        let dateString = formatter.string(from: date)
        self.title = dateString
        
        // addTestData()
        loadModel()
        
        
    }
    
    func addTestData() {
        let budgetEntity = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity.setValue("Groceries", forKey: "name")
        budgetEntity.setValue("shopping-cart", forKey: "imageName")
        budgetEntity.setValue(160.00, forKey: "initialBalence")
        budgetEntity.setValue(160.00, forKey: "currentBalence")
        budgetEntity.setValue(false, forKey: "isSavings")
        
        let budgetEntity2 = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity2.setValue("Gas", forKey: "name")
        budgetEntity2.setValue("car", forKey: "imageName")
        budgetEntity2.setValue(60.00, forKey: "initialBalence")
        budgetEntity2.setValue(60.00, forKey: "currentBalence")
        budgetEntity2.setValue(false, forKey: "isSavings")
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let resetAlert = UIAlertController(title: NSLocalizedString("str_reset", comment: ""), message: NSLocalizedString("str_reset", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            resetAlert.addAction(UIAlertAction(title: NSLocalizedString("str_continue", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
                self.budgets.remove(at: indexPath.row)
                // TODO: Figure out how to delete from coreData
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            resetAlert.addAction(UIAlertAction(title: NSLocalizedString("str_cancel", comment: ""), style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            saveModel()
            present(resetAlert, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToTransactions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TransactionTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBudget = budgets[indexPath.row]
            destinationVC.title = budgets[indexPath.row].name
        }
    }
    
    


}

