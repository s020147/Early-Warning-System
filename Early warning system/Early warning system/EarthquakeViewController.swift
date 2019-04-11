//
//  EarthquakeViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/10/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit

import GoogleMaps

class EarthquakeViewController: UIViewController, GMSMapViewDelegate{
    
    var earthquakeArray:[EarthquakeInfo] = []
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEarthquakeController()
        
        
    
    }
    func getEarthquakeController(){
        Earthquake.shared.getEarthData(completionHandler:{ (earthquakeInfoArray, error) in
            if let earthArray = earthquakeInfoArray{
                self.earthquakeArray = earthArray
                print(self.earthquakeArray)
            }else{
                print("array is empty")
            }
            DispatchQueue.main.async {
                self.setupCord()
            }
        })
    }
    func setupCord(){
        var index = 0
        for eachQuake in earthquakeArray{
            let long = earthquakeArray[index].longtitude
            let lat = earthquakeArray[index].latitude
            let location = CLLocation(latitude: Double(lat) as! CLLocationDegrees, longitude: Double(long) as! CLLocationDegrees)
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.title = "Earthquake \(index)"
            marker.map = mapView
            index += 1
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
