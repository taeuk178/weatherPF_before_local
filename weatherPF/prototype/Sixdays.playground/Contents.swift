import UIKit


struct Sixdays: Codable {
    struct Weather: Codable {
        struct Forecast6days: Codable {
            struct Sky: Codable {
                
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
            struct Temperature: Codable {
                
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

let apiurl = "https://apis.openapi.sk.com/weather/forecast/6days?version=2&lat=37.498206&lon=127.02761&appKey=l7xx522b5771a40d42a59a3fafcdeadf41cb"

let url = URL(string: apiurl)!
let session = URLSession.shared
let task = session.dataTask(with: url) { (data, response, error) in
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
            
            forecast.result.code
            forecast.result.message
            
            forecast.weather.forecast6days.first?.sky
            forecast.weather.forecast6days.first?.temperature
            
            
            
        }catch{
            print(error)
        }
    }

    task.resume()

for i in 2...7{
    print(i)
}
