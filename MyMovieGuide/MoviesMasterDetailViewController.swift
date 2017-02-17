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
  var releaseInfoArray: [Any] = []
  var boxOfficeArray: [Any] = []
  var homePageArray: [Any] = []
  var castArray: [CastData] = []
  var imageArray: [ImageResults] = []
  var videoArray: [VideoResults] = []
  
  let sectionTitles = ["","Overview","Release Info","Box Office", "Home Page","Cast", "Image Gallery", "Videos"]
  let catagories = ["Overview", "Release Date", "Runtime", "Genre", "Budget", "Revenue", "Home Page", "Image Gallery", "Videos"]
  
  let posterReuseIdentifier = "posterCell"
  let overviewReuseIdentifier = "overviewCell"
  
  
  
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
        
        print(overview)
        
        self.overviewArray.append(overview)
      }
    }
    
    if self.movieDetailsData?.releaseData != nil {
      if let releaseDate = self.movieDetailsData?.releaseData {
        
        print(releaseDate)
        
        self.releaseInfoArray.append(releaseDate)
      }
    }
    
    if self.movieDetailsData?.runtime != nil {
      if let runtime = self.movieDetailsData?.runtime {
        
        print(runtime)
        
        self.releaseInfoArray.append(runtime)
      }
    }
    
    if self.movieDetailsData?.genre != nil {
      if let genre = self.movieDetailsData?.genre {
        
        print(genre)
        
        self.releaseInfoArray.append(genre)
      }
    }
    
    if self.movieDetailsData?.budget != nil {
      if let budget = self.movieDetailsData?.budget {
        
        print(budget)
        
        self.boxOfficeArray.append(budget)
      }
    }
    
    if self.movieDetailsData?.revenue != nil {
      if let revenue = self.movieDetailsData?.revenue {
        
        print(revenue)
        
        self.boxOfficeArray.append(revenue)
      }
    }
    
    if self.movieDetailsData?.homepage != nil {
      if let homepage = self.movieDetailsData?.homepage {
        
        print(homepage)
        
        self.homePageArray.append(homepage)
      }
    }
    
    if self.movieDetailsData?.images != nil {
      if let images = self.movieDetailsData?.images {
        
        print(images)
        
        self.imageArray.append(images)
      }
    }
    
    if self.movieDetailsData?.videos != nil {
      if let videos = self.movieDetailsData?.videos {
        
        print(videos)
        
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
    let cell = detailTableView.dequeueReusableCell(withIdentifier: posterReuseIdentifier) as! PosterCell
    
    cell.mainPosterImage.image = self.movieDetailsPoster
    
    return cell
  }
  
}

