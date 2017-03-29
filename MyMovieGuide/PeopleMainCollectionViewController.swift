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
import ParticlesLoadingView

class PeopleMainCollectionViewController : MasterViewController {
  
  
  @IBOutlet weak var peopleSearchTextFieldInput: UITextField!
  @IBOutlet weak var peopleCollectionView: UICollectionView!
  @IBOutlet weak var tintLoadingView: UIImageView!
  
  let networkManager = NetworkManager.sharedManager
  
  var peopleData: [PeopleData]?
  var peopleArray: [PeopleMainData] = []
  var peopleIDArray: [NSNumber] = []
  var peopleID: NSNumber?
  let peopleToDetailSegue = "peopleToDetailSegue"
  let peopleMainReuseIdentifier = "peopleMainReuseIdentifier"
  
  //Layout
  let itemsPerRow: CGFloat = 2
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tintLoadingView.isHidden = true
    self.startLoadingScreen()
    
    PeopleMainData.updateAllData(urlExtension: "popular", completionHandler: {results in
      
      guard let results = results else {
        CDAlertView(title: "Sorry", message: "There was an error retrieving data", type: .error).show()
      return
      }
      self.peopleArray = results
      
      DispatchQueue.main.async {
        self.hideLoadingScreen()
        self.peopleCollectionView.reloadData()
      }
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tintLoadingView.isHidden = true
  }
  
  @IBAction func searchButtonTapped(_ sender: Any) {
    
    DispatchQueue.main.async {
      
      self.loadingView.isHidden = false
      self.label.isHidden = false
      self.loadingView.startAnimating()
      self.tintLoadingView.isHidden = false
      
      PeopleData.updateSearchData(name: (self.peopleSearchTextFieldInput.text?.replacingOccurrences(of: " ", with: "+").lowercased())!, completionHandler: {results in
        
        guard let results = results else {
          CDAlertView(title: "Sorry", message: "No results found", type: .error).show()
          
          return
        }
        self.peopleData = results
        
        if let peopleInfoArray = self.peopleData {
          
          for people in peopleInfoArray {
            
            if let id = people.id {
              
              self.peopleIDArray.append(id)
            }
          }
          if self.peopleIDArray.count != 0 {
            
            self.peopleID = self.peopleIDArray.first
            DispatchQueue.main.async {
              self.peopleIDArray.removeAll()
              self.hideLoadingScreen()
              self.peopleSearchTextFieldInput.text = ""
              self.performSegue(withIdentifier: self.peopleToDetailSegue, sender: self)
            }
            
          } else {
            
            DispatchQueue.main.async {
              self.peopleIDArray.removeAll()
              self.hideLoadingScreen()
              CDAlertView(title: "Sorry", message: "No results found", type: .error).show()
            }
            
          }
        }else {
          DispatchQueue.main.async {
            self.peopleIDArray.removeAll()
            self.hideLoadingScreen()
            CDAlertView(title: "Sorry", message: "No results found", type: .error).show()
          }
        }
      })
    }
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
    let peopleDetailVC = segue.destination as! PeopleDetailedViewController
    peopleDetailVC.id = self.peopleID
  }
}
