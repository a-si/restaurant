//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Артем on 29.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import Foundation


struct Categories: Codable {
    let categories: [String]
}


struct PreparationTime: Codable {
    let prepTime: Int

    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
