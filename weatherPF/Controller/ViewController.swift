//
//  ViewController.swift
//  weatherPF
//
//  Created by taeuk on 2020/03/09.
//  Copyright © 2020 김태욱. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //날씨 소수점은 15.6, 15.00 -> 15
    let tempFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherDataSource.shared.fetchSummary(lat: 37.498206, lon: 127.02761) {
            [weak self] in
            self?.tableView.reloadData()
        }
        WeatherDataSource.shared.fetchForecast(lat: 37.498206, lon: 127.02761) {
            [weak self] in
            self?.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
            return 7
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
