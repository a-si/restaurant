//
//  MenuController.swift
//  Restaurant
//
//  Created by Артем on 30.10.2020.
//  Copyright © 2020 Artem Syryanyi. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
    
    let baseURL = URL(string: "http://localhost:8090/")!
    
    static let shared = MenuController()
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdated")
    static let menuDataUpdatedNotification = Notification.Name("MenuController.menuDataUpdated")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
        }
    }
    
    
    private var itemsById = [Int:MenuItem]()
    private var itemsByCategory = [String:[MenuItem]]()
    
    func item(withID itemID: Int) -> MenuItem? {
        return itemsById[itemID]
    }
    
    func items(forCategory category: String) -> [MenuItem]? {
        return itemsByCategory[category]
    }
    
    var categories : [String] {
        get {
            return itemsByCategory.keys.sorted()
        }
    }
    
    private func process(_ items: [MenuItem]) {
        itemsById.removeAll()
        itemsByCategory.removeAll()
        
        for item in items {
            itemsById[item.id] = item
            itemsByCategory[item.category, default : []].append(item)
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: MenuController.menuDataUpdatedNotification, object: nil)
        }
        
    }
    
    
    func loadRemoteData() {
        let initialURL = baseURL.appendingPathComponent("menu")
        let components = URLComponents(url: initialURL, resolvingAgainstBaseURL: true)!
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { (data, _, _) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                self.process(menuItems.items)
            }
        }
        task.resume()
    }
    
    
    func loadItems() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let menuItemsFileURL = documentDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: menuItemsFileURL) else {return}
        let items = (try? JSONDecoder().decode([MenuItem].self, from: data)) ?? []
        process(items)
    }
    
    func saveItems() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let menuItemsFileURL = documentDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
        let items = Array(itemsById.values)
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: menuItemsFileURL)
        }
        
    }
    
    func loadOrder() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let orderFileURL = documentDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: orderFileURL) else {return}
        order = (try? JSONDecoder().decode(Order.self, from: data)) ?? Order(menuItems: [])
    }
    
    func saveOrder() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let orderFileURL = documentDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        if let data = try? JSONEncoder().encode(order) {
            try? data.write(to: orderFileURL)
        }
    }
    
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Int?) -> Void) {
        let orderCategory = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderCategory)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data:[String:[Int]] = ["menuIds":menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, request, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            }
        }
        task.resume()
    }
    
    func fetchImage (url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
            
        }
        task.resume()
    }
    
    
   //    func fetchCategories(completion: @escaping ([String]?) -> Void) {
    //        let categoryURL = baseURL.appendingPathComponent("categories")
    //        let task = URLSession.shared.dataTask(with: categoryURL) { (data, response, error) in
    //            if let data = data {
    //                let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any]
    //                let categories = jsonData?["categories"] as? [String]
    //                completion(categories)
    //            }
    //        }
    //        task.resume()
    //    }
    //
    //    func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
    //        let initialMenuURL = baseURL.appendingPathComponent("menu")
    //        var components = URLComponents.init(url: initialMenuURL, resolvingAgainstBaseURL: true)!
    //        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
    //        let menuURL = components.url!
    //        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
    //            let jsonDecoder = JSONDecoder()
    //            if let data = data,
    //                let fetchedData = try? jsonDecoder.decode(MenuItems.self, from: data) {
    //                completion(fetchedData.items)
    //            } else {
    //                completion(nil)
    //            }
    //
    //
    //        }
    //        task.resume()
    //    }
    //
}
