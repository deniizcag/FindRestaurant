//
//  RestaurantDetailViewController.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 29.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cuisines: UILabel!
    @IBOutlet weak var ratingPoint: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var ratingText: UILabel!
    
    var restaurant: Restaurant!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print(restaurant.name)
        setUI()
    }
    
    func setUI() {
        
        name.text = restaurant.name
        address.text = restaurant.location.address
        cuisines.text = restaurant.cuisines
        cost.text = restaurant.currency +  String(restaurant.averageCostForTwo)
        ratingText.text = restaurant.userRating.ratingText + ","
        ratingPoint.text = restaurant.userRating.aggregateRating
        
        
    }
    
    
}
