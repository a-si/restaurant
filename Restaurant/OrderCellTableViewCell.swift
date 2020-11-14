//
//  OrderCellTableViewCell.swift
//  Restaurant
//
//  Created by Артем on 07.11.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import UIKit

class OrderCellTableViewCell: UITableViewCell {
    
    
    
    
    
    
    
    
    
    
    
    
    
    

//    Не получается сделать кастомную ячейку. Появляется ошибка Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value во время   self.foodImageView.image = UIImage(named: "placeholder")
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var foodTitle: UILabel!
    @IBOutlet var priceTitle: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    func configure(with menuItem: MenuItem) {
        // из книги
       
       
//        cell.textLabel?.text = menuItem.name
//
//        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)

        foodTitle.text = menuItem.name
        priceTitle.text = String(format: "$%.2f", menuItem.price)
        self.foodImageView.image = UIImage(named: "placeholder")
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else {return}
            DispatchQueue.main.async {
//                if let currentIndexPath =
//
//                    MenuTableViewController.tableView.indexPath(for: cell),
//                    currentIndexPath != indexPath {
//                    return
//                }
//                let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//                let imageView = UIImageView(frame: frame)
//                imageView.image = image
//                cell.imageView?.addSubview(imageView)
                
                
    
                self.foodImageView.image = image
    //            cell.setNeedsLayout()
            }
            
        }
    //    написал сам
    //    let stringText = menuItems[indexPath.row].name
    //    let stringDetailText = Int(menuItems[indexPath.row].price)
    //    cell.textLabel?.text = stringText
    //    cell.detailTextLabel?.text = String("\(stringDetailText) $")
        }
        
        
}
