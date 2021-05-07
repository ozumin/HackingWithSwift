//
//  ViewController.swift
//  Project22
//
//  Created by Mizuo Nagayama on 2021/05/07.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }

    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1){
            switch distance {
            case .far:
                self.view.backgroundColor = .systemBlue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .systemOrange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .systemRed
                self.distanceReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .systemGray
                self.distanceReading.text = "UNKNOWN"

            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}

