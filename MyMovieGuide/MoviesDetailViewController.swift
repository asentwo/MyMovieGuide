//
//  MoviesDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/10/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import ParticlesLoadingView
import FadeButton
import CDAlertView


enum segueController {
  case image
  case cast
  case video
}

class MoviesDetailViewController: UIViewController {
  
  
  @IBOutlet weak var lineImage: UIImageView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var overview: UILabel!
  @IBOutlet weak var runtimeCat: UILabel!
  @IBOutlet weak var runtime: UILabel!
  @IBOutlet weak var genreCat: UILabel!
  @IBOutlet weak var genre: UILabel!
  @IBOutlet weak var ratingCat: UILabel!
  @IBOutlet weak var rating: UILabel!
  @IBOutlet weak var titleTint: UIImageView!
  @IBOutlet weak var overivewTint: UIImageView!
  @IBOutlet weak var homepageButton: UIButton!
  @IBOutlet weak var imagesTableView: UITableView!
  @IBOutlet weak var hompageButton: FadeButton!
  @IBOutlet weak var saveButton: FadeButton!
  @IBOutlet weak var videosButton: FadeButton!
  
  
  
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
  var videoInfo: VideoResults?
  
  var homepage : String?
  
  
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
  
  let label = UILabel(frame: CGRect(x: 0 + 20, y: 0, width: 200, height: 21))

  //Segues
  let detailToImageSegue = "detailToImageSegue"
  let detailToPeopleSegue = "detailToPeopleSegue"
  let detailToVideoSegue = "detailToVideoSegue"
  
  //TableViewCell Reuse Identifiers
  let castReuseIdentifier = "castCell"
  let extraReuseIdentifier = "extraImagesCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    setImagesAndButtonsUI()
    
