    //
//  RestaurantCell.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 23.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import UIKit
    
    protocol RouteToRestaurantDelegate {
        func goToRestaurant(restaurant: Restaurant)
    }

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    var delegate: RouteToRestaurantDelegate!
    var restaurant: Restaurant!
    @IBOutlet weak var goButton: UIButton!
    override func awakeFromNib() {
       super.awakeFromNib()
       //custom logic goes here
    }

    @IBAction func goButtonPressed(_ sender: Any) {
        delegate.goToRestaurant(restaurant: restaurant)
        
    }
    
    func set(restaurant: Restaurant,distance: Double) {
        self.restaurant = restaurant
        print(restaurant.name)
        print(restaurant.location.locality)
        name.text = restaurant.name
        address.text = restaurant.location.locality
        distanceLabel.text = String(format: "%.f",distance) + " m"
        minuteLabel.text = String(format: "%.1f",((distance / 1000) / 3.1) * 60 ) + " min"
    }
    
    
}
