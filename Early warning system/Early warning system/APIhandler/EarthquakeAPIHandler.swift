//
//  EarthquakeAPIHandler.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/10/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import Foundation

let earthUrlStr = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_day.geojson"
class Earthquake: NSObject{
    static let shared = Earthquake()
    override private init(){}
    
    func getEarthData(completionHandler: @escaping(_ earthquakeLocArray:[EarthquakeInfo]?,_ error:Error?)->Void){
        let url = URL(string: earthUrlStr)
        URLSession.shared.dataTask(with: url!){ (data,response, error) in
            if(error == nil){
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                        let earthquakJson: [[String:Any]] = jsonResult["features"] as! [[String : Any]]
                        var earthArray:[EarthquakeInfo] = []
                        for eachEarthquake in earthquakJson{
                            let geometry:[String:Any] = eachEarthquake["geometry"] as! [String : Any]
                            let coordinates : [NSNumber] = geometry["coordinates"] as! [NSNumber]
                      
                                //might not be string
                            let long:String = coordinates[0].stringValue
                                let lat = coordinates[1].stringValue
                            let newEarth = EarthquakeInfo.init(latitude: lat, longtitude: long)
                                earthArray.append(newEarth)
                            
                        }
                    completionHandler(earthArray, nil)
                    }else{
                        completionHandler(nil,error)
                    }
                    
                }catch{
                     completionHandler(nil,error)
                }
            }
        }.resume()
    }
}
