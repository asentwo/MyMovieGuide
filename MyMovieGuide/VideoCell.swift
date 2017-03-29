//
//  VideoCell.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/17/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit

protocol handleVideoData {
  func videoTapped(videoInfo: VideoResults, segueType: segueController)
}

class VideoCell: UITableViewCell {
  
  @IBOutlet weak var videoWebView: UIWebView!
  
}
