//
//  ViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 12/23/18.
//  Copyright © 2018 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var navigationBarAppearace = UINavigationBar.appearance()
    var budgets = [Budget]()
    let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 80.0
        tableView.delegate = self
        tableView.dataSource = self

        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.toolbar.setValue(true, forKey: "hidesShadow")
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateStyle = DateFormatter.Style.long
        
        let dateString = formatter.string(from: date)
        self.title = dateString
        self.navigationItem.title = dateString
        addTestData()
        loadModel()
        
        tableView.setEditing(false, animated: true)
        
        
    }
    
    func loadModel() {
        let request : NSFetchRequest<Budget> = Budget.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
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
    
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
  
    


    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTransactions" {
            let destinationVC = segue.destination as! TransactionTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedBudget = budgets[indexPath.section]
                destinationVC.title = budgets[indexPath.section].name
            }
            destinationVC.tableView.reloadData()
        }
        else if segue.identifier == "toPopup" {
            let destinationVC = segue.destination as! PopupViewController
            destinationVC.budgets = budgets
        }
    }
    
    // MARK: Test Specific Code
    func addTestData() {
        
        let budgetEntity4 = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity4.setValue("Semester", forKey: "name")
        budgetEntity4.setValue("money", forKey: "imageName")
        budgetEntity4.setValue(1040.00, forKey: "initialBalence")
        budgetEntity4.setValue(780.33, forKey: "currentBalence")
        budgetEntity4.setValue(true, forKey: "isSavings")
        budgetEntity4.setValue(0, forKey: "orderPosition")
        
        let budgetEntity5 = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity5.setValue("Monitor", forKey: "name")
        budgetEntity5.setValue("monitor", forKey: "imageName")
        budgetEntity5.setValue(500.00, forKey: "initialBalence")
        budgetEntity5.setValue(257.97, forKey: "currentBalence")
        budgetEntity5.setValue(true, forKey: "isSavings")
        budgetEntity5.setValue(1, forKey: "orderPosition")
        
        let budgetEntity7 = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity7.setValue("Emergency", forKey: "name")
        budgetEntity7.setValue("bank", forKey: "imageName")
        budgetEntity7.setValue(250, forKey: "initialBalence")
        budgetEntity7.setValue(250, forKey: "currentBalence")
        budgetEntity7.setValue(true, forKey: "isSavings")
        budgetEntity7.setValue(2, forKey: "orderPosition")
        
        let budgetEntity2 = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity2.setValue("Gas", forKey: "name")
        budgetEntity2.setValue("car", forKey: "imageName")
        budgetEntity2.setValue(60.00, forKey: "initialBalence")
        budgetEntity2.setValue(60.00, forKey: "currentBalence")
        budgetEntity2.setValue(false, forKey: "isSavings")
        budgetEntity2.setValue(3, forKey: "orderPosition")
        
        
        let budgetEntity = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity.setValue("Groceries", forKey: "name")
        budgetEntity.setValue("shopping-cart", forKey: "imageName")
        budgetEntity.setValue(300.00, forKey: "initialBalence")
        budgetEntity.setValue(260.00, forKey: "currentBalence")
        budgetEntity.setValue(false, forKey: "isSavings")
        budgetEntity.setValue(4, forKey: "orderPosition")
        
        let budgetEntity6 = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: context)
        budgetEntity6.setValue("Entertainment", forKey: "name")
        budgetEntity6.setValue("cinema", forKey: "imageName")
        budgetEntity6.setValue(200, forKey: "initialBalence")
        budgetEntity6.setValue(180 , forKey: "currentBalence")
        budgetEntity6.setValue(false, forKey: "isSavings")
        budgetEntity6.setValue(5, forKey: "orderPosition")
        saveModel()
    }
    
}

extension BudgetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // NOT NEEDED, SINCE I ASSUME THAT YOU ALREADY FETCHED ON INITIAL LOAD
        // attemptFetch()
        
        // NOT NEEDED
        //self.controller.delegate = nil
        
        let object = budgets[sourceIndexPath.section]
        budgets.remove(at: sourceIndexPath.section)
        budgets.insert(object, at: destinationIndexPath.section)
        print("\(sourceIndexPath.section) \(destinationIndexPath.section)")
        // REWRITEN BELOW
        //var i = 0
        //for object in objects {
        //    object.setValue(i += 1, forKey: "orderPosition")
        //}
        
        for (index, item) in budgets.enumerated() {
            item.orderPosition = Int32(index)
        }
        
        saveModel()
        //self.controller.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return budgets.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetTableViewCell
        let budget = budgets[indexPath.section]
        
        var color = UIColor(named: "ExpenseGreenColor")!
        if budget.isSavings {
            color = UIColor(red:0.00, green:0.86, blue:1.00, alpha:1.0)
        }
        
        cell.nameLabel.text = budget.name!
        if budget.isSavings {
            cell.remainingLabel.text = String(format: "Saved: $%.02f", budget.currentBalence)
        } else {
            cell.remainingLabel.text = String(format: "Remaining: $%.02f", budget.currentBalence)
        }
        cell.remainingLabel.textColor = color
        cell.progressView.progressLayer.strokeColor = color.cgColor
        cell.iconImageView?.image = UIImage(named: budget.imageName!)
        cell.progressView.progress = Float(CGFloat((budget.currentBalence/budget.initialBalence)))
        
        cell.contentView.backgroundColor = UIColor(named: "DetailColor")
        cell.backgroundColor = UIColor.clear
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
}

extension BudgetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTransactions", sender: self)
    }
    
    
}