    if let movieID = self.iD {
      
      MovieDetailsData.updateAllData(urlExtension: "\(movieID)", completionHandler: { results in
        
        guard let results = results else {
          CDAlertView(title: "Sorry", message: "No info available!", type: .notification).show()
          return
        }
        self.movieDetailsData = results
        self.extraImagesArray = self.movieDetailsData?.images?.backdropImages
        
        if let images = self.movieDetailsData?.images {
          self.imageArray += images.backdropImages.map{ $0.filePath }
        } else {
          CDAlertView(title: "Sorry", message: "No info available!", type: .notification).show()
        }
        
        self.homepage = self.movieDetailsData?.homepage
        self.videoInfo = self.movieDetailsData?.videos
        
        CastData.updateAllData(urlExtension: "\(movieID)/credits", completionHandler: { results in
          
          guard let results = results else {
            CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .notification).show()
            return
          }
          self.castArray = results
          
          if let rating = self.movieDetailsData?.rating {
            
            let allRatings = rating.releaseResults
            
            for country in allRatings {
              
              let countryCode = country.countryCode
              
              if countryCode == "US" {
                
                if let USRating = country.certification {
                  
                  DispatchQueue.main.async {
                    
                    if let poster = self.movieDetailsData?.poster{
                      self.backgroundImage.sd_setImage(with: URL(string: "\(baseImageURL)\(poster)"),placeholderImage: UIImage(named: "placeholder.png"))
                    } else {
                      self.backgroundImage.image = UIImage(named: "placeholder.png")
                    }
                    
                    self.movieTitle.text = self.movieDetailsData?.title
                    self.overview.text = self.movieDetailsData?.overview
                    
                    if let runtime = self.movieDetailsData?.runtime {
                      self.runtime.text = String(describing: runtime)
                    }
                    
                    if USRating == "" {
                      self.rating.text = "N/A"
                    } else {
                      self.rating.text = USRating
                    }
                    
                    if let genre = self.movieDetailsData?.genre {
                      self.genre.text = genre[0].name
                    }
                    
                    self.lineImage.image = #imageLiteral(resourceName: "Line")
                    self.runtimeCat.text = "RUNTIME"
                    self.genreCat.text = "GENRE"
                    self.ratingCat.text = "RATING"
                    
                    self.label.isHidden = true
                    self.loadingView.isHidden = true
                    self.loadingView.stopAnimating()
                    self.imagesTableView.reloadData()
                    
                  }
                }
              } else {
                
                DispatchQueue.main.async {
                  
                  if let poster = self.movieDetailsData?.poster{
                    self.backgroundImage.sd_setImage(with: URL(string: "\(baseImageURL)\(poster)"),placeholderImage: UIImage(named: "placeholder.png"))
                  } else {
                    self.backgroundImage.image = UIImage(named: "placeholder.png")
                  }
                  
                  self.movieTitle.text = self.movieDetailsData?.title
                  self.overview.text = self.movieDetailsData?.overview
                  
                  if let runtime = self.movieDetailsData?.runtime {
                    self.runtime.text = String(describing: runtime)
                  }
                  
                  if let genre = self.movieDetailsData?.genre {
                    self.genre.text = genre[0].name
                  }
                  
                  self.rating.text = "N/A"
                  self.lineImage.image = #imageLiteral(resourceName: "Line")
                  self.runtimeCat.text = "RUNTIME"
                  self.genreCat.text = "GENRE"
                  self.ratingCat.text = "RATING"
                  
                  self.label.isHidden = true
                  self.loadingView.isHidden = true
                  self.loadingView.stopAnimating()
                  self.imagesTableView.reloadData()
                  
                }
              }
            }
          }
        })
      })
    } else {
      self.label.isHidden = true
      self.loadingView.isHidden = true
      self.loadingView.stopAnimating()
      CDAlertView(title: "Sorry", message: "No info available!", type: .notification).show()
    }
  }
  
  
  func setImagesAndButtonsUI () {
    
    roundImageViewCorners(imageView: titleTint)
    roundImageViewCorners(imageView: overivewTint)
    roundButtonCornersAndAddBorderColor(button: homepageButton)
    roundButtonCornersAndAddBorderColor(button: saveButton)
    roundButtonCornersAndAddBorderColor(button: videosButton)
    
    homepageButton.setBackgroundColor(color: .white, forState: .highlighted)
    saveButton.setBackgroundColor(color: .white, forState: .highlighted)
    videosButton.setBackgroundColor(color: .white, forState: .highlighted)
  }
  
  func startLoadingScreen () {
    label.center = CGPoint(x: 190, y: 365)
    label.textAlignment = .center
    label.text = "Loading"
    label.textColor = UIColor.white
    self.view.addSubview(label)
    view.addSubview(loadingView)
    loadingView.startAnimating()
  }
  
  
  @IBAction func homepageButtonPressed(_ sender: Any) {
    
    if let homepage = self.homepage {
      if let url = URL(string: homepage) {
        UIApplication.shared.open(url, options: [:])
      }  else {
        CDAlertView(title: "Sorry", message: "No web page available!", type: .notification).show()
      }
      
    }
  }
  
  @IBAction func saveButtonPressed(_ sender: Any) {
  }
  
  @IBAction func videosButtonPressed(_ sender: Any) {
    
    if let videoInfo = self.videoInfo {
      if videoInfo.videoResults.count != 0 {
      self.videoTapped(videoInfo: videoInfo, segueType: segueController.video)
      } else {
        CDAlertView(title: "Sorry", message: "No videos available!", type: .notification).show()
      }
    }else {
      CDAlertView(title: "Sorry", message: "No videos available!", type: .notification).show()
    }
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
      
    else if self.segueType == segueController.video {
      
      let videoVC = segue.destination as! MoviesVideoTableViewController
      videoVC.videoInfo = self.videoInfo
      
    }
  }
}


//Protocols
extension MoviesDetailViewController : handleCastData, handleExtraImage, handleVideoData  {
  
  func imageTapped(ID castID: NSNumber, segueType: segueController) {
    self.castID = castID
    self.segueType = segueType
    performSegue(withIdentifier: detailToPeopleSegue, sender: self)
  }
  
  func extraImageTapped(Image: String, segueType: segueController) {
    self.extraImage = Image
    self.segueType = segueType
    performSegue(withIdentifier: detailToImageSegue, sender: self)
  }
  
  func videoTapped(videoInfo: VideoResults, segueType: segueController) {
    self.videoInfo = videoInfo
    self.segueType = segueType
    performSegue(withIdentifier: detailToVideoSegue, sender: self)
  }
  
}
