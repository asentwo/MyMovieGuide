//
//  MoviesGenresViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


class MoviesGenresViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var genresTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var genreDataArray: [GenreData] = []
  var genrePostersArray:[String] = []
  var genrePosterAlreadyPresented = [Bool](repeating: false, count:20)

  //MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving info")
        return
      }
      self.genreDataArray = results
      self.genrePosterAlreadyPresented = [Bool](repeating: false, count: self.genreDataArray.count)
      
      DispatchQueue.main.async {
        self.genresTableView.reloadData()
      }
    })
  }

  
  
  //MARK: TableView
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return genreDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = genresTableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell") as! GenresTableViewCell
    
 
    
    if let genreID = genreDataArray[indexPath.row].id {
      
      print(genreID)
      
      GenrePosters.updateGenrePoster(genreID: genreID, urlExtension: "movies", completionHandler: { posters in
      
        if self.genrePosterAlreadyPresented[indexPath.row] == false {
        
        for poster in posters {
          if self.genrePostersArray.contains(poster) { continue} else {
            self.genrePostersArray.append(poster)
            
            self.networkManager.downloadImage(imageExtension: "\(poster)", {(imageData) in
              if let image = UIImage(data: imageData as Data) {
                cell.genreCatagoryLabel.text = self.genreDataArray[indexPath.row].name
                cell.mainImageView.image = image
              }
            })
          }
        }
          
        self.genrePosterAlreadyPresented[indexPath.row] = true
          
        } else {
          print("image has already been presented")
        }
      })
    }
    return cell
  }
  
  
  //      GenrePosters.updateGenrePoster(genreID: genreID, urlExtension: genrePoster.poster, completionHandler: {
  //      poster in
  //
  //        self.networkManager.downloadImage(imageExtension: "\(poster)", {
  //          (imageData) in
  //          let image = UIImage(data: imageData as Data)
  //
  //          DispatchQueue.main.async {
  //          cell.mainImageView.image = image
  //          }
  //
  //
  //
  //        })
  //
  //
  //
  //      })
  
  
  
  
  
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.00
  }
  
  
  
  
}
