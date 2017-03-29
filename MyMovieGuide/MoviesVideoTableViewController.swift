//
//  MoviesMasterVideoController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/28/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import CDAlertView


class MoviesVideoTableViewController: MasterViewController {
  
  
  @IBOutlet weak var videoTableView: UITableView!
  
  var videoInfo: VideoResults?
  var videoURLArray:[URL] = []
  
  let videoReuseIdentifier = "videoCell"
  let videoTableViewToDetailSegue = "videoTableViewToDetailSegue"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    
    if let video = videoInfo?.videoResults {
      
      for videoData in video {
        if let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoData.key)") {
          self.videoURLArray.append(youtubeURL)
        } else {
        CDAlertView(title: "Sorry", message: "No videos available!", type: .error).show()
        }
         hideLoadingScreen()
        videoTableView.reloadData()
      }
    }
  }
}

extension MoviesVideoTableViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return videoURLArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = videoTableView.dequeueReusableCell(withIdentifier: videoReuseIdentifier) as! VideoCell
    
    cell.videoWebView.loadRequest(URLRequest(url: self.videoURLArray[indexPath.row]))
    
    videoTableView.rowHeight = 220
    return cell
  }
}

