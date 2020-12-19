//
//  Annotation.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 24.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import Foundation
import MapKit

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String , subtitle:String , coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
