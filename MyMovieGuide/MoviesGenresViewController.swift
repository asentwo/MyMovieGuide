//
//  MoviesGenresViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


class MoviesGenresViewController: UIViewController {
  
  //MARK: Properties
  @IBOutlet weak var genresTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var genreDataArray: [GenreData] = []
  var posterStringArray: [String] = []
  var posterImageArray: [UIImage] = []
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving genre data")
        return
      }
      self.genreDataArray = results
      
      for movie in self.genreDataArray {
        
        if let movieGenreID = movie.id
        {
          //Update posters based on genreID
          GenrePosters.updateGenrePoster(genreID: movieGenreID, urlExtension: "movies", completionHandler: {posters in
            
            guard let posters = posters else {
              print("There was an error retrieving poster data")
              return
            }
            
            //Must iterate through multiple arrays with many containing the same poster strings
            for poster in posters {
              
              
              if let newPoster = poster {
                
                //Check to see if array already has the current poster string, if it does continue, if not append to array
                if self.posterStringArray.contains(newPoster){
                  continue
                } else {
                  self.posterStringArray.append(newPoster)
                  
                  //Use the poster string to download the corresponding poster
                  self.networkManager.downloadImage(imageExtension: "\(newPoster)",
                    { (imageData) //imageData = Image data downloaded from web
                      in
                      if let image = UIImage(data: imageData as Data){
                        self.posterImageArray.append(image)
                        
                        DispatchQueue.main.async {
                          self.genresTableView.reloadData()
                        }
                      }
                  })
                  break// Use to exit out of array after appending the corresponding poster string
                }
              } else {
                print("There was a problem retrieving poster images: \(poster)")
                continue// if the poster returned is nil, continue to iterate through arrays until there is one that is not nil
              }
            }
          })
        }
      }
    })
  }
}


//MARK: TableView Delegate/ DataSource
extension MoviesGenresViewController:  UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posterImageArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = genresTableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell") as! GenresTableViewCell
    cell.genreCatagoryLabel.text = genreDataArray[indexPath.row].name
    cell.mainImageView.image = posterImageArray[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.00
  }
}
