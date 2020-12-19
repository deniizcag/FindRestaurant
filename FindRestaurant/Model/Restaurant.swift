//
//  Restaurant.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 22.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import Foundation

struct Location:Decodable {
    var address: String
    var locality: String
    var latitude: String
    var longitude: String
    
    
}
struct Restaurants: Decodable {
    var nearbyRestaurants: [resObject] {
        didSet  {
            print("ye")
        }
    }
  
}

struct Rating:Decodable {
    var aggregateRating: String
    var ratingText: String

    
}
struct resObject: Decodable {
    var restaurant:Restaurant
}

struct Restaurant: Decodable {
    
    var url: String
    var name: String
    var averageCostForTwo: Int
    var currency: String
    var cuisines: String
    var userRating: Rating
    var location: Location
    var featuredImage: String
    
    

}
