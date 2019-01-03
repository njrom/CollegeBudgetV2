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
        
        
        
        var color = UIColor(red:0.47, green:1.00, blue:0.45, alpha:1.0)
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
        return transactionsArray.count
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        cell.delegate = self
        var color = UIColor(red:0.47, green:1.00, blue:0.45, alpha:1.0)
        if transaction.isIncome {
            color = UIColor(red:0.00, green:0.86, blue:1.00, alpha:1.0)
        }
        cell.amountTextField.textColor = color
        cell.nameTextField.text = transaction.name
        cell.nameTextField.tag = indexPath.row
        cell.amountTextField.tag = indexPath.row
        print(transaction.amount)
        cell.amountTextField.text = String(format: "$%.02f", transaction.amount)
        if transaction.name == nil {
            cell.nameTextField.becomeFirstResponder()
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        } else {
            cell.backgroundColor = UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.0)
        }
        return cell
    }

    @IBAction func addTransactionHit(_ sender: UIBarButtonItem) {
        let newTransaction = Transaction(context: context)
        
        newTransaction.isIncome = false
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
            selectedBudget!.currentBalence = (selectedBudget!.currentBalence - transactionsArray[index].amount + amount)
            let newRatio = Float(CGFloat(selectedBudget!.currentBalence/selectedBudget!.initialBalence))
            budgetProgressView.animateView(from: budgetProgressView.progress, to: newRatio, in: Double(10*newRatio))
            budgetProgressView.progress = newRatio
            balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
            transactionsArray[index].amount = amount
        } else {
            selectedBudget!.currentBalence = (selectedBudget!.currentBalence + transactionsArray[index].amount - amount)
            let newRatio = Float(CGFloat(selectedBudget!.currentBalence/selectedBudget!.initialBalence))
            budgetProgressView.animateView(from: budgetProgressView.progress, to: newRatio, in: Double(10*newRatio))
            budgetProgressView.progress = newRatio
            balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
            transactionsArray[index].amount = amount
        }
        saveModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! BudgetTableViewController
        destinationVC.loadModel()
    }
    
    func saveModel() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
}
