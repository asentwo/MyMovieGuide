//
//  MoviesDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/10/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import FadeButton
import CDAlertView
import CoreData

enum segueController {
  case image
  case cast
  case video
  case itunes
}

//used to save to core data


class MoviesDetailViewController: MasterViewController {
  
  
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
  @IBOutlet weak var userRatingsCat: UILabel!
  @IBOutlet weak var titleTint: UIImageView!
  @IBOutlet weak var overivewTint: UIImageView!
  @IBOutlet weak var homepageButton: UIButton!
  @IBOutlet weak var imagesTableView: UITableView!
  @IBOutlet weak var hompageButton: FadeButton!
  @IBOutlet weak var saveButton: FadeButton!
  @IBOutlet weak var videosButton: FadeButton!
  @IBOutlet weak var userRatings: UILabel!
  
  var currentMovieTitle: String?
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
  var savedCoreDataMovieIdArray: [NSManagedObject] = []
  
  
  //Segues
  let detailToImageSegue = "detailToImageSegue"
  let detailToPeopleSegue = "detailToPeopleSegue"
  let detailToVideoSegue = "detailToVideoSegue"
  let detailToItunesSegue = "detailToItunesSegue"
  
  //TableViewCell Reuse Identifiers
  let castReuseIdentifier = "castCell"
  let extraReuseIdentifier = "extraImagesCell"
  let itunesReuseIdentifier = "itunesCell"
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    setImagesAndButtonsUI()
    hideButtons()
    
    if let movieID = self.iD {
      
      MovieDetailsData.updateAllData(urlExtension: "\(movieID)", completionHandler: { results in
        
        guard let results = results else {
          DispatchQueue.main.async {
            CDAlertView(title: "Sorry", message: "No info available!", type: .error).show()
          }
          return
        }
        self.movieDetailsData = results
        
        if let movieTitle = self.movieDetailsData?.title?.replacingOccurrences(of: " ", with: "+").lowercased(){
        self.currentMovieTitle = movieTitle
        }
        self.extraImagesArray = self.movieDetailsData?.images?.backdropImages
        
        if let images = self.movieDetailsData?.images {
          self.imageArray += images.backdropImages.map{ $0.filePath }
        }
        self.homepage = self.movieDetailsData?.homepage
        self.videoInfo = self.movieDetailsData?.videos
        
        CastData.updateAllData(urlExtension: "\(movieID)/credits", completionHandler: { results in
          
          guard let results = results else {
            CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
            return
          }
          self.castArray = results
          
          if (self.movieDetailsData?.rating?.releaseResults.count)! > 0 {
            
            if let rating = self.movieDetailsData?.rating {
              let allRatings = rating.releaseResults
              for country in allRatings {
                let countryCode = country.countryCode
                if countryCode == "US" {
                  if let USRating = country.certification {
                    
                    DispatchQueue.main.async {
                      
                      if self.movieDetailsData?.poster != nil {
                        if let poster = self.movieDetailsData?.poster{
                          self.backgroundImage.sd_setImage(with: URL(string: "\(baseImageURL)\(poster)"),placeholderImage: UIImage(named: "placeholder.png"))
                        }
                        
                      } else {
                        if let backDrop = self.movieDetailsData?.backdrop{
                          self.backgroundImage.sd_setImage(with: URL(string: "\(baseImageURL)\(backDrop)"),placeholderImage: UIImage(named: "placeholder.png"))
                        }
                      }
                      
                      self.movieTitle.text = self.movieDetailsData?.title
                      self.overview.text = self.movieDetailsData?.overview
                      
                      if let runtime = self.movieDetailsData?.runtime {
                        self.runtime.text = String(describing: runtime)
                      }
                      if USRating != "" {
                        self.rating.text = USRating
                      } else {
                        self.rating.text = "N/A"
                      }
                      
                      
                      if let genre = self.movieDetailsData?.genre {
                        if genre.count != 0 {
                          self.genre.text = genre[0].name
                        }
                      }
                      
                      if let userRating = self.movieDetailsData?.userRatings {
                        self.userRatings.text = String(describing:userRating)
                      } else {
                        self.userRatings.text = "N/A"
                      }
                      
                      self.showButtons()
                      self.lineImage.image = #imageLiteral(resourceName: "Line")
                      self.userRatingsCat.text = "USER RATINGS"
                      self.runtimeCat.text = "RUNTIME"
                      self.genreCat.text = "GENRE"
                      self.ratingCat.text = "RATING"
                      self.hideLoadingScreen()
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
                      if  genre.count != 0 {
                        self.genre.text = genre[0].name
                      }
                    }
                    self.showButtons()
                    self.lineImage.image = #imageLiteral(resourceName: "Line")
                    self.userRatingsCat.text = "USER RATINGS"
                    self.runtimeCat.text = "RUNTIME"
                    self.genreCat.text = "GENRE"
                    self.ratingCat.text = "RATING"
                    self.hideLoadingScreen()
                    self.imagesTableView.reloadData()
                  }
                }
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
                if  genre.count != 0 {
                  self.genre.text = genre[0].name
                }
              }
              self.showButtons()
              self.lineImage.image = #imageLiteral(resourceName: "Line")
              self.runtimeCat.text = "RUNTIME"
              self.genreCat.text = "GENRE"
              self.ratingCat.text = "RATING"
              self.userRatingsCat.text = "USER RATINGS"
              self.hideLoadingScreen()
              self.imagesTableView.reloadData()
            }
          }
        })
      })
    }
    else {
      DispatchQueue.main.async {
        self.hideLoadingScreen()
        CDAlertView(title: "Sorry", message: "No info available!", type: .error).show()
      }
    }
  }
  
  func hideButtons () {
    hompageButton.isHidden = true
    saveButton.isHidden = true
    videosButton.isHidden = true
  }
  
  func showButtons () {
    
    
    hompageButton.titleLabel?.minimumScaleFactor = 0.5
    hompageButton.isHidden =  false
    saveButton.isHidden = false
    videosButton.isHidden = false
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
  
  //MARK: CoreData
  func getContext () -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
  }
  
  func saveToCoreData(movieId: Double) {
    
    let managedObjectContext = getContext()
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
    let predicate = NSPredicate(format: "id == \(movieId)", movieId)
    request.predicate = predicate
    request.fetchLimit = 1
    
    do{
      let count = try managedObjectContext.count(for: request)
      
      //Check to see if current object is already saved to coreData
      if(count == 0){
        
        // no matching object currently saved
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
          NSEntityDescription.entity(forEntityName: "Movie",
                                     in: managedContext)!
        
        let id = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
        
        id.setValue(movieId, forKeyPath: "id")
        
        
        do {
          try managedContext.save()
          savedCoreDataMovieIdArray.append(id)
          CDAlertView(title: "Sucess", message: "Movie is saved to My Movies!", type: .success).show()
          
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
            CDAlertView(title: "Sorry", message: "There was an error saving movie!", type: .error).show()
        }
        
      }
      else{
        
        // at least one matching object exists
        CDAlertView(title: "Sorry", message: "Movie is already saved to My Movies!", type: .warning).show()
      }
    }
    catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
      CDAlertView(title: "Sorry", message: "There was an error!", type: .error).show()
    }
  }
  
  //MARK: IBActions
  
  @IBAction func homepageButtonPressed(_ sender: Any) {
    
    if let homepage = self.homepage {
      if let url = URL(string: homepage) {
        UIApplication.shared.open(url, options: [:])
      }  else {
        CDAlertView(title: "Sorry", message: "No web page available!", type: .error).show()
      }
    } else {
      CDAlertView(title: "Sorry", message: "No web page available!", type: .error).show()
    }
  }
  
  @IBAction func saveButtonPressed(_ sender: Any) {
    
    saveToCoreData(movieId:Double(self.iD!))
    
  }
  
  @IBAction func videosButtonPressed(_ sender: Any) {
    
    if let videoInfo = self.videoInfo {
      if videoInfo.videoResults.count != 0 {
        self.videoTapped(videoInfo: videoInfo, segueType: segueController.video)
      } else {
        CDAlertView(title: "Sorry", message: "No videos available!", type: .error).show()
      }
    }else {
      CDAlertView(title: "Sorry", message: "No videos available!", type: .error).show()
    }
  }
}

