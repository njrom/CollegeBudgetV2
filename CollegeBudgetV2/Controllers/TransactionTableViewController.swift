//
//  TransactionTableViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 1/1/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class TransactionTableViewController: UITableViewController, TransactionCellDelegate {
    
    
    
    @IBOutlet weak var balenceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var budgetProgressView: CircularProgressView!
    
    
    var transactionsArray = [Transaction]()
    
    var selectedBudget : Budget? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.rowHeight = 75.0
        var color = UIColor(named: "ExpenseGreenColor")!
        if selectedBudget!.isSavings {
            color = UIColor(red:0.00, green:0.86, blue:1.00, alpha:1.0)
        }
        balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
        amountLabel.text =  String(format: "$%.02f", selectedBudget!.initialBalence)
        let progressRatio = Float(CGFloat((selectedBudget!.currentBalence/selectedBudget!.initialBalence)))
        budgetProgressView.progressLayer.strokeColor = color.cgColor
        balenceLabel.textColor = color
        amountLabel.textColor = color
        budgetProgressView.progress = Float(CGFloat((selectedBudget!.currentBalence/selectedBudget!.initialBalence)))
        budgetProgressView.animateView(from: 0.0, to: progressRatio , in: 1.0)
    }
    
    
    func loadItems(with request: NSFetchRequest<Transaction> = Transaction.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentBudget.name MATCHES %@", selectedBudget!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            transactionsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionsArray[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        cell.delegate = self
        var color = UIColor(red:0.47, green:1.00, blue:0.45, alpha:1.0)
        cell.isSavings = transaction.isIncome
        cell.toggleTransactionOutlet.setTitleColor(UIColor(named: "IncomeBlueColor"), for: .normal)
        if transaction.isIncome {
            color = UIColor(red:0.00, green:0.86, blue:1.00, alpha:1.0)
            cell.toggleTransactionOutlet.setTitleColor(UIColor(named: "IncomeBlueColor"), for: .normal)
            cell.toggleTransactionOutlet.setTitle("Savings", for: .normal)
        } else {
            cell.toggleTransactionOutlet.setTitleColor(UIColor(named: "ExpenseGreenColor"), for: .normal)
            cell.toggleTransactionOutlet.setTitle("Expense", for: .normal)
        }
        cell.amountTextField.textColor = color
        cell.nameTextField.text = transaction.name
        cell.nameTextField.tag = indexPath.section
        cell.tag = indexPath.section
        cell.amountTextField.tag = indexPath.section
        cell.amountTextField.text = String(format: "$%.02f", transaction.amount)
        if transaction.name == nil {
            cell.nameTextField.becomeFirstResponder()
            print("FirstResponder")
        }
        cell.backgroundColor  = UIColor.clear
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    @IBAction func addTransactionHit(_ sender: UIBarButtonItem) {
        let newTransaction = Transaction(context: context)
        
        newTransaction.isIncome = selectedBudget!.isSavings
        newTransaction.parentBudget = selectedBudget
        newTransaction.date = Date()
        transactionsArray.append(newTransaction)
        tableView.reloadData()
    }
    
    // Delegate Method that pulls data from the textFields
    func newTransactions(from textField: UITextField , name: String?, amountString: String?) {
        let index = textField.tag
        let amount = Double(amountString!.replacingOccurrences(of: "$", with: ""))!
        transactionsArray[index].name = name
        
        if transactionsArray[index].isIncome {
            print("Income")
            selectedBudget!.currentBalence = (selectedBudget!.currentBalence - transactionsArray[index].amount + amount)
            let newRatio = Float(CGFloat(selectedBudget!.currentBalence/selectedBudget!.initialBalence))
            budgetProgressView.animateView(from: budgetProgressView.progress, to: newRatio, in: Double(newRatio + 1))
            // budgetProgressView.progress = newRatio
            balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
            transactionsArray[index].amount = amount
        } else {
            selectedBudget!.currentBalence = (selectedBudget!.currentBalence + transactionsArray[index].amount - amount)
            let newRatio = Float(CGFloat(selectedBudget!.currentBalence/selectedBudget!.initialBalence))
            budgetProgressView.animateView(from: budgetProgressView.progress, to: newRatio, in: Double(newRatio + 0.2))
            // budgetProgressView.progress = newRatio
            balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
            transactionsArray[index].amount = amount
        }
        saveModel()
    }
    
    func transactionToggle(toggle: Bool, tag: Int) {
        transactionsArray[tag].isIncome = toggle
        //  current balance - amount*2 if savings -> expense
        //  current balance + amount*2 if expense -> savings
        if toggle { // expense -> savings
            selectedBudget?.currentBalence = (selectedBudget!.currentBalence) + 2*transactionsArray[tag].amount
        } else { // savings -> expense
            selectedBudget?.currentBalence = (selectedBudget!.currentBalence) - 2*transactionsArray[tag].amount
        }
        let newRatio = Float(CGFloat(selectedBudget!.currentBalence/selectedBudget!.initialBalence))
        budgetProgressView.animateView(from: budgetProgressView.progress, to: newRatio, in: Double(newRatio + 0.2))
        // budgetProgressView.progress = newRatio
        balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
        
        saveModel()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! BudgetTableViewController
        destinationVC.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(self.transactionsArray[indexPath.section])
            
            // Must update the Balance as if it were gone
            let transaction = transactionsArray[indexPath.section]
            if transaction.isIncome {
                selectedBudget!.currentBalence = selectedBudget!.currentBalence - transaction.amount
            } else {
                selectedBudget!.currentBalence = selectedBudget!.currentBalence + transaction.amount
            }
            let newRatio = Float(CGFloat(selectedBudget!.currentBalence/selectedBudget!.initialBalence))
            budgetProgressView.animateView(from: budgetProgressView.progress, to: newRatio, in: Double(newRatio + 0.2))
            // budgetProgressView.progress = newRatio
            balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
            
            
            do {
                try context.save()
                self.transactionsArray.removeAll()
                self.loadItems()
            } catch {
                
            }
            
        }
    }
    
}
