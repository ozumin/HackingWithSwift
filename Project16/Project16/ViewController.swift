//
//  ViewController.swift
//  Project16
//
//  Created by Mizuo Nagayama on 2021/04/13.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    let mapTypes = ["Standard", "Satellite", "Hybrid", "SatelliteFlyover", "HybridFlyover", "MutedStandard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.1275), info: "Home of the 2012 summer olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called city of light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")

        mapView.addAnnotations([london, oslo, paris, rome, washington])

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pickMapType))
    }

    @objc func pickMapType() {
        let ac = UIAlertController(title: "Pick Map Type", message: nil, preferredStyle: .alert)
        for type in mapTypes {
            ac.addAction(UIAlertAction(title: type, style: .default, handler: setMapType))
        }
        present(ac, animated: true)
    }

    func setMapType(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }

        switch actionTitle {
        case "Standard": mapView.mapType = .standard
        case "Satellite": mapView.mapType = .satellite
        case "Hybrid": mapView.mapType = .hybrid
        case "SatelliteFlyover": mapView.mapType = .satelliteFlyover
        case "HybridFlyover": mapView.mapType = .hybridFlyover
        case "MutedStandard": mapView.mapType = .mutedStandard
        default: mapView.mapType = .standard
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        if let view = annotationView as? MKPinAnnotationView {
            view.pinTintColor = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1)
            return view
        } else {
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

