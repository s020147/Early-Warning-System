//
//  WeatherAPI.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/9/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import Foundation
let baseURL = "https://api.darksky.net/forecast/8698f5d94e38b7d8323c204e2a00fcde/%@,%@"
class WeatherAPI:NSObject{
    static let shared = WeatherAPI()
    private override init() {
    }

    func getWeatherNow(lat: String, long:String, cityName:String, completion:@escaping(_ CurWeatherInfo:CurrentWeatherInfo?,_ error:Error?)->Void){
        let makeBaseUrl:String = String(format: baseURL, arguments: [lat,long])
        let url = URL(string: makeBaseUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if(error == nil){
                do{
                    if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                        let curJsonRes = result["currently"] as? [String:Any]
                        let tempa = curJsonRes!["temperature"] as? Double
                        let humidity = curJsonRes!["humidity"] as? Double
                        let windSpeed = curJsonRes!["windSpeed"] as? Double
                        let time = curJsonRes!["time"] as? Int32
                        let sum = curJsonRes!["summary"] as? String
                        let curWeather:CurrentWeatherInfo = CurrentWeatherInfo(temp: tempa!, humidity: humidity!, windSpeed: windSpeed!, city: cityName, time: time!, summary: sum!)
                            completion(curWeather, nil)
                    }else{
                        completion(nil,error)
                    }
                }catch{
                    completion(nil,error)
                }
            }
        }.resume()
    }
    
    
    func getWeather(lat:String, long:String, countryName: String, completion: @escaping(_ weatherInfoArray:[WeatherInfo]?,_ error:Error?)->Void){
        let makeBaseUrl: String = String(format: baseURL, arguments: [lat,long])
        let url = URL(string: makeBaseUrl)
        URLSession.shared.dataTask(with: url!){ (data,response,error) in
            if(error == nil){
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                        let sevenDaysJsonResult = jsonResult["daily"] as? [String:Any]
                        let sevenDay = sevenDaysJsonResult!["data"] as? [[String:Any]]
                        var weatherInformationArray:[WeatherInfo] = []
                        for eachDay in sevenDay!{
                        let min = eachDay["temperatureMin"] as! Double
                        let max = eachDay["temperatureMax"] as! Double
                        let time = eachDay["time"] as! Int32
                        let summary = eachDay["summary"] as! String
                        weatherInformationArray.append(WeatherInfo(tempMin: min, tempMax: max, city: countryName, time: time, summary: summary ))
                        }
                        completion(weatherInformationArray,nil)
                    }else{
                        completion(nil,error)
                    }
                }catch{
                    completion(nil,error)

                }
            }
            
        }.resume()
    }
    
    
}
