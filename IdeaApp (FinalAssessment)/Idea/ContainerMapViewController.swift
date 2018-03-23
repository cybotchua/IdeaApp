//
//  ContainerMapViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import MapKit

class ContainerMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//    }
    
    func setUpMapView() {
        let initialLocation = CLLocation(latitude: 3.1349, longitude: 101.6299)
        centerMapOnLocation(location: initialLocation)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}
