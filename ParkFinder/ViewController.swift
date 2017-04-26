//
//  ViewController.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 4/3/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import UIKit
import MapKit

//custom notification
let showParkNotification = NSNotification.Name("showParkNotification")


class ViewController: UIViewController,MKMapViewDelegate {

    //MARK: - Ivars -
    @IBOutlet weak var mapView: MKMapView!
    let metersPerMile:Double = 1609.344
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        loadData()
        
        //listen for notification
        let nc = NotificationCenter.default
            //register tgis object as an observer
        nc.addObserver(self, selector: #selector(showMap), name: showParkNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Helper Methods -
    //parse the data and xreate multi instances of StatePark
    func parse(json:JSON)
    {
        // parse the JSON
        //pull the array of dictionaries out of the JSON
        let array = json["parks"].arrayValue
        
        //create and initialize an array to hold our StatePark instances
        var parks = [StatePark]()
        
        //loop through array
        for d in array{
            var name = d["name"].stringValue
            if name.isEmpty{
                name = "No Title found"
            }
            
            //no optional binding necessary!
            let latitude = d["latitude"].floatValue
            let longitude = d["longitude"].floatValue
            
            var url = d["url"].stringValue
            if url.isEmpty{
                url = "No URL found"
            }
            var describe = d["description"].stringValue
            if describe.isEmpty{
                describe = "No Description found"
            }
            
            let park = StatePark(name: name, latitude: latitude, longitude: longitude, url: url,describe: describe)
            parks.append(park)
            
            //SwiftyJSON returns "" or 0 if the property doesnt exist
            /*let fakeProperty:Int = d["xyzpdq"].intValue as Int
            print("fakeProperty=\(fakeProperty)") // 0*/
        }
        //sort the parks array alphabetically
        parks.sort { $0.title! < $1.title! }
        ParkData.sharedData.parks = parks
        
        //add pins on the map for the parks
        mapView.addAnnotations(ParkData.sharedData.parks)
        
        //center point
        let center = StatePark(name: "Center of NYS", latitude: 43.0057, longitude: -76.2322, url: "", describe: "Center of NYS")
        
        //zoomed in, zoom into our view or section of the map
        let myRegion = MKCoordinateRegionMakeWithDistance(center.coordinate, metersPerMile * 175, metersPerMile * 175)
        mapView.setRegion(myRegion, animated: true)
        
        //to start out with the first park selected
        mapView.selectAnnotation(parks[0], animated: true)
    }
    
    func loadData()
    {
        //load json data and convert into array of dictionaries
        /*if let path = Bundle.main.url(forResource: "parks", withExtension: "js")
         {
         //because Data(contentsOf) throws exceptions, we need try!
         let data = try! Data(contentsOf: path, options:[])
         //the JSON() constructor is from SwiftyJSON
         let json = JSON(data:data)
         print("json = \(json)")
         }
         else
         {
         print("could not find parks.js!")
         }*/
        //more robust version of JSON loading
        guard let path = Bundle.main.url(forResource: "parks", withExtension: "js") else {
            print("Error: could not find parks.js!")
            return
        }
        
        do{ //swifts verison of try catch
            let data = try Data(contentsOf: path, options:[])
            let json = JSON(data:data)
            if json != JSON.null
            {
                //call func
                parse(json: json)
            }
            else
            {
                print("json is null")
            }
        } catch {
            print("Error: could not initialize the Data() object!")
        }
    }
    
    
    //MARK: - MKMapViewDelegate Protocol Methods -
    //tapped
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title = view.annotation?.title ?? "No title found"
        print("Tapped \(title!)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let annotation = annotation as? StatePark else{
            print("This annotation isnt a StatePark")
            return nil
        }
        
        let identifier = "pinIdemtifier"
        let view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            //reuse an existing View
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else
        {
            //make a new view and put a button in it
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        
        return view
    }
    //info button in annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? StatePark else{
            print("this annotation isnt a StatePark")
            return
        }
        //when info button in annotations is pressed go to park website
        print("Tapped info button for \(annotation.description)")
        if let url = URL(string: (annotation.website)!){
            UIApplication.shared.open(
                url,
                options:[:],
                completionHandler: {
                    (success) in
                    print("Open \(url.description) - success = \(success)")
            }
            )
        }
    }
    
    // MARK: - Notifications -
    func showMap(notification: Notification)
    {
        //change to map tab - this works as long as the map is on the first tab
        tabBarController?.selectedIndex = 0
        
        //select the park annotation that was passed over
        if let park = notification.userInfo!["park"] as? MKAnnotation
        {
            mapView.selectAnnotation(park, animated: true)
        }
    }
    
    //MARK: - Cleanup -
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

