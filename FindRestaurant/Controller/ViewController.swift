//
//  ViewController.swift
//  FindRestaurant
//
//  Created by DenizCagilligecit on 22.11.2020.
//  Copyright © 2020 Deniz Cagilligecit. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate,RouteToRestaurantDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var selectedRestaurant: Restaurant!
    
    var restaurants =  [Restaurant]()
    var distances = [CLLocationDistance] ()
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = configureLocationManager() {
            fetchRestaurants(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        else {
        }
        configuretableView()
        
    }
    
    func configureLocationManager() -> CLLocation? {
        
        mapView.delegate = self
        locationManager.delegate = self
        let location = checkLocationServices()
        return location
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = restaurants[indexPath.row]
          performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    func configuretableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func fetchRestaurants(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DispatchQueue.main.async {
            NetworkManager.shared.getRestaurants(latitude: String(latitude), longitude: String(longitude)) { (res) in
                if let res = res {
                    DispatchQueue.main.async {
                        self.restaurants = res
                        self.tableView.reloadData()
                        self.addPinToRestaurants(restaurants: self.restaurants)
                        self.distances = self.getDistances(restaurants: self.restaurants)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "There is no available restaurant nearby you.")

                    }
                }
            }
        }
        
    }
    
    func showAlert(message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }
    func checkLocationServices() ->CLLocation? {
        
        if CLLocationManager.locationServicesEnabled() {
            
            checkLocationAuthorization()
        } else {
            showAlert(message: "Please enable your location services!")
        }
        return locationManager.location
    }
    
    func checkLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.showsUserLocation = true
            centreOnUserLocation()
        }
        else {
            showAlert(message: "Please enable your location services!")
        }
    }
    
    func centreOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addPinToRestaurants(restaurants: [Restaurant]) {
        for restaurant in restaurants {
            
            let lat = CLLocationDegrees(restaurant.location.latitude)!
            let lon = CLLocationDegrees(restaurant.location.longitude)!
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let annotation = AnnotationPin(title: restaurant.name, subtitle: restaurant.location.locality, coordinate: coordinate)
            
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is AnnotationPin else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            let pinImage = UIImage(named: "res")
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView?.layer.cornerRadius = 30
            annotationView?.image = resizedImage
            annotationView!.canShowCallout = true
            
            annotationView!.annotation = annotation
            
            
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            
        }
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue başlamadan önce çalışacak fonksiyon
        if segue.identifier == "goToDetail"{
            print("klljlj")
            // değişken gibi işleme tabi tutmak için yapıldı.
            let destinationVC = segue.destination as! RestaurantDetailViewController // artık bu yapıya ait tüm özelliklere erişim mevcut hale geldi.
            destinationVC.restaurant = self.selectedRestaurant
            // ikinci ekrandaki name değişkeni ile birinci ekrandaki username değeri eşleştirildi.
        }}
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for restaurant in restaurants {
            if restaurant.name == view.annotation?.title {
                self.selectedRestaurant = restaurant
                performSegue(withIdentifier: "goToDetail", sender: self)
                break
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5
        return renderer
    }
    
    func getDistances(restaurants: [Restaurant]) -> [CLLocationDistance] {
        var distances = [CLLocationDistance]()
        print("getting distances")
        for restaurant in restaurants {
            let resLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(restaurant.location.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(restaurant.location.longitude)!)!)
            let distance = locationManager.location?.distance(from: resLocation)
            distances.append(distance!)
        }
        
        
        return distances
        
    }
}

extension ViewController {
    func goToRestaurant(restaurant: Restaurant) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate, addressDictionary: nil))
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(restaurant.location.latitude)!), longitude: CLLocationDegrees(Double(restaurant.location.longitude)!)), addressDictionary: nil))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        mapView.removeOverlays(mapView.overlays)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                let mapEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 300, right: 40)
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: mapEdgeInsets, animated: true)
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCellID") as! RestaurantCell
        let restaurant = restaurants[indexPath.row]
        let distance   = distances[indexPath.row]
        cell.set(restaurant: restaurant,distance: distance)
        cell.delegate = self
        return cell
        
    }
    
    
}
extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}
