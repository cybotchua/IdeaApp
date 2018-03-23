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
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUpMapView(notification:)), name: NSNotification.Name(rawValue: "Pass Selected Idea"), object: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinView = MKPinAnnotationView.init()
        pinView.pinTintColor = UIColor.red
        
        pinView.canShowCallout = true
        
        return pinView
    }
    
    @objc func setUpMapView(notification: NSNotification) {
        mapView.delegate = self
        
        guard let selectedIdea = notification.userInfo?["Selected Idea"] as? Idea else {return}
        
        let latitude = selectedIdea.latitude
        let longitude = selectedIdea.longitude
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
        
        let annot = MKPointAnnotation.init()
        annot.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        annot.title = selectedIdea.title
        annot.subtitle = selectedIdea.location
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annot)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}
