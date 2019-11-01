//
//  MissionUpdateViewController.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class MissionUpdateViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var lblDistance: UILabel!
    var agent : Agent?
    private var locationManager: CLLocationManager!
    var image : UIImage?
    var current : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
       // let annotation = MKPointAnnotation()
        //annotation.coordinate = coordinate
       // mapView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
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
            
            let distanceInMeters = CLLocation(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!).distance(from:self.current!) // result is in meters
            self.lblDistance.text = "\(String(format:"%.4f", distanceInMeters/1000))km"

        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mail(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([])
        composeVC.setSubject("Message Subject")
        composeVC.setMessageBody("Message content.", isHTML: false)
        if let composeImg = self.image {
        composeVC.addAttachmentData(UIImageJPEGRepresentation(composeImg, CGFloat(1.0))!, mimeType: "Image/jpeg", fileName: "test.jpeg")
            // Present the view controller modally.
        }
        self.present(composeVC, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "camera") {
            let vc = segue.destination as! CameraViewController
            vc.didCpture = {(image) in
                self.image = image
                self.mail(UIButton())
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
    
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
            self.mapView.setRegion(region, animated: true)
            self.current = CLLocation(latitude: center.latitude, longitude: center.longitude)
             let annotation = MKPointAnnotation()
             annotation.coordinate = center
             mapView.addAnnotation(annotation)
        }
    }


}
