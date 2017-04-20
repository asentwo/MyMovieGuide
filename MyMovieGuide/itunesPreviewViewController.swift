//
//  itunesPreviewViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 4/19/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import CDAlertView
import ParticlesLoadingView
//import StoreKit

class itunesPreviewViewController: MasterViewController {
  
  var previewURL: URL?
  
  
  @IBOutlet weak var itunesPreview: UIWebView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    startLoadingScreen()
    
    if let url = self.previewURL {
       UIApplication.shared.openURL(url)
      self.hideLoadingScreen()
    }

  }
}
