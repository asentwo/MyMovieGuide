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
  var posterStringArray: [String] = []
  var posterImageArray: [UIImage] = []

  //MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving info")
        return
      }
      self.genreDataArray = results
    
      GenrePosters.updateGenrePoster(genreID: self.genreDataArray[0].id!, urlExtension: "movies", completionHandler: {posters in
        
        for poster in posters {
          
          if self.posterStringArray.contains(poster){
            continue
          } else {
            self.posterStringArray.append(poster)
            
            self.networkManager.downloadImage(imageExtension: "\(poster)",
              { (imageData) //imageData = Image data downloaded from web
                in
                let image = UIImage(data: imageData as Data)
                self.posterImageArray.append(image!)

            })
          }
        }
      })
      
      
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
