//
//  GoogleMapViewController.swift
//  Demo_1
//
//  Created by iMac on 22/03/24.
//

import UIKit
import GoogleMaps
import GooglePlaces


let googleMap = UIStoryboard(name: "googlemap", bundle: nil)


class GoogleMapViewController: UIViewController,UITextFieldDelegate{
    

    @IBOutlet weak var currentLocation: UIButton!
    
    @IBOutlet weak var sourceLocationField: UITextField!
    @IBOutlet weak var searchRouteButton: UIButton!
    
    @IBOutlet weak var destinationLocationField: UITextField!
    
    @IBOutlet weak var displayMap: UIView!
    var locationManager: CLLocationManager!
    var marker: GMSMarker!
    var mapView: GMSMapView!
    
    var currentLattitude = 0.0
    var currentLongitude = 0.0
    
    var sourceLattitude = 0.0
    var sourceLongitude = 0.0
    
    var destinationLattitude = 0.0
    var destinationLongitude = 0.0
    
    var isSourceTapped = false
    var isDestinationTapped = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: 21.2337646484375, longitude: 72.86432092693671, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.displayMap.addSubview(mapView)
        
        mapView.isMyLocationEnabled = true
        
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 21.2337646484375, longitude: 72.86432092693671)
        marker.title = "Mota Varachha"
        marker.snippet = "Surat"
        marker.map = mapView
        marker.isDraggable = true
        mapView.delegate = self
        
        sourceLocationField.delegate = self
        destinationLocationField.delegate = self
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func sourceTapped(_ sender: Any) {
        isSourceTapped = true
        isDestinationTapped = false
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true,completion: nil)
    }
    
    @IBAction func destinationTapped(_ sender: Any) {
        isSourceTapped = false
        isDestinationTapped = true
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true,completion: nil)
    }
    
    func getAddress(coordinates:CLLocationCoordinate2D,completionHandler:@escaping ([String]) -> Void){
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinates){ response,error in
        if let error = error {
         print("~~> get address error \(error)")
         return
        }
        guard let address = response?.firstResult(),let lines = address.lines else { return }
        completionHandler(lines)
      }
   }
    
    @IBAction func onCurrentLocationTapped(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        switch CLLocationManager.authorizationStatus(){
        case .restricted, .denied:
                  let alertController = UIAlertController (title: "Turn on location services from settings for current location", message: nil, preferredStyle: .alert)

                  let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                          return
                      }

                      if UIApplication.shared.canOpenURL(settingsUrl) {
                          UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                              print("Settings opened: \(success)") // Prints true
                          })
                      }
                  }
                  alertController.addAction(settingsAction)
                  let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                  alertController.addAction(cancelAction)

                  present(alertController, animated: true, completion: nil)
                  
              default:
            let camera = GMSCameraPosition.camera(withLatitude: 21.1702, longitude: 72.8311, zoom: 12.0)
            mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            self.displayMap.addSubview(mapView)
            
            mapView.isMyLocationEnabled = true
            
            marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: currentLattitude, longitude: currentLongitude)
            marker.title = "Mota Varachha"
            marker.snippet = "Surat"
            marker.map = mapView
            marker.isDraggable = true
            mapView.delegate = self
        }
    }
    
    @IBAction func onSearchRouteTapped(_ sender: Any) {
        if sourceLocationField.hasText || destinationLocationField.hasText{
            getRoutes()
    
        }else{
            customAlert(title: "Please select source and destination location", message: "")
        }
        
    }
    
    func setMarkers(){
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLattitude, longitude: sourceLongitude)
        sourceMarker.map = mapView
        sourceMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        getAddress(coordinates: CLLocationCoordinate2D(latitude: sourceLattitude, longitude: sourceLongitude)){
            response in
            let line = response.joined(separator: "\n")
            sourceMarker.title = line
        }
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: destinationLattitude, longitude: destinationLongitude)
        destinationMarker.map = mapView
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        getAddress(coordinates: CLLocationCoordinate2D(latitude: destinationLattitude, longitude: destinationLongitude)){
            response in
            let line = response.joined(separator: "\n")
            destinationMarker.title = line
        }
    }
    
    func drawPath(from polyStr: String){
          
          let path = GMSPath(fromEncodedPath: polyStr)
          let polyline = GMSPolyline(path: path)
          polyline.strokeWidth = 5.0
          polyline.map = mapView


          let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: currentLattitude, longitude: currentLongitude), coordinate: CLLocationCoordinate2D(latitude: destinationLattitude, longitude: destinationLongitude)))
          mapView.moveCamera(cameraUpdate)
          let currentZoom = mapView.camera.zoom
          mapView.animate(toZoom: currentZoom - 1.4)
      }
    func getRoutes(){
        
        let origin = "\(sourceLattitude),\(sourceLongitude)"
        let destination = "\(destinationLattitude),\(destinationLongitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM"
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!,completionHandler: {
            (data,response,error) in
            if (error != nil){
                print("get routes error :~~ \(String(describing: error))")
            }else{
                
                         do {
                             if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                                 self.mapView.clear()
                                self.setMarkers()
                                 guard let routes = json["routes"] as? [[String: Any]], !routes.isEmpty else { return }
                                 if let route = routes.first {
                                     guard let legs = route["legs"] as? [[String: Any]] else { return }
                                     
                                     for leg in legs {
                                         if let steps = leg["steps"] as? [[String: Any]] {
                                             for step in steps {
                                                 if let polyline = step["polyline"] as? [String: Any],
                                                    let polylineString = polyline["points"] as? String {
                                                     DispatchQueue.main.async {
                                                         let path = GMSPath(fromEncodedPath: polylineString)
                                                         let polyline = GMSPolyline(path: path)
                                                         polyline.strokeWidth = 6
                                                        polyline.strokeColor = .blue
                                                        polyline.map = self.mapView

                                                     }
                                                 }
                                             }
                                         }
                                     }
                                 }
                             }
                         } catch {
                             print("Error parsing JSON: \(error)")
                         }
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
//                       let routes = json["routes"] as? [[String: Any]] {
//                        print(routes)
//                        for route in routes {
//                            if let routeOverviewPolyline = route["overview_polyline"] as? [String: Any],
//                               let points = routeOverviewPolyline["points"] as? String,
//                               
//                               let path = GMSPath(fromEncodedPath: points) {
//                           
//                                let polyline = GMSPolyline(path: path)
//                                polyline.strokeWidth = 6
//                                polyline.strokeColor = .blue
//                                polyline.map = self.mapView
//                           
//                                let bounds = GMSCoordinateBounds(path: path)
//                                DispatchQueue.main.async {
//                               self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
//                                }
//                            }
//                        }
//                    }
//                } catch {
//                    print("Error parsing JSON: \(error)")
//                }

            }
        }).resume()
        
    }
    func drawPolyline(encodedString: String) {
           guard let path = GMSPath(fromEncodedPath: encodedString) else { return }
           let polyline = GMSPolyline(path: path)
           polyline.strokeWidth = 4.0
           polyline.strokeColor = .blue
           polyline.map = mapView
           
           let bounds = GMSCoordinateBounds(path: path)
           mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
       }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
}
extension GoogleMapViewController:CLLocationManagerDelegate,GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
                
            case .restricted, .denied:
                print("permisson denied")
                mapView.clear()
                
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let location = locations.last!
           
           currentLattitude = location.coordinate.latitude
           currentLongitude = location.coordinate.longitude
           
           let camera = GMSCameraPosition.camera(withLatitude: currentLattitude, longitude: currentLongitude, zoom: 14.0)
           mapView.animate(to: camera)
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
       }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapView.clear()
             self.marker = GMSMarker()
             self.marker.map = mapView
             self.marker.position = place.coordinate
             self.mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14.0)
             marker.title = place.name
             
             
             if isSourceTapped {
                 sourceLattitude = place.coordinate.latitude
                 sourceLongitude = place.coordinate.longitude
                 sourceLocationField.text = place.formattedAddress
             } else {
                 destinationLattitude = place.coordinate.latitude
                 destinationLongitude = place.coordinate.longitude
                 destinationLocationField.text = place.name
             }

             dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        sourceLattitude = marker.position.latitude
        sourceLongitude = marker.position.longitude
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        getAddress(coordinates: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)){
            response in
            self.marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let line = response.joined(separator: "\n")
            self.marker.title = line
            
            self.destinationLattitude = self.marker.position.latitude
            self.destinationLongitude = self.marker.position.longitude
            
            self.getRoutes()
        }
    }
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
