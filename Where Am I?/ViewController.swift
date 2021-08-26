//
//  ViewController.swift
//  Where Am I?
//
//  Created by Gabriel on 24/08/21.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var Map: MKMapView!
    var managerLocations = CLLocationManager()
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var andressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managerLocations.delegate = self
        managerLocations.desiredAccuracy = kCLLocationAccuracyBest
        managerLocations.requestWhenInUseAuthorization()
        managerLocations.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizationUser = locations.last!
        let longitude = localizationUser.coordinate.longitude
        let latitude = localizationUser.coordinate.latitude
        let speed = localizationUser.speed
        
        
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
        if speed > 0 {
        speedLabel.text = String(speed)
        }
        let deltaLat:CLLocationDegrees = 0.01
        let deltaLong:CLLocationDegrees = 0.01
        
        let localization: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let showArea: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: localization, span: showArea)
        
        Map.setRegion(region, animated: true)
        
        
        CLGeocoder().reverseGeocodeLocation(localizationUser) { (detailsLocation, error) in
            if error == nil{
                if let localRecovery = detailsLocation?.first{
                    var thoroughfare = ""
                    if localRecovery.thoroughfare != nil {thoroughfare = localRecovery.thoroughfare!}
                    var subThoroughfare = ""
                    if localRecovery.thoroughfare != nil {subThoroughfare = localRecovery.subThoroughfare!}
                    var locality = ""
                    if localRecovery.locality != nil {locality = localRecovery.locality!}
                    var country = ""
                    if localRecovery.country != nil {country = localRecovery.country!}
                    
                    print(thoroughfare + subThoroughfare, locality, country)
                    self.andressLabel.text = thoroughfare + " - " + subThoroughfare + " / " + locality + " / " + country
                }
            }else{
                let alertController = UIAlertController(title: "Error", message: "Not possible recovery the location", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(ok)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            let alert = UIAlertController(title: "Message Of Permission", message: "you need authorized GPS", preferredStyle: .alert)
            
            let configuration = UIAlertAction(title: "Confirm", style: .default) { AlertConfiguration in
                
                if let config = NSURL(string: UIApplication.openSettingsURLString){
                    
                    UIApplication.shared.open(config as URL)
                    
                }
            }
            
            let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addAction(configuration)
            alert.addAction(Cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }


}

