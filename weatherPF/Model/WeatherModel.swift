//
//  Model.swift
//  WeatherAPI_skt
//
//  Created by taeuk on 2020/03/05.
//  Copyright © 2020 김태욱. All rights reserved.
//

import Foundation
import CoreLocation



class WeatherDataSource {
    static let shared = WeatherDataSource()
    
    private init() {}
    
    var summary: WeatherSummary?
    var forecastList = [ForecastData]()
    var datesss: Forecast?
    
    var forecastday = [SixData]()
    
    
    let group = DispatchGroup()
    let workQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent)
    
    func fetch(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        workQueue.async {
            self.fetchSummary(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                self.group.leave()
            }
        }
        group.enter()
        workQueue.async {
            self.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                self.group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    //MARK: Current
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
                self.summary = try decoder.decode(WeatherSummary.self, from: data)
            
            }catch{
                print(error)
            }
        }

        task.resume()
    }
    //MARK: Threedays
    func fetchForecast(lat: Double, lon: Double, completion: @escaping () -> ()) {
        forecastday.removeAll()
        
        
        let apiurl = "https://apis.openapi.sk.com/weather/forecast/3days?version=2&lat=37.498206&lon=127.02761&appKey=\(appkey)"
            
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
                let forecast = try decoder.decode(Forecast.self, from: data)
                self.datesss = try decoder.decode(Forecast.self, from: data)
                if let list = forecast.weather.forecast3days.first?.fcst3hour.arrayRepresentation(){
                    self.forecastList = list
                    
                }
                
                
            }catch{
                print(error)
            }
        }

        task.resume()


    }
    
    func fetchDays(lat: Double, lon: Double, completion: @escaping () -> ()) {
        forecastList.removeAll()
        
        
        let apiurl = "https://apis.openapi.sk.com/weather/forecast/6days?version=2&lat=\(lat)&lon=\(lon)&appKey=\(appkey)"
            
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
                let forecast = try decoder.decode(Sixdays.self, from: data)
                if let list = forecast.weather.forecast6days.first?.sixarrayRepresentation(){
                    self.forecastday = list
                }
                
            }catch{
                print(error)
            }
        }

        task.resume()


    }
}
