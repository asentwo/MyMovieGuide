//
//  PeopleDetailedViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/17/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import ParticlesLoadingView
import CDAlertView

enum DownloadPic {
  
  case profile
  case personal
  case knownFor
  
}

enum PeopleSegue {
  
  case knownFor
  case extraImage
  
}

class PeopleDetailedViewController : UIViewController {
  
  @IBOutlet weak var peopleImagesTableView: UITableView!
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var birthdayLabel: UILabel!
  @IBOutlet weak var birthplaceLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var backgroundPic: UIImageView!
  
  let networkManager = NetworkManager.sharedManager
  
  var id: NSNumber?
  var knownForID: NSNumber?
  var currentImage: UIImage?
  var currentSegue: PeopleSegue?
  var profileImage: UIImage?
  var profileData: PeopleData?
  var knownForData: CastExtended?
  var extraImagesArray: [ImageData] = []
  var personalImagesArray: [UIImage] = []
  var knownForArray: [UIImage] = []
  var knownForExtendedArray: [CastExtendedData] = []
  
  //Particle loading screen
  lazy var loadingView: ParticlesLoadingView = {
    let x = self.view.frame.size.width/2
    let y = self.view.frame.size.height/2
    let view = ParticlesLoadingView(frame: CGRect(x: x - 50, y: y - 100, width: 100, height: 100))
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
  
  let imagesCellIdentifier = "imagesCell"
  let knownForCellIdentifier = "knownForCell"
  let peopleToDetailSegue = "peopleToMovieDetailSegue"
  let peopleDetailToImageSegue = "peopleDetailToImageSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    startLoadingScreen()
    roundImageViewCorners(imageView:profilePic)
    
    if let personID = self.id {
      
      PeopleData.updateAllData(urlExtension: "\(personID)", completionHandler: { results in
        
        guard let results = results else {
          print("There was an error retrieving people data")
          return
        }
        
        self.profileData = results
        
        if self.profileData?.images != nil {
          
          //Hide loading screen
//          DispatchQueue.main.async {
//            self.label.isHidden = true
//            self.loadingView.isHidden = true
//            self.loadingView.stopAnimating()
//            self.peopleImagesTableView.reloadData()
//          }
          
          if let profilePic = self.profileData?.profile {
            self.profilePic.sd_setImage(with: URL(string: "\(baseImageURL)\(profilePic)"),placeholderImage: UIImage(named: "placeholder.png"))
          }
          
          
          if let birthday = self.profileData?.birthDay {
            
            self.birthdayLabel.text = birthday
          }
          
          if let birthplace = self.profileData?.birthPlace {
            
            self.birthplaceLabel.text = birthplace
          }
          
          if self.profileData?.bio != nil {
            if let bio = self.profileData?.bio {
              
              self.bioLabel.text = bio
            }
          }
          
          if let extraImages = self.profileData?.images{
            
            self.extraImagesArray = extraImages.images
            
            let extraImages = extraImages.images
            
            for image in extraImages {
              
              self.updateImage(ImageType: DownloadPic.personal, ImageString: image.filePath, completion: {_ in
              })
            }
          }
          
          
          CastExtendedData.updateAllData(urlExtension: "\(personID)/movie_credits", completionHandler: {results in
            
            guard let results = results else {
              print("There was an error retrieving cast extended data")
              return
            }
            
            self.knownForData = results
            
            if let knownFor = self.knownForData?.castExtended {
              
              self.knownForExtendedArray = knownFor
            
              if let bg = knownFor[0].poster {
               self.backgroundPic.sd_setImage(with: URL(string: "\(baseImageURL)\(bg)"))
              
                
                
              }
              
              for knownForImage in knownFor {
                
                if let poster = knownForImage.poster {
                  self.updateImage(ImageType: DownloadPic.knownFor, ImageString: poster, completion: {_ in
                    
                    
                    DispatchQueue.main.async {
                      
                      self.label.isHidden = true
                      self.loadingView.isHidden = true
                      self.loadingView.stopAnimating()
                      self.peopleImagesTableView.reloadData()
                    }
                    
                  })
                  
                  }
              }
            }
          })
        }
      }
      )

 
   

    }
  }
  
  func updateImage (ImageType: DownloadPic, ImageString: String, completion: @escaping () -> Void) {
    
    self.networkManager.downloadImage(imageExtension: "\(ImageString)", { (imageData) in
      
      if let image = UIImage(data: imageData as Data) {
        
        switch ImageType {
        case DownloadPic.profile: self.profileImage = image
        case DownloadPic.personal: if let image = UIImage(data: imageData as Data){ self.personalImagesArray.append(image)}
        case DownloadPic.knownFor: if let image = UIImage(data: imageData as Data){self.knownForArray.append(image)}
          break
        }
      }
      
      completion()
    })
  }
  
  func startLoadingScreen () {
    label.center = CGPoint(x: 187, y: 285)
    label.textAlignment = .center
    label.text = "Loading"
    label.font = UIFont(name: "Avenir Next Medium", size: 17)
    label.textColor = UIColor.white
    self.view.addSubview(label)
    view.addSubview(loadingView)
    loadingView.startAnimating()
  }
  
  private func convertToGrayScale(image: CGImage) -> CGImage {
    let height = image.height
    let width = image.width
    let colorSpace = CGColorSpaceCreateDeviceGray();
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
    let context = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    context.draw(image, in: rect)
    return context.makeImage()!
  }
  
}

extension PeopleDetailedViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0: return min(1, personalImagesArray.count)
    case 1: return min(1, knownForArray.count)
    default: fatalError("Unknown Selection")
      
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    switch indexPath.section {
    case 0:
      let cell = peopleImagesTableView.dequeueReusableCell(withIdentifier: imagesCellIdentifier) as! ImagesPeopleCell
      
      cell.imageDelegate = self
      cell.extraPhotosArray = self.personalImagesArray
      cell.profileImagesArray = self.extraImagesArray
      self.peopleImagesTableView.rowHeight = 150
      return cell
      
    case 1:
      let cell = peopleImagesTableView.dequeueReusableCell(withIdentifier: knownForCellIdentifier) as! KnownForCell
      
      cell.imageDelegete = self
      cell.knownForExtendedArray = self.knownForExtendedArray
      cell.knownForArray = self.knownForArray
      self.peopleImagesTableView.rowHeight = 150
      
      return cell
      
    default:
      _ = ""
    }
    return cell
  }
}

//Segue
extension PeopleDetailedViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if self.currentSegue == PeopleSegue.knownFor {
      
      let destinationVC = segue.destination as! MoviesDetailViewController
      
      destinationVC.iD = self.knownForID
    } else if self.currentSegue == PeopleSegue.extraImage {
      
      let destinationVC = segue.destination as! PeopleDetailImageViewController
      
      destinationVC.personImage = currentImage
    }
  }
}

//Protocol
extension PeopleDetailedViewController: handleKnownForImage, handleExtraCastImage {
  
  func knownForImageTapped(movieID: NSNumber, segue: PeopleSegue) {
    self.knownForID = movieID
    self.currentSegue = PeopleSegue.knownFor
    performSegue(withIdentifier: peopleToDetailSegue, sender: self)
  }
  
  func extraCastImageTapped(image: UIImage, segue: PeopleSegue) {
    self.currentImage = image
    self.currentSegue = PeopleSegue.extraImage
    performSegue(withIdentifier: peopleDetailToImageSegue, sender: self)
    
  }
}



