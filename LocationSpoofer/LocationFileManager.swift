//
//  LocationSpooferManager.swift
//  LocationSpoofer
//
//  Created by Richard Ondrejka on 09.12.2021.
//  Copyright © 2021 Richard Ondrejka. All rights reserved.
//

import Foundation

class LocationFileManager{
    
    var locationDict : [String : Double]
    var locationFilePath : String
    
    init(){
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString
        
        locationFilePath = libraryPath.appendingPathComponent("cz.muni.locationspoofer.plist")
        
        // Check whether location file already exists
        if (!FileManager.default.fileExists(atPath: locationFilePath)){
            
            // Assigns default location as location of Faculty of Informatics at Masaryk University in Brno, Czech Republic
            
            locationDict = [
            "longitude": 16.599215,
            "latitude": 49.210058,
            "altitude": 249,
            "enabled": 0
            ]
            
            updateLocationFile()
            
        } else {
            
            // Load location from file
            let locationDictNS = NSDictionary(contentsOfFile: locationFilePath)
            locationDict = (locationDictNS as? [String : Double])!
        }
    }

    
    // Write location into location file
    func updateLocationFile(){
       let locationNSDict = locationDict as NSDictionary
        locationNSDict.write(toFile: locationFilePath, atomically: true)
    }
}
