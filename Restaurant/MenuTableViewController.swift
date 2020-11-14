//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Артем on 29.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    

    
    var menuItems = [MenuItem]()
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuController.menuDataUpdatedNotification, object: nil)
        
        updateUI()
    }
    
    @objc func updateUI() {
        guard let category = category else {return}
        navigationItem.title = category.capitalized
        self.menuItems =  MenuController.shared.items(forCategory: category) ?? []
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        let placeholderImage = UIImage(named: "placeholder")
        let size = CGSize(width: 120, height: 80)
        // function that resize image size
        func resizeImage (_ image: UIImage, sizeChanged: CGSize) -> UIImage {
            let hasAlpha = true
            let scale: CGFloat = 0.0
            UIGraphicsBeginImageContextWithOptions(sizeChanged, !hasAlpha, scale)
            image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChanged))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage!
        }
        
        let resizedPlaceholderImage = resizeImage(placeholderImage!, sizeChanged: size)
        cell.imageView?.image = resizedPlaceholderImage
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else {return}
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    currentIndexPath != indexPath {
                    return
                }
                let frame = CGRect(x: 0, y: 0, width: 120, height: 80)
                let imageView = UIImageView(frame: frame)
                imageView.image = image
                cell.imageView?.addSubview(imageView)
                //              book:
                //            cell.imageView?.image = image
                //            cell.setNeedsLayout()
                //            or
                //            self.tableView.beginUpdates()
                //            self.tableView.endUpdates()
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuDetailSegue" {
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }
    
   
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let category = category else {return}
        coder.encode(category, forKey: "category")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        category = coder.decodeObject(forKey: "category") as? String
        updateUI()
    }
}
