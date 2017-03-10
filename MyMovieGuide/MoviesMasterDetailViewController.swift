////
////  MoviesDetailViewController.swift
////  MyMovieGuide
////
////  Created by Justin Doo on 2/13/17.
////  Copyright © 2017 JustinDoo. All rights reserved.
////
//
import Foundation
import UIKit

enum imageDownload {
  case poster
  case cast
  case extra
}

enum segueController {
  case image
  case cast
}


class MoviesMasterDetailViewController: UIViewController, handleCastData, handleExtraImage  {
  
  
  //MARK: Properties
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet var detailTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var iD: NSNumber?
  
  var segueType: segueController?
  var castID: NSNumber?
  var extraImage: String?
  var extraImagesArray: [BackdropData]?
  
  var movieDetailsData: MovieDetailsData?
  var movieDetailsPoster: UIImage?
  var actorProfileImage: UIImage?
  
  var posterArray: [String] = []
  var overviewArray: [String] = []
  var releaseInfoArray: [String] = []
  var boxOfficeArray: [NSNumber] = []
  var homePageArray: [String] = []
  var castArray: [CastData] = []
//  var castImageArray: [String] = []
  var imageArray: [String] = []
  
//  var xImageArray: [UIImage] = []
//  var xCastImageArray: [UIImage] = []
  
  var videoArray: [VideoResults] = []
  
  let sectionTitles = ["","Overview","Release Info","Box Office", "Home Page","Cast", "Image Gallery", "Videos"]
  let releaseCatagories = ["Release Date", "Runtime", "Genre"]
  let boxOfficeCatagories = ["Budget", "Revenue"]
  
  let posterReuseIdentifier = "posterCell"
  let overviewReuseIdentifier = "overviewCell"
  let movieDetailReuseIdentifier = "movieDetailCell"
  let castResuseIdentifier = "castCell"
  let imagesReuseIdentifier = "extraImagesCell"
  let videoReuseIdentifier = "videoCell"
  
  let detailToPeopleSegueIdentifier = "detailToPeopleSegue"
  let detailToImageSegueIdentifier = "detailToImageSegue"
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Tableview settings
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    
    
    if let movieID = self.iD {
      
      MovieDetailsData.updateAllData(urlExtension: "\(movieID)", completionHandler: { results in
        
        guard let results = results else {
          print("There was an error retrieving upcoming movie data")
          return
        }
        
        self.movieDetailsData = results
        self.navigationItem.title = self.movieDetailsData?.title
        self.extraImagesArray = self.movieDetailsData?.images?.backdropImages
        
        CastData.updateAllData(urlExtension: "\(movieID)/credits", completionHandler: { results in
          
          guard let results = results else {
            print("There was an error retrieving upcoming movie data")
            return
          }
          self.castArray = results
          
          print("Pre-cell castArray count:\(self.castArray.count)")
          
//          for cast in self.castArray {
//            
//            if cast.profilePic != nil {
//              if let castPic = cast.profilePic {
//                self.castImageArray.append(castPic)
//           //     self.updateImage(imageType: imageDownload.cast, ext: castPic)
//              }
//            } else {
//          //    print("actor pic does not exist: \(cast.name)")
//              continue
//            }
//          }
          
          self.appendAllData(completion: { _ in
            //Nothing inside here gets called
            DispatchQueue.main.async {
              
              //   print(self.movieDetailsData?.poster )
              
              if let bgImage = self.movieDetailsData?.poster {
                self.backgroundImage.sd_setImage(with: URL(string:"\(baseImageURL)\(bgImage)"))
                //    print("background pic loaded")
                self.backgroundImage.addBlurEffect()
              }
              
              self.detailTableView.reloadData()
            }
          })
        })
       
      })
      
//      DispatchQueue.main.async {
//        if let bgImage = self.movieDetailsData?.poster {
//          self.backgroundImage.sd_setImage(with: URL(string:"\(baseImageURL)\(bgImage)"))
//          print("background pic loaded")
//          self.backgroundImage.addBlurEffect()
//        }
//      }
    }
  }
}