//Mark: TableView
extension MoviesDetailViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return min(1, castArray.count)
    case 1: return min(1, imageArray.count)
    case 2: return 1
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
      
      return cell
      
    case 1:
      let cell = imagesTableView.dequeueReusableCell(withIdentifier: extraReuseIdentifier)
        as! ExtraImagesCell
      
      cell.extraImagesArray = self.extraImagesArray
      cell.photosArray = self.imageArray
      cell.imageDelegate = self
      
      self.imagesTableView.rowHeight = 200
      
      return cell
      
    case 2:
      let cell = imagesTableView.dequeueReusableCell(withIdentifier: itunesReuseIdentifier) as!
      ItunesCell
      
       self.imagesTableView.rowHeight = 44
      cell.selectionStyle = UITableViewCellSelectionStyle.none
     
      return cell
      
    default: _ = ""
    }
    return cell
  }
  
  private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 5
  }
  
  private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 5
  }
}

//Delegate
extension MoviesDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      print("indexpath:\(indexPath.row)")
      self.performSegue(withIdentifier: detailToItunesSegue, sender: self)
  }
}


//Segues
extension MoviesDetailViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if self.segueType == segueController.cast {
      
      let peopleVC = segue.destination as! PeopleDetailedViewController
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
    else {
      let itunesVC = segue.destination as! ItunesCollectionViewController
      itunesVC.itunesSearchTerm = self.currentMovieTitle
    }
  }
}


//Protocols
extension MoviesDetailViewController : handleCastData, handleExtraImage, handleVideoData //handleItunesData
{
  
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
  
//  func itunesTapped(currentMovieTitle: String, segueType: segueController) {
//    self.currentMovieTitle = currentMovieTitle
//    self.segueType = segueType
//    performSegue(withIdentifier: detailToItunesSegue, sender: self)
//  }
  
}
