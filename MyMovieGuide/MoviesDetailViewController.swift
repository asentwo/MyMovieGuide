//
//  MoviesDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/10/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


enum segueController {
  case image
  case cast
}

class MoviesDetailViewController: UIViewController {
  
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var overview: UILabel!
  @IBOutlet weak var runtime: UILabel!
  @IBOutlet weak var genre: UILabel!
  @IBOutlet weak var rating: UILabel!
  @IBOutlet weak var titleTint: UIImageView!
  @IBOutlet weak var overivewTint: UIImageView!
  @IBOutlet weak var buttonsTint: UIImageView!
  @IBOutlet weak var imagesTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var iD: NSNumber?
  
  var segueType: segueController?
  var castID: NSNumber?
  var extraImage: String?
  var extraImagesArray: [BackdropData]?
  
  var movieDetailsData: MovieDetailsData?
  var movieDetailsPoster: UIImage?
  var actorProfileImage: UIImage?
  
  var castArray: [CastData] = []
  var imageArray: [String] = []
  
  //Segues
  let detailToImageSegue = "detailToImageSegue"
  let detailToPeopleSegue = "detailToPeopleSegue"
  
  //TableViewCell Reuse Identifiers
  let castReuseIdentifier = "castCell"
  let extraReuseIdentifier = "extraImagesCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Round tint background
    roundImageViewCorners(imageView: titleTint)
    roundImageViewCorners(imageView: overivewTint)
    roundImageViewCorners(imageView: buttonsTint)
    
    
    if let movieID = self.iD {
      
      MovieDetailsData.updateAllData(urlExtension: "\(movieID)", completionHandler: { results in
        
        guard let results = results else {
          print("There was an error retrieving upcoming movie data")
          return
        }
        self.movieDetailsData = results
        self.extraImagesArray = self.movieDetailsData?.images?.backdropImages
        
        if let images = self.movieDetailsData?.images {
          self.imageArray += images.backdropImages.map{ $0.filePath }
        }
        
        if let rating = self.movieDetailsData?.rating {
          
          let allRatings = rating.releaseResults
          
          for country in allRatings {
            
            let countryCode = country.countryCode
            
            if countryCode == "US" {
              
              if let USRating = country.certification {
                
                DispatchQueue.main.async {
                  
                  if USRating == "" {
                    self.rating.text = "N/A"
                  } else {
                    self.rating.text = USRating
                  }
                }
              }
            }
          }
        }
        
        CastData.updateAllData(urlExtension: "\(movieID)/credits", completionHandler: { results in
          
          guard let results = results else {
            print("There was an error retrieving upcoming movie data")
            return
          }
          self.castArray = results
          
          
          DispatchQueue.main.async {
            
            if let poster = self.movieDetailsData?.poster{
              self.backgroundImage.sd_setImage(with: URL(string: "\(baseImageURL)\(poster)"))
            }
            
            self.movieTitle.text = self.movieDetailsData?.title
            self.overview.text = self.movieDetailsData?.overview
            
            if let runtime = self.movieDetailsData?.runtime {
              self.runtime.text = String(describing: runtime)
            }
            
            self.imagesTableView.reloadData()
          }
        })
      })
    }
  }
  
  //Round corners
  func roundImageViewCorners(imageView: UIImageView) {
    imageView.layer.cornerRadius = 8.0
    imageView.clipsToBounds = true
  }
  
  @IBAction func homepageButtonPressed(_ sender: Any) {
  }
  
  @IBAction func saveButtonPressed(_ sender: Any) {
  }
  
  @IBAction func videosButtonPressed(_ sender: Any) {
  }
  
}


extension MoviesDetailViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return min(1, castArray.count)
    case 1: return min(1, imageArray.count)
    default: fatalError("Unknown Selection")
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    switch indexPath.section {
      
    case 0:
      let cell = imagesTableView.dequeueReusableCell(withIdentifier: castReuseIdentifier)
        as! CastCell
      print("Cast Array Count:\(castArray.count)")
      cell.castPhotosArray = self.castArray
      cell.imageDelegate = self
      
      self.imagesTableView.rowHeight = 100
      imagesTableView.allowsSelection = true
      
      return cell
      
    case 1:
      let cell = imagesTableView.dequeueReusableCell(withIdentifier: extraReuseIdentifier)
        as! ExtraImagesCell
      
      cell.extraImagesArray = self.extraImagesArray
      cell.photosArray = self.imageArray
      cell.imageDelegate = self
      
      self.imagesTableView.rowHeight = 200
      imagesTableView.allowsSelection = true
      
      return cell
      
    default: _ = ""
    }
    return cell
  }
}


extension MoviesDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("row pressed: \(indexPath.row)")
  }
}


//Segues
extension MoviesDetailViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if self.segueType == segueController.cast {
      
      let peopleVC = segue.destination as! PeopleDetailViewController
      
      peopleVC.id = self.castID
    }
    else if self.segueType == segueController.image {
      
      let imageVC = segue.destination as! MoviesMasterImageController
      
      imageVC.image = self.extraImage
    }
  }
}


//Protocols
extension MoviesDetailViewController : handleCastData, handleExtraImage  {
  
  func imageTapped(ID castID: NSNumber, segueType: segueController) {
    self.castID = castID
    self.segueType = segueType
    performSegue(withIdentifier: detailToPeopleSegue, sender: self)
  }
  
  func extraImageTapped(Image: String, segueType: segueController) {
    self.extraImage = Image
    self.segueType = segueType
    performSegue(withIdentifier: detailToImageSegue, sender: self)
  }}
