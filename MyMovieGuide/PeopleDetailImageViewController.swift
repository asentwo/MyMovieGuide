//
//  PeopleDetailImageViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/14/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit



class PeopleDetailImageViewController: UIViewController {
  
  
  @IBOutlet weak var peopleDetailImage: UIImageView!
  
  var personImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if let image = personImage {
    peopleDetailImage.image = image
    }
    
  }
}


extension PeopleDetailImageViewController : handleExtraCastImage {
  
  func extraCastImageTapped(image: UIImage, segue: PeopleSegue) {
    self.personImage = image
  }
  
  
}