//MARK: Update and Append all Data Functions
extension MoviesMasterDetailViewController {
  
//  func updateImage(imageType: imageDownload, ext: String) {
//    
//    self.networkManager.downloadImage(imageExtension: "\(ext)", {
//      (imageData) in
//      if let image = UIImage(data: imageData as Data) {
//        
////                switch imageType {
////        
////                case imageDownload.poster:
////                  self.movieDetailsPoster = image
////                  DispatchQueue.main.async {
////        
////                    //Set background image and blur
////                    self.backgroundImage.image = self.movieDetailsPoster
////                    self.backgroundImage.addBlurEffect()
////                  }
////         case imageDownload.cast:
////         self.xCastImageArray.append(image)
////        
//        
//        //  case imageDownload.extra:
//        self.xImageArray.append(image)
//    
//                }
//        
//        
//  //    }
//      DispatchQueue.main.async {
//        
//        self.detailTableView.reloadData()
//      }
//      
//    })
//  }
//  
  
  func appendAllData (completion: () -> Void) {
    
    guard let movieDetails = self.movieDetailsData else {
      // handle nil case
      return;
    }
    
    if let posterImage = self.movieDetailsData?.poster {
      self.posterArray.append(posterImage)
    }
    
    if let overview = self.movieDetailsData?.overview {
      self.overviewArray.append(overview)
    }
    
    if let releaseDate = self.movieDetailsData?.releaseData {
      self.releaseInfoArray.append(releaseDate)
    }
    
    if let runtime = self.movieDetailsData?.runtime {
      self.releaseInfoArray.append(String(describing: runtime))
    }
    
    if let genre = self.movieDetailsData?.genre {
      if !genre.isEmpty {
        self.releaseInfoArray.append(genre[0].name)
      }
    }
    
    if let budget = self.movieDetailsData?.budget {
      self.boxOfficeArray.append(budget)
    }
    
    if let revenue = self.movieDetailsData?.revenue {
      self.boxOfficeArray.append(revenue)
    }
    
    if let homepage = self.movieDetailsData?.homepage {
      self.homePageArray.append(homepage)
    }
    
    if let images = self.movieDetailsData?.images {
      self.imageArray += images.backdropImages.map{ $0.filePath }
    }
    completion()
  }
//  func appendAllData (completion: () -> Void) {
//    
//    if self.movieDetailsData?.poster != nil {
//      if let posterImage = self.movieDetailsData?.poster {
//        self.updateImage(imageType: imageDownload.poster, ext: posterImage)
//        self.posterArray.append(posterImage)
//      }
//    }
//    
//    if self.movieDetailsData?.overview != nil {
//      if let overview = self.movieDetailsData?.overview {
//        self.overviewArray.append(overview)
//      }
//    }
//    
//    if self.movieDetailsData?.releaseData != nil {
//      if let releaseDate = self.movieDetailsData?.releaseData {
//        self.releaseInfoArray.append(releaseDate)
//      }
//    }
//    
//    if self.movieDetailsData?.runtime != nil {
//      if let runtime = self.movieDetailsData?.runtime {
//        self.releaseInfoArray.append(String(describing: runtime))
//      }
//    }
//    
//    if self.movieDetailsData?.genre != nil {
//      if let genre = self.movieDetailsData?.genre {
//        if genre.isEmpty {
//        } else {
//          self.releaseInfoArray.append(genre[0].name)
//        }
//      }
//    }
//    
//    if self.movieDetailsData?.budget != nil {
//      if let budget = self.movieDetailsData?.budget {
//        self.boxOfficeArray.append(budget)
//      }
//    }
//    
//    if self.movieDetailsData?.revenue != nil {
//      if let revenue = self.movieDetailsData?.revenue {
//        self.boxOfficeArray.append(revenue)
//      }
//    }
//    
//    if self.movieDetailsData?.homepage != nil {
//      if let homepage = self.movieDetailsData?.homepage {
//        self.homePageArray.append(homepage)
//      }
//    }
//    
//    if self.movieDetailsData?.images != nil {
//      if let images = self.movieDetailsData?.images {
//        
//        let posters = images.backdropImages
//        for poster in posters {
//          
//          self.imageArray.append(poster.filePath)
//          self.updateImage(imageType: imageDownload.extra, ext: poster.filePath)
//        }
//      }
//    }
//  }
}



//MARK: TableView Datasource
extension  MoviesMasterDetailViewController: UITableViewDataSource {
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0: return posterArray.count
    case 1: return overviewArray.count
    case 2: return releaseInfoArray.count
    case 3: return boxOfficeArray.count
    case 4: return homePageArray.count
    case 5: return min(1, castArray.count)
    case 6: return min(1, imageArray.count)
    case 7: return 1
      
