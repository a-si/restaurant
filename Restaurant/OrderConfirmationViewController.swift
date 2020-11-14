//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Артем on 05.11.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet var timeRemainingLabel: UILabel!

    var minutes: Int!
    
    @IBOutlet var orderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximatelly \(minutes!) minutes"
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
