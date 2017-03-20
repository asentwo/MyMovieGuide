//
//  MoviesGenresDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/7/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import ParticlesLoadingView
import CDAlertView


class MoviesGenresCollectionViewController: UICollectionViewController {
  
  
  //MARK: Properties
  @IBOutlet var genreCollectionView: UICollectionView!

  let networkManager = NetworkManager.sharedManager
  
  var genreDataArray: [MovieData] = []
  var genreID: NSNumber?
  var movieID: NSNumber?
  
  let reuseIdentifier = "genreCollectionViewCell"
  let segueIdentifier = "genreToDetailSegue"
  
  //Particle loading screen
  lazy var loadingView: ParticlesLoadingView = {
    let x = self.view.frame.size.width/2
    let y = self.view.frame.size.height/2
    let view = ParticlesLoadingView(frame: CGRect(x: x - 50, y: y - 20, width: 100, height: 100))
    view.particleEffect = .laser
    view.duration = 1.5
    view.particlesSize = 15.0
    view.clockwiseRotation = true
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.borderWidth = 1.0
    view.layer.cornerRadius = 15.0
    return view
  }()
  
  let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
  
  
  //Layout
  let itemsPerRow: CGFloat = 3
  let sectionInsets = UIEdgeInsets(top: 35.0, left: 10.0, bottom: 35.0, right: 10.0)
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
      self.navigationController?.navigationBar.tintColor = UIColor.white
    
    label.center = CGPoint(x: 160, y: 285)
    label.textAlignment = .center
    label.text = "Loading"
    self.view.addSubview(label)
    
    view.addSubview(loadingView)
    loadingView.startAnimating()
    
    if let id = genreID {
      
      MovieData.updateAllData(type:"genre", urlExtension: "\(id)/movies", completionHandler: {results in
        
        guard let results = results else {
   CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .notification).show()
          return
        }
        self.genreDataArray = results
        
        DispatchQueue.main.async {
          self.label.isHidden = true
          self.loadingView.isHidden = true
          self.loadingView.stopAnimating()
          
          self.genreCollectionView.reloadData()
        }
      })
    }
  }
}


//MARK: CollectionView Datasource
extension MoviesGenresCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return genreDataArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! genreCollectionViewCell
    
   
    if let genrePoster = genreDataArray[indexPath.row].poster {
        cell.genreImageView.sd_setImage(with: URL(string:"\(baseImageURL)\(genrePoster)"), placeholderImage: UIImage(named: "placeholder.png"))
    } else {
      cell.genreImageView.image = UIImage(named: "placeholder.png")
    }
    return cell
  }
  
}


//MARK: CollectionView Delegate

extension MoviesGenresCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.movieID = genreDataArray[indexPath.row].id
    performSegue(withIdentifier: segueIdentifier, sender: self)
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesGenresCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  //Height and width of cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpaceWidth = sectionInsets.left * (itemsPerRow + 1)
    let paddingSpaceHeight = sectionInsets.top * (itemsPerRow + 2)
    let availableWidth = view.frame.width - paddingSpaceWidth
    let availableHeight = view.frame.height - paddingSpaceHeight 
    let widthPerItem = availableWidth / itemsPerRow
    let heightPerItem = availableHeight / itemsPerRow
    
    return CGSize(width: widthPerItem, height: heightPerItem + 40)
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

extension MoviesGenresCollectionViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! MoviesDetailViewController
    
    destinationVC.iD = self.movieID
    
  }
  
}


