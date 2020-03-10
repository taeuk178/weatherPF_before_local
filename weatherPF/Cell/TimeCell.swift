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
    

    override func awakeFromNib() {
        super.awakeFromNib()

        let cellSize = CGSize(width:100 , height:100)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.itemSize = cellSize
//        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//        layout.minimumLineSpacing = 1.0
//        layout.minimumInteritemSpacing = 1.0
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        
        cell.telabel.text = "11:00"
        
        return cell
    }
    
    
}
