//
//  PeopleDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/21/17.
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


class PeopleDetailViewController : UIViewController {
  
  
  @IBOutlet weak var peopleDetailTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  
  var id: NSNumber?
  var knownForID: NSNumber?
  var currentImage: UIImage?
  var currentSegue: PeopleSegue?
  
  var profileImage: UIImage?
  var profileData: PeopleData?
  var knownForData: CastExtended?
  var bioArray: [String] = []
  var castCrewArray: [String] = []
  
  var personalImagesArray: [UIImage] = []
  var profileImagesArray: [ImageData] = []
  
  var knownForArray: [UIImage] = []
  var knownForExtendedArray: [CastExtendedData] = []
  
  var setionTitles = ["", "Bio", "Images", "Known For"]
  
  //Particle loading screen
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
  
  //Reuse Identifiers
  let profileCellIdentifier = "actorProfileCell"
  let titleCellIndetifier = "titleCell"
  let bioCellIdentifier = "bioCell"
  let crewDetailCellIdentifier = "crewDetailsCell"
  let imagesCellIdentifier = "imagesCell"
  let knownForCellIdentifier = "knownForCell"
  
  let peopleToDetailSegue = "peopleToMovieDetailSegue"
  let peopleDetailToImageSegue = "peopleDetailToImageSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //keeps top of tableview from going under nav bar
    self.peopleDetailTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
    
    startLoadingScreen()
    
    if let personID = self.id {
      
      PeopleData.updateAllData(urlExtension: "\(personID)", completionHandler: { results in
        
        guard let results = results else {
          print("There was an error retrieving people data")
          return
        }
        
        self.profileData = results
        
        if self.profileData?.images != nil {
          
          //Hide loading screen
          DispatchQueue.main.async {
            self.label.isHidden = true
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            self.peopleDetailTableView.reloadData()
          }
          
          
          if let profileImages = self.profileData?.images{
            
            self.profileImagesArray = profileImages.images
            
            let profileImage = profileImages.images
            
            for profile in profileImage {
              
              self.updateImage(ImageType: DownloadPic.personal, ImageString: profile.filePath)
              
              DispatchQueue.main.async {
                self.peopleDetailTableView.reloadData()
              }
            }
          }
        }
        if self.profileData?.bio != nil {
          if let bio = self.profileData?.bio {
            
            self.bioArray.append(bio)
          }
        }
        
//        if let actorProfileImage = self.profileData?.profile {
//          
//          self.updateImage(ImageType: DownloadPic.profile, ImageString: actorProfileImage)
//          
//        } else {
//          print("actor pic doesn't exist")
//        }
        
        CastExtendedData.updateAllData(urlExtension: "\(personID)/movie_credits", completionHandler: {results in
          
          guard let results = results else {
            print("There was an error retrieving cast extended data")
            return
          }
          
          self.knownForData = results
          
          if self.knownForData?.castExtended != nil {
            
            if let knownFor = self.knownForData?.castExtended {
              
              self.knownForExtendedArray = knownFor
              
              for knownForImage in knownFor {
                
                if let poster = knownForImage.poster {
                  self.updateImage(ImageType: DownloadPic.knownFor, ImageString: poster)
                  
                  DispatchQueue.main.async {
                    self.peopleDetailTableView.reloadData()
                  }

                }
              }
            }
          }
        })
      }
      )
    }
  }
  
  func updateImage (ImageType: DownloadPic, ImageString: String) {
    
    self.networkManager.downloadImage(imageExtension: "\(ImageString)", { (imageData) in
      
      if let image = UIImage(data: imageData as Data) {
        
        switch ImageType {
        case DownloadPic.profile: self.profileImage = image
        case DownloadPic.personal: if let image = UIImage(data: imageData as Data){ self.personalImagesArray.append(image)}
        case DownloadPic.knownFor: if let image = UIImage(data: imageData as Data){self.knownForArray.append(image)}
          break
        }
//        DispatchQueue.main.async {
//          self.peopleDetailTableView.reloadData()
//        }
      }
    })
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


extension PeopleDetailViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0: return 1
    case 1: return bioArray.count
    case 2: return min(1, personalImagesArray.count)
    case 3: return min(1, personalImagesArray.count)
    default: fatalError("Unknown Selection")
      
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    switch indexPath.section {
    case 0:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: profileCellIdentifier) as! ActorProfileCell
      
      if let name = profileData?.name{
        cell.actorNameLabel.text = name
      }
      
      if profileData?.birthDay != nil {
        if let birthday = profileData?.birthDay{
          cell.birthdayLabel.text = birthday
        }
      }else {
        cell.birthdayLabel.text = "N/A"
      }
      
      if profileData?.birthPlace != nil {
        if let birthplace = profileData?.birthPlace {
          cell.birthPlaceLabel.text = birthplace
        }
      } else {
        cell.birthPlaceLabel.text = "N/A"
      }
      
      if let profile = profileData?.profile {
        cell.actorProfileImage.sd_setImage(with: URL(string: "\(baseImageURL)\(profile)"))
      }
      
      cell.actorProfileImage.layer.cornerRadius =
        cell.actorProfileImage.frame.size.height/2
      cell.actorProfileImage.layer.masksToBounds = true
      cell.actorProfileImage.clipsToBounds = true
      
      
      self.peopleDetailTableView.rowHeight = 150
      
      return cell
      
    case 1:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: bioCellIdentifier) as! BioCell
      
      if profileData?.bio != nil {
        if let bio = profileData?.bio {
          cell.bioText.text = bio
        }
      } else {
        cell.bioText.text = "N/A"
      }
      
      self.peopleDetailTableView.rowHeight = 200
      
      return cell
      
    case 2:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: imagesCellIdentifier) as! ImagesPeopleCell
      
      cell.imageDelegate = self
      cell.extraPhotosArray = self.personalImagesArray
      cell.profileImagesArray = self.profileImagesArray
      
      self.peopleDetailTableView.rowHeight = 150
      return cell
      
    case 3:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: knownForCellIdentifier) as! KnownForCell
      
      cell.imageDelegete = self
      cell.knownForExtendedArray = self.knownForExtendedArray
      cell.knownForArray = self.knownForArray
      self.peopleDetailTableView.rowHeight = 150
      
      return cell
      
    default:
      _ = ""
    }
    return cell
  }
}

//MARK: TableView Custom Headers
extension PeopleDetailViewController {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    
    switch section {
    case 0: break
      
    default:
      
      view.backgroundColor = UIColor.clear
      let image = UIImageView(image: #imageLiteral(resourceName: "Line"))
      image.frame = CGRect(x: 8, y: 35, width: 340, height: 1)
      view.addSubview(image)
      
      let label = UILabel()
      let sectionText = self.setionTitles[section]
      label.text = sectionText
      label.textColor = UIColor.white
      label.font = UIFont(name: "Helvetica Neue", size: 17)
      label.frame = CGRect(x: 10, y: 8, width: 200, height: 20)
      view.addSubview(label)
    }
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let headerHeight: CGFloat
    
    switch section {
    case 0:
      headerHeight = CGFloat.leastNonzeroMagnitude
    default:
      headerHeight = 40
    }
    return headerHeight
  }
  
}

//Segue
extension PeopleDetailViewController{
  
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
extension PeopleDetailViewController: handleKnownForImage, handleExtraCastImage {
  
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


