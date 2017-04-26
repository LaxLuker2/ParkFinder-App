//
//  StatePark.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 4/3/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import Foundation
import MapKit //need these to to add pins to the map same with MKAnnotation protocol
import CoreLocation

public class StatePark:NSObject,MKAnnotation,NSCoding
{
    private var name:String
    private var latitude:Float
    private var longitude:Float
    private var url:String
    private var describe:String
    
    init(name:String,latitude:Float,longitude:Float,url:String,describe:String)
    {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
        self.describe = describe
    }
    
    public var Description: String
    {
        return describe
    }
    
    //for pins
    public var coordinate: CLLocationCoordinate2D{ //a struct w/ lat and long properities
        return CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
    }
    
    //for title and subtitles
    //Computed properties
    //These are optional in the MKAnnotation protocol, which means that the map will call them if they exist
    public var title:String?
    {
        return name
    }
    
    public var website:String?
    {
        return url
    }
    
    public var subtitle: String?
    {
        return "I ❤️ NY"
    }
    
    //to load the object
    required public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        url = aDecoder.decodeObject(forKey: "url") as! String
        latitude = aDecoder.decodeFloat(forKey: "latitude")
        longitude = aDecoder.decodeFloat(forKey: "longitude")
        describe = aDecoder.decodeObject(forKey: "description") as! String
        print("init with coder called on \(name)")
    }
    
    //methode that conforms to the NSCoding protocol that will prepare the object to be saved to disk
    public func encode(with aCoder: NSCoder)
    {
        //saving both of the bookmark ivars
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(describe, forKey: "description")
        print("encode with coder called on \(name)")
    }
}
