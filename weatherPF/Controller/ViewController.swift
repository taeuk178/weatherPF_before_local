//
//  ViewController.swift
//  weatherPF
//
//  Created by taeuk on 2020/03/09.
//  Copyright © 2020 김태욱. All rights reserved.
//

import UIKit
import CoreLocation

//메세지 설명
extension UIViewController{
    func show(message: String){
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    
    lazy var locationManager: CLLocationManager = {

        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ko_kr")
        return formatter
    }()
    
    //날씨 소수점은 15.6, 15.00 -> 15
    let tempFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listButton: UIButton!
    
    let image = UIImage(systemName: "list.dash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listButton.setImage(image, for: .normal)
        
        
        WeatherDataSource.shared.fetchSummary(lat: 35.538333, lon: 129.311389) {
            [weak self] in
            self?.tableView.reloadData()
        }
        WeatherDataSource.shared.fetchForecast(lat: 35.538333, lon: 129.311389) {
            [weak self] in
            self?.tableView.reloadData()
        }
        
        WeatherDataSource.shared.fetchDays(lat: 35.538333, lon: 129.311389) {
            [weak self] in
            self?.tableView.reloadData()
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationLabel.text = "업데이트 중..."
        //location 활성화 상태 파악
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .notDetermined:
                //Alaways 는 백그라운드에서 실행가능
                // 앱실행때만
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                updateCurrentLocation()
            case .denied, .restricted:
                show(message: "위치 서비스 사용 불가")
            default:
                break
            }
        }else{
            show(message: "위치 서비스 사용 불가")
        }
    }

    @IBAction func AddWeather(_ sender: UIButton){
        let sseg = storyboard?.instantiateViewController(identifier: "SaveVC")
        
        present(sseg!, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate{
    
    func updateCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    //위치 서비스 업데이트 할때마다 반복 호출됨 경우에 따라 지연되기 때문에 배열로 받음
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first{
            print(loc.coordinate)
            
            let decoder = CLGeocoder()
            decoder.reverseGeocodeLocation(loc) { [weak self] (placemarks, error) in
                if let place = placemarks?.first{
                    if let gu = place.locality, let dong = place.subLocality{
                        self?.locationLabel.text = "\(gu)\(dong)"
                    }else{
                        self?.locationLabel.text = place.name
                    }
                }
            }
//            WeatherDataSource.shared.fetch(location: loc) {
//                self.tableView.reloadData()
//            }
        }
        //사용시 gps를 더 이상 사용하지 않음
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        show(message: error.localizedDescription)
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            //위치정보 사용시 두 메소드 중 하나는 반드시 포함되어있음
        case .authorizedWhenInUse, .authorizedAlways:
            updateCurrentLocation()
        default:
            break
        }
    }
    
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return WeatherDataSource.shared.forecastday.count
        default:
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
            if let data = WeatherDataSource.shared.summary?.weather.minutely.first{
                cell.weatherimageView.image = UIImage(named: data.sky.code)
                cell.name.text = data.sky.name
                
                let max = Double(data.temperature.tmax) ?? 0.0
                let min = Double(data.temperature.tmin) ?? 0.0
                
                let maxStr = tempFormatter.string(for: max) ?? "-"
                let minStr = tempFormatter.string(for: min) ?? "-"

                cell.temperature.text = "\(maxStr) / \(minStr)"
                cell.areaname.text = data.station.name
            }
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeCell
            cell.reloadCollectionView()
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "daysCell", for: indexPath) as! DaysCell
            
            let target = WeatherDataSource.shared.forecastday[indexPath.row]
            dateFormatter.dateFormat = "M.d (E)"
            
            cell.images.image = UIImage(named: target.skyCode)
            cell.days.text = dateFormatter.string(for: target.date)
            cell.temp.text = "\(target.maxtemp) / \(target.mintemp)"
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180
        case 1:
            return 100
        case 2:
            return 60
        default:
            return 10
        }
    }
}
