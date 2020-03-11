//
//  CurrentWeather.swift
//  weatherPF
//
//  Created by taeuk on 2020/03/10.
//  Copyright © 2020 김태욱. All rights reserved.
//

import Foundation

struct WeatherSummary: Codable {
    struct Weather: Codable {
        struct Minutely: Codable {
            struct Sky: Codable {
                
                let code: String
                let name: String
                
            }
            struct Temperature: Codable {
                
                let tc: String
                let tmax: String
                let tmin: String
                
            }
            struct Station: Codable {
                let name: String
            }
            let station: Station
            let sky: Sky
            let temperature: Temperature
        }
        let minutely: [Minutely]
    }
    struct Result: Codable {
        let code: Int
        let message: String
    }
    
    let weather: Weather
    let result: Result
}
