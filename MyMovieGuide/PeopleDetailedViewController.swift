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

class PeopleDetailedViewController : MasterViewController {
  
  @IBOutlet weak var knownForTableView: UITableView!
  @IBOutlet weak var peopleImagesTableView: UITableView!
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var birthdayCatLabel: UILabel!
  @IBOutlet weak var birthdayLabel: UILabel!
  @IBOutlet weak var birthplaceCatLabel: UILabel!
  @IBOutlet weak var birthplaceLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var backgroundPic: UIImageView!
  @IBOutlet weak var backgroundTintView: UIImageView!
  @IBOutlet weak var filmographyLabel: UILabel!
  
  let networkManager = NetworkManager.sharedManager
  
  let alert = CDAlertView(title: "Sorry", message: "There was a problem retrieving data", type: .error)
  
  var connectedToNetwork: Bool = true
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
  let imagesCellIdentifier = "imagesCell"
  let knownForCellIdentifier = "knownForCell"
  let peopleToDetailSegue = "peopleToMovieDetailSegue"
  let peopleDetailToImageSegue = "peopleDetailToImageSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.hideAllLabels()
    self.navigationController?.navigationBar.tintColor = UIColor.white
    startLoadingScreen()
    roundImageViewCorners(imageView:profilePic)
    
    if let personID = self.id {
      
      PeopleData.updateAllData(urlExtension: "\(personID)", completionHandler: { results in
        
        guard let results = results else {
          CDAlertView(title: "Sorry", message: "There was a problem retrieving data", type: .error).show()
          return
        }
        self.profileData = results
        
        if self.profileData?.images != nil {
          
          if let profilePic = self.profileData?.profile {
            self.profilePic.sd_setImage(with: URL(string: "\(baseImageURL)\(profilePic)"),placeholderImage: UIImage(named: "placeholder.png"))
          }
          if let birthday = self.profileData?.birthDay {
            self.birthdayLabel.text = birthday
          } else {
            self.birthdayLabel.text = "N/A"
          }
          if let birthplace = self.profileData?.birthPlace {
            self.birthplaceLabel.text = birthplace
          } else {
            self.birthplaceLabel.text = "N/A"
          }
          if self.profileData?.bio != nil {
            if let bio = self.profileData?.bio {
              self.bioLabel.text = bio
            }
          }
          if let extraImages = self.profileData?.images{
            self.extraImagesArray = extraImages.images
            let extraMovieImages = extraImages.images
            
            let group = DispatchGroup()
            for image in extraMovieImages {
              group.enter()
              self.updateImage(ImageType: DownloadPic.personal, ImageString: image.filePath, onSucceed: {_ in
                group.leave()
                
              }, onFailure: {_ in
                
                  if self.alert.isAlertShowing == false {
                  DispatchQueue.main.async {
                    self.alert.show()
                    _ = self.navigationController?.popViewController(animated: true)
                  }
                }
              })
            }
            group.notify(queue: DispatchQueue.main) {
              self.peopleImagesTableView.reloadData()
            }
          }
        }
      })
      
      
      CastExtendedData.updateAllData(urlExtension: "\(personID)/movie_credits", completionHandler: {results in
        
        guard let results = results else {
          CDAlertView(title: "Sorry", message: "There was a problem retrieving data", type: .error).show()
          return
        }
        
        self.knownForData = results
        if let knownFor = self.knownForData?.castExtended {
          self.knownForExtendedArray = knownFor
          
          let group = DispatchGroup()
          for knownForImage in knownFor {
            if let poster = knownForImage.poster {
              group.enter()
              self.updateImage(ImageType: DownloadPic.knownFor, ImageString: poster, onSucceed: {_ in
                group.leave()
              }, onFailure: {_ in
                
                if self.alert.isAlertShowing == false {
                  
                  DispatchQueue.main.async {
                    self.alert.show()
                    _ = self.navigationController?.popViewController(animated: true)
                  }
                }
                
              })
            }
            group.notify(queue: DispatchQueue.main) {
              if let bg = self.knownForArray.first {
                self.backgroundPic.image = bg
              }
              self.hideLoadingScreen()
              self.showAllLabels()
              self.knownForTableView.reloadData()
            }
          }
        }
      })
    }
  }
  
  func updateImage (ImageType: DownloadPic, ImageString: String, onSucceed: @escaping () -> Void, onFailure: @escaping (_ error:NSError)-> Void) {
    
    
    self.networkManager.downloadImage(imageExtension: "\(ImageString)", onSucceed: {
      
      (imageData) in
      
      if let image = UIImage(data: imageData as Data) {
        switch ImageType {
        case DownloadPic.profile: self.profileImage = image
        case DownloadPic.personal: if let image = UIImage(data: imageData as Data){ self.personalImagesArray.append(image)}
        case DownloadPic.knownFor: if let image = UIImage(data: imageData as Data){self.knownForArray.append(image)}
          break
        }
      }
      onSucceed()
      
    }, onFailure: {(error) in
      onFailure(error)
    })
  }
  
  
  func hideAllLabels() {
    self.knownForTableView.isHidden = true
    self.filmographyLabel.isHidden = true
    self.peopleImagesTableView.isHidden = true
    self.backgroundPic.isHidden = true
    self.profilePic.isHidden = true
    self.backgroundTintView.isHidden = true
    self.birthdayCatLabel.isHidden = true
    self.birthplaceCatLabel.isHidden = true
  }
  
  func showAllLabels() {
    self.knownForTableView.isHidden = false
    self.filmographyLabel.isHidden = false
    self.peopleImagesTableView.isHidden = false
    self.backgroundPic.isHidden = false
    self.profilePic.isHidden = false
    self.backgroundTintView.isHidden = false
    self.birthdayCatLabel.isHidden = false
    self.birthplaceCatLabel.isHidden = false
  }
}

extension PeopleDetailedViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if tableView.tag == 0 {
      
      if self.personalImagesArray.count > 0 {
        return 1
        
      }
    } else if tableView.tag == 1 {
      if self.knownForArray.count > 0 {
        return 1
      }
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    if tableView.tag == 0 {
      
      if personalImagesArray.count > 0 {
        let cell = peopleImagesTableView.dequeueReusableCell(withIdentifier: imagesCellIdentifier) as! ImagesPeopleCell
        
        cell.imageDelegate = self
        cell.extraPhotosArray = self.personalImagesArray
        cell.profileImagesArray = self.extraImagesArray
        return cell
        
      } else {
        self.peopleImagesTableView.isHidden = true
      }
      
      return cell
      
    } else {
      
      if knownForArray.count > 0 {
        let cell = knownForTableView.dequeueReusableCell(withIdentifier: knownForCellIdentifier) as! KnownForCell
        
        cell.imageDelegete = self
        cell.knownForExtendedArray = self.knownForExtendedArray
        cell.knownForArray = self.knownForArray
        
        return cell
        
      } else {
        self.filmographyLabel.isHidden = true
        self.knownForTableView.isHidden = true
      }
      return cell
    }
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



