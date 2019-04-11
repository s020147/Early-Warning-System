//
//  homeViewController.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/9/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import UIKit

import GoogleMaps
import CoreLocation
import GooglePlaces
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class homeViewController: UIViewController,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var googMap: UIButton!
    @IBOutlet weak var cityNameOut: UILabel!
    @IBOutlet weak var curTimeOut: UILabel!
    @IBOutlet weak var curTempOut: UILabel!
    @IBOutlet weak var curHumidOut: UILabel!
    @IBOutlet weak var curWindSpdOut: UILabel!
    @IBOutlet weak var curSumOut: UILabel!
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    var ref: DatabaseReference!
    var coord2D: CLLocationCoordinate2D?
    var weekOfWeatherInfoArray : [WeatherInfo]?
    var curWeatherObj : CurrentWeatherInfo?
    var cityName : String = ""
    var newPlaceName = ""
    var profileImg: UIImage = UIImage(named: "pikachu")!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        getUserImage()
        super.viewDidLoad()
        profilePic.image = profileImg
        weekOfWeatherInfoArray = []
        ref = Database.database().reference()
        setupLocation()
        
    }
    @IBAction func googlePlaceBtn(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true)
    }
    @IBAction func googMapAction(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "EarthquakeViewController") as? EarthquakeViewController{
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //GM Place
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        coord2D = place.coordinate
        newPlaceName = place.name!
        print(newPlaceName)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLocation(){
    locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            getCityName(loc: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("oof")
        print(error.localizedDescription)
    }
    
    
    func getCityName(loc:CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(loc, completionHandler: {
            placemark,error in
            if let place = placemark?.last{
                self.cityName = place.country!
                let lat = String(Double((place.location?.coordinate.latitude)!))
                let long = String(Double((place.location?.coordinate.longitude)!))
//                print(self.cityName)
                self.get7DayWeather(lati: lat, longt: long)
                self.getCurDayWeather(lati: lat, longt: long)
            }
        })
    }
    func getCurDayWeather(lati: String, longt:String){
        WeatherAPI.shared.getWeatherNow(lat: lati, long: longt, cityName: cityName, completion: { weatherInforHere, error in
            if(error == nil){
                if let weatherStuff = weatherInforHere{
                    self.curWeatherObj = weatherStuff
                }
                DispatchQueue.main.async {
                    self.restoreCurWeatherUI()
                }
            }
        })
    }
    
    func get7DayWeather(lati: String, longt:String){
        WeatherAPI.shared.getWeather(lat: lati, long: longt, countryName: cityName, completion: { weatherInfoHere, error in
            if(error == nil){
                if let weatherStuff = weatherInfoHere{
                    self.weekOfWeatherInfoArray = weatherStuff
//                    print("success \(self.weekOfWeatherInfoArray)")
                }
                DispatchQueue.main.async {
                    self.collectionTableView.reloadData()
                }
            }
        })
    }
    //get the picture
    func getUserImage(){
        if let user = Auth.auth().currentUser{
            let imageName = "UserImage/\(String(user.uid)).jpeg"
            var storageRef = Storage.storage().reference()
            storageRef = storageRef.child(imageName)
            storageRef.getData(maxSize: 1*300*300, completion: {
                data, error in
                if let img = UIImage(data: data!){
                    self.profilePic.image = img
                    print("success profile pic")
                }else{
                    print("empty img")
                }
            })
        }else{
            print("did not login")
        }
    }
    func formatDate(time : UInt64, format : String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let interval = TimeInterval(exactly: time)!
        let date = Date.init(timeIntervalSince1970: interval)
        print(formatter.string(from: date))
        return formatter.string(from: date)
    }
    
    func restoreCurWeatherUI(){
        let time:UInt64 = UInt64(curWeatherObj!.time)
        let humid:Double = curWeatherObj!.humidity
        curTimeOut.text = formatDate(time: time, format: "")
        cityNameOut.text = curWeatherObj?.city
        curHumidOut.text = String(humid)
        curWindSpdOut.text = String(curWeatherObj!.windSpeed)
        curSumOut.text = String(curWeatherObj!.summary)
    }
}


extension homeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekOfWeatherInfoArray!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionTableView?.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WeekCollectionViewCell
        let curObj = weekOfWeatherInfoArray![indexPath.row]
        let time:UInt64 = UInt64(curObj.time)
        cell?.weekCellOut.text = String(curObj.city)
        cell?.hTemp.text = "High: \(String(curObj.tempMax))"
        cell?.lTemp.text = "Low: \(String(curObj.tempMin))"
        cell?.time.text = formatDate(time: time, format: "")
        cell?.sum.text = curObj.summary
        return cell!
    }
}
