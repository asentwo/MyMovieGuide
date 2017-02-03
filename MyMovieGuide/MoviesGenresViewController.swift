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
  var genrePostersArray: [GenrePosters] = []
  
  
  //MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving info")
        return
      }
      self.genreDataArray = results
      
      //        for _ in self.genreDataArray {
      //          print(self.genreDataArray[0].id)
      //        }
      //
      
      //        GenrePosters.updateGenrePoster(genreID: self.genreDataArray[0].id, urlExtension: "movies", completionHandler: {posters in
      //
      //          guard let posters = posters else {
      //            print("There was an error retrieving info")
      //            return
      //          }
      //
      //          self.genrePostersArray = posters
      //
      //
      //          for _ in self.genrePostersArray {
      //            print(self.genrePostersArray[0].poster)
      //          }
      //
      //               })
      
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
    let genre = genreDataArray[indexPath.row]
    cell.genreData = genre
   
//    cell.genreCatagoryLabel.text = genreDataArray[indexPath.row].name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.00
  }
  
  
  
  
}
