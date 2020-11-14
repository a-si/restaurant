//
//  MenuItem.swift
//  Restaurant
//
//  Created by Артем on 29.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import Foundation

struct MenuItems: Codable {
      var items: [MenuItem]
  }

struct MenuItem: Codable {
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
    
}
