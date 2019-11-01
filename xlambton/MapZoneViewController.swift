//
//  MapZoneViewController.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import UIKit
import MapKit

class MapZoneViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var agent : Agent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    mapView.delegate = self
    
        
      
        
        var country = "India"
        if let mis = agent?.mission {
            if mis == "R"{
                country = "Russia"
            }
            else if mis == "P"{
                country = "Portugal"
            }else{
                country = "India"
            }
        }
        
        self.coordinates(forAddress:country) { (coordinates) in
            let info2 = CustomPointAnnotation()
            info2.coordinate = coordinates!
            info2.title = "Info2"
            info2.subtitle = "Subtitle"
            
            if let mis = self.agent?.mission {
                if mis == "R"{
                    info2.imageName = "blueDot"
                }
                else if mis == "P"{
                    info2.imageName = "greenDot"
                }else{
                    info2.imageName = "redDot"
                }
            }
            self.mapView.addAnnotation(info2)

        }
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        return anView
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mission") {
            let vc = segue.destination as! MissionUpdateViewController
            vc.agent = agent
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

    @IBAction func msg(_ sender: Any) {
        self.performSegue(withIdentifier: "mission", sender: self)
    }
    
}


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
