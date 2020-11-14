//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Артем on 29.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    
    //    var order = Order()
    
    var orderMinutes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
        
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        let formattedOrder = String(format: "$%.2f", orderTotal)
        
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Submit", style: .default, handler: { (_) in
            self.uploadOrder()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func uploadOrder() {
        let menuIDs = MenuController.shared.order.menuItems.map{$0.id}
        
        MenuController.shared.submitOrder(forMenuIDs: menuIDs) { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
            
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
           let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        return order.menuItems.count
        return MenuController.shared.order.menuItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        
        return cell
    }
    
    
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        cell.textLabel?.text = MenuController.shared.order.menuItems[indexPath.row].name
        let stringPrice = MenuController.shared.order.menuItems[indexPath.row].price
        cell.detailTextLabel?.text = String(format: "$%.2f", stringPrice)
        
        var placeholderImage = UIImage(named: "placeholder")
        let size = CGSize(width: 70, height: 40)

        func resizeImage(_ image: UIImage, sizeChanged: CGSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(sizeChanged, false, 0.0)
            image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChanged))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage!
        }
//        let resizedImagePlaceholder = resizeImage(placeholderImage!, sizeChanged: size)
        placeholderImage = resizeImage(placeholderImage!, sizeChanged: size)
        cell.imageView?.image = placeholderImage
        
        
        MenuController.shared.fetchImage(url: MenuController.shared.order.menuItems[indexPath.row].imageURL) { (image) in
            guard let image = image else {return}
             DispatchQueue.main.async {
                
                let frame = CGRect(x: 0, y: 0, width: 70, height: 40)
                let imageView = UIImageView(frame: frame)
                imageView.image = image
                cell.imageView?.addSubview(imageView)
//                cell.imageView?.image = image
                   }
        }
       
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
        
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation" {
             MenuController.shared.order.menuItems.removeAll()
        }
       
    }
    
    
}
