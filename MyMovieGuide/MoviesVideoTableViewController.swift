//
//  MoviesMasterVideoController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/28/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import ParticlesLoadingView
import CDAlertView


class MoviesVideoTableViewController: UIViewController {
  
  
  @IBOutlet weak var videoTableView: UITableView!
  
  var videoInfo: VideoResults?
  var videoURLArray:[URL] = []
  
  // Particle loading screen
  lazy var loadingView: ParticlesLoadingView = {
    let x = self.view.frame.size.width/2
    let y = self.view.frame.size.height/2
    let view = ParticlesLoadingView(frame: CGRect(x: x - 50, y: y - 20, width: 100, height: 100))
    view.particleEffect = .laser
    view.duration = 1.5
    view.particlesSize = 15.0
    view.clockwiseRotation = true
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.borderWidth = 1.0
    view.layer.cornerRadius = 15.0
    return view
  }()
  
  let label = UILabel(frame: CGRect(x: 0 + 20, y: 0, width: 200, height: 21))
  
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
        CDAlertView(title: "Sorry", message: "No videos available!", type: .notification).show()
        }
        self.label.isHidden = true
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        videoTableView.reloadData()
      }
    }
  }
  
  func startLoadingScreen () {
    label.center = CGPoint(x: 190, y: 365)
    label.textAlignment = .center
    label.text = "Loading"
    label.textColor = UIColor.white
    self.view.addSubview(label)
    view.addSubview(loadingView)
    loadingView.startAnimating()
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

