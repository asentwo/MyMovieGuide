//
//  MoviesMasterImageController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/6/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


class MoviesMasterImageController: UIViewController {
  
  
  var image: String?
  
  @IBOutlet weak var detailImage: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.async {
      if let imagePic = self.image {
        self.detailImage.sd_setImage(with: URL(string:"\(baseImageURL)\(imagePic)"))
      }
    }
  }
}
