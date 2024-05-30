//
//  MapViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    let location = CLLocation(latitude: 21.2408, longitude:72.8806)
    let region_radious = 1000
    override func viewDidLoad() {
        super.viewDidLoad()

        centreMap(location: location)
    }
    func centreMap(location: CLLocation){
            let region = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: CLLocationDistance(region_radious), longitudinalMeters: CLLocationDistance(region_radious))
            map.setRegion(region, animated: true)
        
        }
}
