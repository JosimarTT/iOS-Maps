//
//  ViewController.swift
//  PokemonGo
//
//  Created by Josimar Javier Tantahuilca Torres on 17/05/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    var contActualizaciones = 0
    var pokemons: [Pokemon] = []
    
    var ubicacion = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ubicacion.delegate = self
        pokemons = obtenerPokemons()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.delegate = self
            mapView.showsUserLocation = true
            ubicacion.startUpdatingLocation()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                if let coord = self.ubicacion.location?.coordinate {
                    let pin = MKPointAnnotation()
                    pin.coordinate = coord
                    let randomLat = (Double(arc4random_uniform(200)) - 100) / 5000
                    let randomLon = (Double(arc4random_uniform(200)) - 100) / 5000
                    pin.coordinate.longitude += randomLon
                    pin.coordinate.latitude += randomLat
                    self.mapView.addAnnotation(pin)
                }
            })
        } else {
           ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contActualizaciones < 1 {
            let region = MKCoordinateRegionMakeWithDistance(ubicacion.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        } else {
            ubicacion.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named: "player")
            var frame = pinView.frame
            frame.size.height = 25
            frame.size.width = 25
            pinView.frame = frame
            
            return pinView
        }
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.image = UIImage(named: "mew")
        
        var frame = pinView.frame
        frame.size.height = 25
        frame.size.width = 25
        pinView.frame = frame
        
        return pinView
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

