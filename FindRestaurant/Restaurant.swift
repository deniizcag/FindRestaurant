//
//  Restaurant.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 22.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import Foundation

class Location:Decodable {
    var address: String
    var locality: String
    var latitude: String
    var longitude: String
    
    
}
class Restaurants: Decodable {
    var nearbyRestaurants: [resObject] {
        didSet  {
            print("ye")
        }
    }
  
}

class Rating:Decodable {
    var aggregateRating: String
    var ratingText: String

    
}
class resObject: Decodable {
    var restaurant:Restaurant
}

class Restaurant: Decodable {
    
    var url: String
    var name: String
    var averageCostForTwo: Int
    var currency: String
    var cuisines: String
    var userRating: Rating
    var location: Location
    
    
    

}