    default: fatalError("Unknown Selection")
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    switch indexPath.section {
      
    case 0:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: posterReuseIdentifier) as! PosterCell
      
      // cell.mainPosterImage.image = self.movieDetailsPoster
      
      // print(movieDetailsData?.poster)
      
      //      if let poster = movieDetailsData?.poster {
      cell.mainPosterImage.sd_setImage(with: URL(string:"\(baseImageURL)\(posterArray[indexPath.row])"))
      //
      //  print(URL(string:"\(baseImageURL)\(posterArray[indexPath.row])"))
      //   }
      
      
      self.detailTableView.rowHeight = 400
      detailTableView.allowsSelection = false
      return cell
      
    case 1:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: overviewReuseIdentifier) as! OverviewCell
      
      let overviewText = overviewArray[indexPath.row]
      cell.overviewTextLabel.text = overviewText
      
      self.detailTableView.rowHeight = 200
      detailTableView.allowsSelection = false
      return cell
      
    case 2:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let releaseInfo = releaseInfoArray[indexPath.row]
      
      cell.catagoryLabel.text = releaseCatagories[indexPath.row]
      cell.catagoryDataLabel.text = releaseInfo
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = false
      return cell
      
    case 3:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let boxOfficeInfo = boxOfficeArray[indexPath.row]
      
      if boxOfficeInfo != 0 {
        cell.catagoryLabel.text = boxOfficeCatagories[indexPath.row]
        cell.catagoryDataLabel.text = String(describing: boxOfficeInfo)
      }
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = false
      
      return cell
      
    case 4:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let homepage = homePageArray[indexPath.row]
      
      cell.catagoryLabel.text = "Homepage"
      cell.catagoryDataLabel.text = homepage
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = false
      
      return cell
      
    case 5:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: castResuseIdentifier)
        as! CastCell
      print("Cast Array Count:\(castArray.count)")
              cell.castPhotosArray = self.castArray
     //  cell.castImagesArray = self.castImageArray
        cell.imageDelegate = self
  
 
      self.detailTableView.rowHeight = 100
      detailTableView.allowsSelection = true
      
      return cell
      
    case 6:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: imagesReuseIdentifier)
        as! ExtraImagesCell
      
      cell.extraImagesArray = self.extraImagesArray
      cell.photosArray = self.imageArray
      cell.imageDelegate = self
      
      self.detailTableView.rowHeight = 200
      detailTableView.allowsSelection = true
      
      return cell
      
    case 7:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: videoReuseIdentifier)
        as! VideoCell
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = true
      
      return cell
      
    default: _ = ""
      
    }
    
    return cell
  }
  
}


extension MoviesMasterDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("row pressed: \(indexPath.row)")
  }
  
}


//MARK: TableView Custom Headers
extension MoviesMasterDetailViewController {
  
  //TableView Style must be set to 'Grouped' in storyboard in order to avoid 'floating' headers
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let view = UIView()
    
    switch section {
    case 0: break
      
    default:
      
      view.backgroundColor = UIColor.clear
      let image = UIImageView(image: #imageLiteral(resourceName: "Line"))
      image.frame = CGRect(x: 8, y: 35, width: 340, height: 1)
      view.addSubview(image)
      
      let label = UILabel()
      let sectionText = self.sectionTitles[section]
      label.text = sectionText
      label.textColor = UIColor.white
      label.font = UIFont(name:"Helvetica Neue" , size: 17)
      label.frame = CGRect(x: 10, y: 8, width: 200, height: 20)
      view.addSubview(label)
    }
    return view
  }
  
  //HeightForHeaderInSection must be implemented also unless the custom header won't work!!!!
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let headerHeight: CGFloat
    
    switch section {
    case 0:
      // hide the first section header
      headerHeight = CGFloat.leastNonzeroMagnitude
    default:
      headerHeight = 40
    }
    return headerHeight
  }
}


//Segue
extension MoviesMasterDetailViewController {
  
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
extension MoviesMasterDetailViewController {
  
  func imageTapped(ID castID: NSNumber, segueType: segueController) {
    self.castID = castID
    self.segueType = segueType
    performSegue(withIdentifier: detailToPeopleSegueIdentifier, sender: self)
  }
  
  func extraImageTapped(Image: String, segueType: segueController) {
    self.extraImage = Image
    self.segueType = segueType
    performSegue(withIdentifier: detailToImageSegueIdentifier, sender: self)
  }}
