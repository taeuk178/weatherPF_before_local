//
//  TimeCell.swift
//  weatherPF
//
//  Created by taeuk on 2020/03/09.
//  Copyright © 2020 김태욱. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 18000)
        formatter.dateFormat = "HH:00"
        
        
        return formatter
    }()
    
    let tempFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellSize = CGSize(width:100 , height:100)
        
        //MARK: CollectionViewCell setup
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)

        collectionView.reloadData()
    }
    func reloadCollectionView() -> Void {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    

}

extension TimeCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherDataSource.shared.forecastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        
        
        let target = WeatherDataSource.shared.forecastList[indexPath.row]
        
        cell.telabel.text = dateFormatter.string(from: target.date)
        cell.imageView.image = UIImage(named: target.skyCode)
        
        let tempStr = tempFormatter.string(for: target.temperature) ?? "-"
        cell.tempLabel.text = "\(tempStr)º"
        
        return cell
    }
    
    
}
