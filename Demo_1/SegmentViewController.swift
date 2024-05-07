//
//  SegmentViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit

class SegmentViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var colorPellet: UIView!
    @IBOutlet weak var mapView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.setTitle("Map View", forSegmentAt: 0)
        segment.setTitle("Color Pellet", forSegmentAt: 1)
        mapView.isHidden = false
        colorPellet.isHidden = true
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch segment.selectedSegmentIndex{
        case 0:
            mapView.isHidden = false
            colorPellet.isHidden = true
        case 1:
            mapView.isHidden = true
            colorPellet.isHidden = false
        default:
            break
        }
    }
    
}
