//
//  WeatherInfo.swift
//  Early warning system
//
//  Created by Dustin Tong on 4/9/19.
//  Copyright © 2019 Dustin Tong. All rights reserved.
//

import Foundation

struct WeatherInfo {
    var tempMin:Double
    var tempMax:Double
    var city:String
    var time:Int32
    var summary:String
}

struct CurrentWeatherInfo{
    var temp:Double
    var humidity: Double
    var windSpeed: Double
    var city:String
    var time:Int32
    var summary:String
}
struct EarthquakeInfo{
    var latitude: String
    var longtitude: String
}
