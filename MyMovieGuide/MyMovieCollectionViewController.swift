//
//  MyMovieCollectionViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/24/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit



class MyMovieCollectionViewController : MasterCollectionViewController {
  
  var movieID: String!
  var sampleIDArray:[NSNumber] = [263115, 127380, 321612, 293167, 135397, 335797]
  var myMovieDataArray:[MovieDetailsData] = []
  
  let myMovieReuseIdentifier = "myMovieReuseIdentifier"
  let myMovieToDetailSegue = "myMovieToDetailSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    
    for sample in sampleIDArray {
      MovieDetailsData.updateAllData(urlExtension: String(describing:sample), completionHandler: {results
        in
        
        guard let results = results else {
          return
        }
        
        self.myMovieDataArray.append(results)
        
        DispatchQueue.main.async {
          
          self.hideLoadingScreen()
          self.collectionView?.reloadData()
        }
        
      })
    }
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return myMovieDataArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myMovieReuseIdentifier, for: indexPath) as! MyMovieCollectionViewCell
    
    if self.myMovieDataArray[indexPath.row].poster != nil {
      if let poster = self.myMovieDataArray[indexPath.row].poster {
        DispatchQueue.main.async {
          cell.imageView.sd_setImage(with: URL(string:"\(baseImageURL)\(poster)"), placeholderImage: UIImage(named: "placeholder.png"))
          
          print("\(baseImageURL)\(poster)")
        }
      }
    }
    
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.movieID = myMovieDataArray[indexPath.row].id
    performSegue(withIdentifier: myMovieToDetailSegue, sender: self)
    
  }
  
  
}
