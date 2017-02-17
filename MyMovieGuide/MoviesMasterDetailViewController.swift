////
////  MoviesUpcomingDetailViewController.swift
////  MyMovieGuide
////
////  Created by Justin Doo on 2/13/17.
////  Copyright © 2017 JustinDoo. All rights reserved.
////
//
import Foundation
import UIKit



class MoviesMasterDetailViewController: UIViewController {
  
  
  //MARK: Properties
  @IBOutlet var detailTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var iD: NSNumber?
  
  var movieDetailsData: MovieDetailsData?
  var movieDetailsPoster: UIImage?
  
  var posterArray: [String] = []
  var overviewArray: [String] = []
  var releaseInfoArray: [String] = []
  var boxOfficeArray: [NSNumber] = []
  var homePageArray: [String] = []
  var castArray: [CastData] = []
  var imageArray: [ImageResults] = []
  var videoArray: [VideoResults] = []
  
  let sectionTitles = ["","Overview","Release Info","Box Office", "Home Page","Cast", "Image Gallery", "Videos"]
  let releaseCatagories = ["Release Date", "Runtime", "Genre"]
  let boxOfficeCatagories = ["Budget", "Revenue"]

  
  let posterReuseIdentifier = "posterCell"
  let overviewReuseIdentifier = "overviewCell"
  let movieDetailReuseIdentifier = "movieDetailCell"
  
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    
    if let movieID = self.iD {
      
      MovieDetailsData.updateAllData(urlExtension: "\(movieID)", completionHandler: { results in
        
        guard let results = results else {
          print("There was an error retrieving upcoming movie data")
          return
        }
        
        self.movieDetailsData = results
        self.navigationItem.title = self.movieDetailsData?.title
        self.appendAllData()
        
      })
    }
  }
  
  
  
  func updateImage(poster: String) {
    
    self.networkManager.downloadImage(imageExtension: "\(poster)", {
      (imageData) in
      if let image = UIImage(data: imageData as Data){
        self.movieDetailsPoster = image
        
        DispatchQueue.main.async {
          self.detailTableView.reloadData()
        }
      }
    })
  }
  
  
  func appendAllData () {
    
    if self.movieDetailsData?.poster != nil {
      if let posterImage = self.movieDetailsData?.poster {
        self.updateImage(poster: posterImage)
        self.posterArray.append(posterImage)
      }
      
    } else if self.movieDetailsData?.backdrop != nil {
      if let backdropImage = self.movieDetailsData?.backdrop {
        self.updateImage(poster: backdropImage)
        self.posterArray.append(backdropImage)
      }
    } else {
      print("poster does not exist: \(self.movieDetailsData?.title)")
      self.movieDetailsPoster = #imageLiteral(resourceName: "placeholder")
    }
    
    if self.movieDetailsData?.overview != nil {
      if let overview = self.movieDetailsData?.overview {
        self.overviewArray.append(overview)
      }
    }
    
    if self.movieDetailsData?.releaseData != nil {
      if let releaseDate = self.movieDetailsData?.releaseData {
        self.releaseInfoArray.append(releaseDate)
      }
    }
    
    if self.movieDetailsData?.runtime != nil {
      if let runtime = self.movieDetailsData?.runtime {
        self.releaseInfoArray.append(String(describing: runtime))
      }
    }
    
    if self.movieDetailsData?.genre != nil {
      if let genre = self.movieDetailsData?.genre {
        self.releaseInfoArray.append(genre[0].name)
      }
    }
    
    if self.movieDetailsData?.budget != nil {
      if let budget = self.movieDetailsData?.budget {
        self.boxOfficeArray.append(budget)
      }
    }
    
    if self.movieDetailsData?.revenue != nil {
      if let revenue = self.movieDetailsData?.revenue {
        self.boxOfficeArray.append(revenue)
      }
    }
    
    if self.movieDetailsData?.homepage != nil {
      if let homepage = self.movieDetailsData?.homepage {
        self.homePageArray.append(homepage)
      }
    }
    
    if self.movieDetailsData?.images != nil {
      if let images = self.movieDetailsData?.images {
        self.imageArray.append(images)
      }
    }
    
    if self.movieDetailsData?.videos != nil {
      if let videos = self.movieDetailsData?.videos {
        self.videoArray.append(videos)
      }
    }
  }
}



//MARK: TableView Datasource
extension  MoviesMasterDetailViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
  
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
    case 5: return castArray.count
    case 6: return imageArray.count
    case 7: return videoArray.count
      
    default: fatalError("Unknown Selection")
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    switch indexPath.section {
      
    case 0:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: posterReuseIdentifier) as! PosterCell
      
      cell.mainPosterImage.image = self.movieDetailsPoster
      
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
      cell.catagoryDataLabel.text = releaseInfo as? String
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = false
      return cell
      
    case 3:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let boxOfficeInfo = boxOfficeArray[indexPath.row]
      
      cell.catagoryLabel.text = boxOfficeCatagories[indexPath.row]
      cell.catagoryDataLabel.text = String(describing: boxOfficeInfo)
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
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let cast = castArray[indexPath.row]
      cell.catagoryLabel.text = "Cast"
      cell.catagoryDataLabel.text = cast as? String
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = false
      
      return cell
      
    case 6:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let images = imageArray[indexPath.row]
      
      cell.catagoryLabel.text = "Images"
      cell.catagoryDataLabel.text = images as? String
      
      self.detailTableView.rowHeight = 200
      detailTableView.allowsSelection = false
      
      return cell
      
    case 7:
      let cell = detailTableView.dequeueReusableCell(withIdentifier: movieDetailReuseIdentifier)
        as! MovieDetailCell
      
      let video = videoArray[indexPath.row]
      
      cell.catagoryLabel.text = "Videos"
      cell.catagoryDataLabel.text = video as? String
      
      self.detailTableView.rowHeight = 50
      detailTableView.allowsSelection = false
      
      return cell
      
    default: _ = ""
      
    }
    
    return cell
  }
  
}
