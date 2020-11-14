//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Артем on 29.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    // заменил на MenuController.shared. как сказано в книге
    //    let menuController = MenuController()
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuController.menuDataUpdatedNotification, object: nil)
        
        updateUI()
        //        MenuController.shared.fetchCategories { (item) in
        //            if let categories = item {
        //                DispatchQueue.main.async {
        //                self.updateUI(with: categories)
        //            }
        //        }
    }
    
    
    
    
    @objc func updateUI() {
        
        categories = MenuController.shared.categories
        self.tableView.reloadData()
    }
    
    
    //    func updateUI (with categories: [String]) {
    //        DispatchQueue.main.async {
    //            self.categories = categories
    //            self.tableView.reloadData()
    //        }
    //    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)
        
        configure(cell, forItemAt: indexPath)
        
        return cell
        
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let stringCategories = categories[indexPath.row]
        cell.textLabel?.text = stringCategories.capitalized
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue" {
            let menuTableViewController = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
        }
    }
    
    
}
