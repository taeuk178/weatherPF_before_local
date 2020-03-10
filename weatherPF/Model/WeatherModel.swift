//
//  WeatherModel.swift
//  weatherPF
//
//  Created by taeuk on 2020/03/09.
//  Copyright © 2020 김태욱. All rights reserved.
//

import Foundation

struct WeatherCurrent: Codable {
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
            
            let temperature: Temperature
            let station: Station
            let sky: Sky
            
            
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


class WeatherDataSource {
    static let shared = WeatherDataSource()
    
    //private init() {}
    
    var summary: WeatherCurrent?
    //var forecastList = [ForecastData]()
    
    func fetchSummary(lat: Double, lon: Double, completion: @escaping () -> ()) {
        
        let apiurl = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appkey)"

        let url = URL(string: apiurl)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            defer{
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error{
                print(error)
                
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("Invalid response")
                return
                
            }
            guard (200...299).contains(httpResponse.statusCode) else{
                print(httpResponse.statusCode)
                return
            }
            guard let data = data else{
                fatalError("Invalid Data")
            }
            do{
                let decoder = JSONDecoder()
                self.summary = try decoder.decode(WeatherCurrent.self, from: data)
            
            }catch{
                print(error)
            }
        }

        task.resume()
    }
}
