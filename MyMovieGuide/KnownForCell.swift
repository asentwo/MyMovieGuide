//
//  KnownForCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/3/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


class KnownForCell : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
  
  var knownForArray: [UIImage] = []
  
  let knownForReuseIdentifier = "knownForCollectCell"
  
  @IBOutlet weak var knownForCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    knownForCollectionView.delegate = self
    knownForCollectionView.dataSource = self
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return knownForArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = knownForCollectionView.dequeueReusableCell(withReuseIdentifier: knownForReuseIdentifier, for: indexPath) as! KnownForCollectionViewCell
    
    cell.knownForImages.image = knownForArray[indexPath.row]
    
    return cell
  }
  
  
  
  
}
