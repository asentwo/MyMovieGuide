//
//  PeopleViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import SDWebImage
import CDAlertView

class PeopleMainCollectionViewController : UIViewController {
  
  @IBOutlet weak var peopleCollectionView: UICollectionView!
  
  let networkManager = NetworkManager.sharedManager
  
  var peopleArray: [PeopleMainData] = []
  var peopleID: NSNumber?
  
  let peopleToDetailSegue = "peopleToDetailSegue"
  let peopleMainReuseIdentifier = "peopleMainReuseIdentifier"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    PeopleMainData.updateAllData(urlExtension: "popular", completionHandler: {results in
      
      guard let results = results else {
        print("There was an error retrieving people data")
        return
      }
      self.peopleArray = results
      
      DispatchQueue.main.async {
        self.peopleCollectionView.reloadData()
      }
    })
  }
}

// MARK: - UICollectionViewDataSource
extension  PeopleMainCollectionViewController : UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return peopleArray.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: peopleMainReuseIdentifier, for: indexPath) as! PeopleMainCollectionViewCell
    
    if let people = peopleArray[indexPath.row].poster {
      cell.peopleImageView.sd_setImage(with: URL(string:"\(baseImageURL)\(people)"))
      roundImageViewCorners(imageView:cell.peopleImageView)
    }
    
    if let name = peopleArray[indexPath.row].name {
      cell.peopleMainLabel.text = name
    }
    
    return cell
  }
}


// MARK: - UICollectionViewDelegate
extension PeopleMainCollectionViewController : UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.peopleID = peopleArray[indexPath.row].id
    performSegue(withIdentifier: peopleToDetailSegue, sender: self)
    
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension  PeopleMainCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  //Height and width of cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpaceWidth = sectionInsets.left * (itemsPerRow + 1)
    let paddingSpaceHeight = sectionInsets.top * (itemsPerRow + 2)
    let availableWidth = view.frame.width - paddingSpaceWidth
    let availableHeight = view.frame.height - paddingSpaceHeight
    let widthPerItem = availableWidth / itemsPerRow
    let heightPerItem = availableHeight / itemsPerRow
    
    return CGSize(width: widthPerItem, height: heightPerItem)
  }
  
  //Returns space in between cells
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  //Returns spacing in between each line
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}


//MARK: Segue
extension PeopleMainCollectionViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let peopleDetailVC = segue.destination as! PeopleDetailViewController
    peopleDetailVC.id = self.peopleID
  }
}
