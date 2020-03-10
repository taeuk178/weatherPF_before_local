import UIKit



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

let apiurl = "https://apis.openapi.sk.com/weather/current/minutely?version=2&lat=37.498206&lon=127.02761&appKey=l7xx522b5771a40d42a59a3fafcdeadf41cb"
let url = URL(string: apiurl)
let session = URLSession.shared


let task = session.dataTask(with: url!) { (data, response, error) in
    if let error = error{
        print(error)
        
        return
    }
    guard let httpResponse = response as? HTTPURLResponse else{
        print("Invalid response")
        return
    }
    guard (200...299).contains(httpResponse.statusCode) else {
        print(httpResponse.statusCode)
        return
    }
    guard let data = data else {
        fatalError("invalid Data")
    }
    do {
        let decoder = JSONDecoder()
        let summary = try decoder.decode(WeatherCurrent.self, from: data)
        
        summary.result.code
        summary.result.message
        
        summary.weather.minutely.first?.sky.code
        summary.weather.minutely.first?.sky.name
        summary.weather.minutely.first?.station.name
        summary.weather.minutely.first?.temperature.tmax
        summary.weather.minutely.first?.temperature.tmin
        
        
    } catch  {
        print(error)
    }
}
task.resume()
