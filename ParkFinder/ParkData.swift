//
//  ParkData.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 4/4/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import Foundation

class ParkData
{
    static let sharedData = ParkData()
    
    var parks = [StatePark]()
    
    var favorites = [StatePark]() //for favorites table
    
    private init(){}
}
