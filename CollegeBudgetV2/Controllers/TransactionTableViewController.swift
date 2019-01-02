//
//  TransactionTableViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 1/1/19.
//  Copyright © 2019 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class TransactionTableViewController: UITableViewController {

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
        
        
        
        var color = UIColor(red:0.47, green:1.00, blue:0.45, alpha:1.0)
        if selectedBudget!.isSavings {
            color = UIColor(red:0.00, green:0.86, blue:1.00, alpha:1.0)
        }
        balenceLabel.text = String(format: "$%.02f", selectedBudget!.currentBalence)
        amountLabel.text =  String(format: "$%.02f", selectedBudget!.initialBalence)
        let progressRatio = Float(CGFloat((selectedBudget!.currentBalence/selectedBudget!.initialBalence)))
        budgetProgressView.progressLayer.strokeColor = color.cgColor
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return transactionsArray.count
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        cell.nameLabel.text = transaction.name!
        cell.amountLabel.text = String(format: "Remaining: $%.02f", transaction.amount)
        return cell
    }

}
