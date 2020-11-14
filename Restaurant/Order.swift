//
//  Order.swift
//  Restaurant
//
//  Created by Артем on 30.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import Foundation


struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}


