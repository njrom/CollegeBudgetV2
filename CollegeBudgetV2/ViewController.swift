//
//  ViewController.swift
//  CollegeBudgetV2
//
//  Created by Nicholas Romano on 12/23/18.
//  Copyright © 2018 Nicholas Romano. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var budgets = [Budget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadModel()
        
    }
    
    func loadModel() {
        let request : NSFetchRequest<Budget> = Budget.fetchRequest()
        
        do {
            budgets = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tablview.reloadData()
        
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

