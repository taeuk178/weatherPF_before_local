//
//  SixDays.swift
//  weatherPF
//
//  Created by taeuk on 2020/03/11.
//  Copyright © 2020 김태욱. All rights reserved.
//

import Foundation

struct SixData {
    let date: Date
    let skyCode: String
    let skyName: String
    let maxtemp: Int
    let mintemp: Int
}

struct Sixdays: Codable {
    struct Weather: Codable {
        struct Forecast6days: Codable {
            @objcMembers class Sky: NSObject, Codable {
                
                let pmCode2day: String
                let pmName2day: String
                let pmCode3day: String
                let pmName3day: String
                let pmCode4day: String
                let pmName4day: String
                let pmCode5day: String
                let pmName5day: String
                let pmCode6day: String
                let pmName6day: String
                let pmCode7day: String
                let pmName7day: String
            }
            @objcMembers class Temperature: NSObject, Codable {
                
                let tmax2day: String
                let tmin2day: String
                let tmax3day: String
                let tmin3day: String
                let tmax4day: String
                let tmin4day: String
                let tmax5day: String
                let tmin5day: String
                let tmax6day: String
                let tmin6day: String
                let tmax7day: String
                let tmin7day: String
            }
            let sky: Sky
            let temperature: Temperature
            
            func sixarrayRepresentation() -> [SixData]{
                var data = [SixData]()
                let now = Date()
                
                for number in 2...7{
                    var key = "pmCode\(number)day"
                    guard let skyCode = sky.value(forKey: key) as? String else {
                        continue
                    }
                    
                    key = "pmName\(number)day"
                    guard let skyName = sky.value(forKey: key) as? String else{
                        continue
                    }
                    key = "tmax\(number)day"
                    let maxtempStr = temperature.value(forKey: key) as? String ?? "0"
                    guard let maxtemp = Int(maxtempStr) else { continue }
                    
                    key = "tmin\(number)day"
                    let mintempStr = temperature.value(forKey: key) as? String ?? "0"
                    guard let mintemp = Int(mintempStr) else { continue }
                    
                    let date = now.addingTimeInterval(TimeInterval(number) * 86000)
                    let sixx = SixData(date: date, skyCode: skyCode, skyName: skyName, maxtemp: maxtemp, mintemp: mintemp)
                    data.append(sixx)
                }
                return data
            }
        }
        let forecast6days: [Forecast6days]
    }
    struct Result: Codable {
        let code: Int
        let message: String
    }
    let result: Result
    let weather: Weather
}
