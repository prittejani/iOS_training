//
//  SearchLocationViewController.swift
//  Demo_1
//
//  Created by iMac on 10/04/24.
//

import UIKit
import GooglePlaces
import GoogleMaps

class SearchLocationViewController: UIViewController,UITextFieldDelegate, GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate{
    
    @IBOutlet weak var sourceTextField: UITextField!
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var showMap: UIView!
    
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.delegate = self
        showMap.addSubview(mapView)
        
        sourceTextField.delegate = self
        destinationTextField.delegate = self
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func drawPath(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let origin = "\(source.latitude),\(source.longitude)"
        let dest = "\(destination.latitude),\(destination.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(dest)&mode=driving&key=AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(DirectionsResult.self, from: data)
                DispatchQueue.main.async {
                    print(result)
                    self.showPath(with: result)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    func showPath(with directionsResult: DirectionsResult) {
        guard let route = directionsResult.routes.first else { return }
        
        for leg in route.legs {
            let path = GMSMutablePath(fromEncodedPath: leg.points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.strokeColor = .blue
            polyline.map = mapView
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
          dismiss(animated: true, completion: nil)
          
          if let textField = sourceTextField, textField.isEditing {
              print(place.name)
              textField.text = place.name
          } else if let textField = destinationTextField, textField.isEditing {
              textField.text = place.name
          }
      }
      
      func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
          print("Error: ", error.localizedDescription)
      }
      
      func wasCancelled(_ viewController: GMSAutocompleteViewController) {
          dismiss(animated: true, completion: nil)
      }
}
struct DirectionsResult: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let legs: [Leg]
}

struct Leg: Codable {
    let points: String
}
