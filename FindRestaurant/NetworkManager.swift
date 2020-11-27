//
//  NetworkManager.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 25.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    //at=51&lon=-0.1
    
    func getRestaurants(latitude: String,longitude: String,completed: @escaping ([Restaurant]?) -> Void) {
        let urlString = "https://developers.zomato.com/api/v2.1/geocode?" + "lat="+latitude + "&lon=" + longitude
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        
        request.addValue("04dc87b89526e95ab973d01ab9fe7835", forHTTPHeaderField: "user-key")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else {
                return
            }
            if let _ = error {
                return
            }
            guard let data = data else {
                return
            }
            
            
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let res = try! decoder.decode(Restaurants.self, from: data)
            var restaurants = [Restaurant]()
            
            for restaurant in res.nearbyRestaurants {
                restaurants.append(restaurant.restaurant)
            }
            completed(restaurants)
            
            
        }.resume()
        
    }
}

