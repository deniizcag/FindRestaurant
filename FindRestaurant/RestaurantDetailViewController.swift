//
//  RestaurantDetailViewController.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 29.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import UIKit
import SafariServices

class RestaurantDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailButton: UIButton!
    
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
        getImage()
        setUI()
    }
    
    @IBAction func detailButtonPressed(_ sender: Any) {
        
        if let url = URL(string: restaurant.url) {
            print(url)
              let config = SFSafariViewController.Configuration()
                  config.entersReaderIfAvailable = true

                  let vc = SFSafariViewController(url: url, configuration: config)
                  present(vc, animated: true)
        }
    }
    
    
    func setUI() {

        name.text = restaurant.name
        address.text = restaurant.location.address
        cuisines.text = restaurant.cuisines
        cost.text = restaurant.currency +  String(restaurant.averageCostForTwo)
        ratingText.text = restaurant.userRating.ratingText + ","
        ratingPoint.text = restaurant.userRating.aggregateRating
        
        if !isUrlValid(stringUrl: restaurant.url) {
            detailButton.isHidden = true
        }
       
       
    }
    func isUrlValid(stringUrl: String) -> Bool {
        return URL(string: stringUrl) != nil ? true : false
    }
    
    func getImage() {
        
        NetworkManager.shared.getImage(url: restaurant.featuredImage) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
    }
    
    
}
