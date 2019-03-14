//
//  TransactionTableViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 1/1/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class TransactionViewController: UIViewController, TransactionCellDelegate {
    
    
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet var tableView: UITableView!
  
    let generator = UIImpactFeedbackGenerator(style: .heavy)

    
    var transactionsArray = [Transaction]()
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    
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
        tableView.dataSource = self
        tableView.delegate = self
        headerView.setHeaderInfo(headerTitle: selectedBudget!.name!, currentBalence: selectedBudget!.currentBalence, secondaryBalence: selectedBudget!.initialBalence, isSavings: selectedBudget!.isSavings)
        tableView.reloadData()
        
    }
    

    func loadItems(with request: NSFetchRequest<Transaction> = Transaction.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentBudget.name MATCHES %@", selectedBudget!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            request.sortDescriptors = [sortDescriptor]
            transactionsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
    
    
    
    
    @IBAction func addTransactionHit(_ sender: UIButton) {
        generator.impactOccurred()
        print(transactionsArray)
        let newTransaction = Transaction(context: context)
        print("Hit")
        newTransaction.isIncome = selectedBudget!.isSavings
        newTransaction.parentBudget = selectedBudget
        newTransaction.date = Date()
        transactionsArray.insert(newTransaction, at: 0)
        // transactionsArray.append(newTransaction)
        newTransaction.orderPosition = Int32(transactionsArray.firstIndex(of: newTransaction)!)

        let indexPath = IndexPath(item: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
        tableView.reloadData()
        let cell = tableView.cellForRow(at: indexPath) as! TransactionTableViewCell
        
        cell.amountTextField.addDoneButtonOnKeyboard()
        cell.nameTextField.becomeFirstResponder()
        
        

    }
    
    
    
    // Delegate Method that pulls data from the textFields
    func newTransactions(from index: Int , name: String?, amountString: String?) {
        
        let moneyString = amountString!.replacingOccurrences(of: ",", with: "")
        let amount = Double(moneyString.replacingOccurrences(of: "$", with: ""))!
        transactionsArray[index].name = name
        
        if transactionsArray[index].isIncome {
            print("Income")
            selectedBudget!.currentBalence = (selectedBudget!.currentBalence - transactionsArray[index].amount + amount)
            headerView.updateBalance(currentBalance: selectedBudget!.currentBalence)
            transactionsArray[index].amount = amount
        } else {
            selectedBudget!.currentBalence = (selectedBudget!.currentBalence + transactionsArray[index].amount - amount)
            headerView.updateBalance(currentBalance: selectedBudget!.currentBalence)
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
        headerView.updateBalance(currentBalance: selectedBudget!.currentBalence)
        
        saveModel()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! BudgetViewController
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
    
}



extension TransactionViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        
        cell.delegate = self
        cell.isSavings = transaction.isIncome        
        cell.nameTextField.text = transaction.name
        // cell.nameTextField.tag = indexPath.row
        cell.tag = indexPath.row
        // cell.amountTextField.tag = indexPath.row
        cell.amountTextField.text = String(format: "$%.02f", transaction.amount)
        if transaction.name == nil {
            // cell.nameTextField.becomeFirstResponder()
            // print("FirstResponder")
        }
        cell.backgroundColor  = UIColor.clear
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let transaction = transactionsArray[indexPath.row]
        let tranCell = cell as! TransactionTableViewCell
        if transaction.isIncome {
            tranCell.amountTextField.textColor = UIColor(named: "IncomeBlueColor")
            tranCell.toggleTransactionOutlet.setTitleColor(UIColor(named: "IncomeBlueColor"), for: .normal)
            tranCell.toggleTransactionOutlet.setTitle("Savings", for: .normal)
        } else {
            tranCell.amountTextField.textColor = UIColor(named: "ExpenseGreenColor")
            tranCell.toggleTransactionOutlet.setTitleColor(UIColor(named: "ExpenseGreenColor"), for: .normal)
            tranCell.toggleTransactionOutlet.setTitle("Expense", for: .normal)
        }
        
        
        
        if indexPath.row % 2 == 0 {
            // cell.backgroundColor = UIColor(named: "CellColor")
            tranCell.contentView.backgroundColor = UIColor(named: "CellColor2")
        } else {
            tranCell.contentView.backgroundColor = UIColor(named: "CellColor")
        }
    
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(self.transactionsArray[indexPath.row])
            
            // Must update the Balance as if it were gone
            let transaction = transactionsArray[indexPath.row]
            if transaction.isIncome {
                selectedBudget!.currentBalence = selectedBudget!.currentBalence - transaction.amount
            } else {
                selectedBudget!.currentBalence = selectedBudget!.currentBalence + transaction.amount
            }
            headerView.updateBalance(currentBalance: selectedBudget!.currentBalence)
            
            
            do {
                try context.save()
                self.transactionsArray.removeAll()
                self.loadItems()
                self.tableView.reloadData()
            } catch {
                
            }
            
        }
    }
        

    
}

    extension TransactionViewController: UITableViewDelegate {
        
        
        

}
