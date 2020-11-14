//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Артем on 29.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    var menuItem: MenuItem?
    
    @IBOutlet var imageOfTheDish: UIImageView!
    @IBOutlet var nameOfTheDish: UILabel!
    @IBOutlet var priceOfTheDish: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
    }
    
    func updateUI() {
        guard let menuItem = menuItem else {return}
        
        navigationItem.title = menuItem.category.capitalized
        nameOfTheDish.text = menuItem.name
        priceOfTheDish.text = String(format: "$%.2f", menuItem.price)
        descriptionLabel.text = menuItem.detailText
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else {return}
            DispatchQueue.main.async {
                self.imageOfTheDish.image = image
            }
            
        }
    }
    
    @IBAction func addToOrderButtonPressed(_ sender: UIButton) {
        guard let menuItem = menuItem else {return}
        
        UIView.animate(withDuration: 0.2) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        MenuController.shared.order.menuItems.append(menuItem)
    }
    
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let menuItem = menuItem else {return}
        coder.encode(menuItem.id, forKey: "menuItemId")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        let menuItemID = Int(coder.decodeInt32(forKey: "menuItemId"))
        menuItem = MenuController.shared.item(withID: menuItemID)!
        updateUI()
    }
    
}
