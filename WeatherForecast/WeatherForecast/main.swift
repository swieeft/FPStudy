//
//  main.swift
//  WeatherForecast
//
//  Created by 박길남 on 2018. 9. 27..
//  Copyright © 2018년 swieeft. All rights reserved.
//

import Foundation

/* non-FP Code ---------------------
struct Location: Codable {
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
}

struct WeatherInfo: Codable {
    let consolidated_weather: [Weather]
}

struct Weather: Codable {
    let weather_state_name: String
    let wind_direction_compass: String
    let applicable_date: String
    let min_temp: Float
    let max_temp: Float
    let the_temp: Float
    let wind_speed: Float
    let wind_direction: Float
    let air_pressure: Float
    let humidity: Float
    let visibility: Float
    let predictability: Float
}

let query = "seoul"
let locQueryUrl = URL(string: "https://www.metaweather.com/api/location/search?query=\(query)")!

if let locData = try? Data(contentsOf: locQueryUrl) {
    if let locations = try? JSONDecoder().decode([Location].self, from: locData) {
        
        for location in locations {
            print("[\(location.title)]")
            
            let woeid = location.woeid
            let weatherUrl = URL(string: "https://www.metaweather.com/api/location/\(woeid)")!
            
            if let weatherData = try? Data(contentsOf: weatherUrl) {
                if let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: weatherData) {
                    
                    let weathers = weatherInfo.consolidated_weather
                    for weather in weathers {
                        let state = weather.weather_state_name.padding(toLength: 15,
                                                                       withPad: " ",
                                                                       startingAt: 0)
                        let forecast = String(format: "%@: %@ %2.2f°C ~ %2.2f°C",
                                              weather.applicable_date,
                                              state,
                                              weather.max_temp,
                                              weather.min_temp)
                        print(forecast)
                    }
                }
            }
            
            print("")
        }
    }
}
---------------------------------*/

// FP Code
 
struct Location: Codable {
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
}

struct WeatherInfo: Codable {
    let consolidated_weather: [Weather]
}

struct Weather: Codable {
    let weather_state_name: String
    let wind_direction_compass: String
    let applicable_date: String
    let min_temp: Float
    let max_temp: Float
    let the_temp: Float
    let wind_speed: Float
    let wind_direction: Float
    let air_pressure: Float
    let humidity: Float
    let visibility: Float
    let predictability: Float
}

func getData(_ url:URL, _ complted: @escaping (Data) -> ()) {
    DispatchQueue.global(qos: .default).async {
        if let data = try? Data(contentsOf: url) {
            complted(data)
        }
    }
}

// 지역검색 -> [Location]
func getLocation(_ query:String, _ complted: @escaping ([Location]) -> ()) {
    let url = URL(string: "https://www.metaweather.com/api/location/search?query=\(query)")!
    getData(url) { data in
        if let locations = try? JSONDecoder().decode([Location].self, from: data) {
            complted(locations)
        }
    }
}

// Location -> woeid -> [Weather]
func getWeathers(_ woeid:Int, _ complted: @escaping ([Weather]) -> ()) {
    let url = URL(string: "https://www.metaweather.com/api/location/\(woeid)")!
    getData(url) { data in
        if let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: data) {
            complted(weatherInfo.consolidated_weather)
        }
    }
}

// Weather -> print
func printWeather(_ weather: Weather) {
    let state = weather.weather_state_name.padding(toLength: 15,
                                                   withPad: " ",
                                                   startingAt: 0)
    let forecast = String(format: "%@: %@ %2.2f°C ~ %2.2f°C",
                          weather.applicable_date,
                          state,
                          weather.max_temp,
                          weather.min_temp)
    print(forecast)
}

getLocation("san") { locations in
    locations.forEach({ location in
        getWeathers(location.woeid) { weathers in
            print("[\(location.title)]")
            weathers.forEach({ weather in
                printWeather(weather)
            })
            print("")
        }
    })
}

RunLoop.main.run()
