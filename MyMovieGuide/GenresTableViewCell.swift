//
//  GenresTableViewCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/1/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit



class GenresTableViewCell : UITableViewCell {
  
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var genreCatagoryLabel: UILabel!

  let networkManager = NetworkManager.sharedManager
  
  var genrePoster: GenrePosters!
  var genreData: GenreData! {
    didSet {
      self.updateUI()
    }
  }

  func updateUI()// updates Tableview IBOutlets
  {
    if let genreID = genreData.id {
      
      GenrePosters.updateGenrePoster(genreID: genreID, urlExtension: "movies", completionHandler: {posters in
        
       for poster in posters{
      
          self.networkManager.downloadImage(imageExtension: "\(poster)",
            
            { (imageData) //imageData = Image data downloaded from web
              in
              let image = UIImage(data: imageData as Data)
        
              DispatchQueue.main.async(execute: { //Must update UI on main thread so have to get main queue
                self.genreCatagoryLabel.text = self.genreData.name
                self.mainImageView.image = image
              })
          })
        }
     
      })
    }
  }
}
