//
//  PeopleDetailViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/21/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit


class PeopleDetailViewController : UIViewController {
  
  
  @IBOutlet weak var peopleDetailTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
 
  var id: NSNumber?
  
  var profileImage: UIImage?
  
  var profileData: PeopleData?
  var bioArray: [String] = []
  var castCrewArray: [String] = []
  var personalImagesArray: [UIImage] = []
  var moviePostersArray: [UIImage] = []
  
  var setionTitles = ["", "Bio", "Credits", "Known For"]
  
  
  //Reuse Identifiers
  let profileCellIdentifier = "actorProfileCell"
  let titleCellIndetifier = "titleCell"
  let bioCellIdentifier = "bioCell"
  let castDetailCellIdentifier = "castDetailsCell"
  let crewDetailCellIdentifier = "crewDetailsCell"
  let imagesCellIdentifier = "imagesCell"
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    DispatchQueue.main.async {
      
      if let personID = self.id {
        
        PeopleData.updateAllData(urlExtension: "\(personID)", completionHandler: { results in
          
          
          guard let results = results else {
            print("There was an error retrieving people data")
            return
          }
          
          self.profileData = results
          
          
          if self.profileData?.images != nil {
            
            if let profileImages = self.profileData?.images{
              
              let profileImage = profileImages.images
              
              for profile in profileImage {
                
                self.updateExtraImages(extraImage: profile.filePath)
                
              }
            }
          }
          if let actorProfileImage = self.profileData?.profile {
            
            self.updateProfileImage(profilePic: actorProfileImage)
            
          } else {
            print("actor pic doesn't exist")
          }
        })
      }
    }
  }
  
  
  func updateProfileImage (profilePic: String) {
    
    self.networkManager.downloadImage(imageExtension: "\(profilePic)", { (imageData) in
      
      if let image = UIImage(data: imageData as Data) {
        self.profileImage = image
        
        DispatchQueue.main.async {
          self.peopleDetailTableView.reloadData()
        }
      }
    })
  }
  
  
  func updateExtraImages (extraImage: String) {
    self.networkManager.downloadImage(imageExtension: "\(extraImage)", {
      (imageData) in
      if let image = UIImage(data: imageData as Data){
        self.personalImagesArray.append(image)
 
        DispatchQueue.main.async {
          self.peopleDetailTableView.reloadData()
        }
      }
    })
  }
  
}





extension PeopleDetailViewController : UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0: return 1
    case 1: return 1
    case 2: return 2
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
      
      if let birthday = profileData?.birthDay{
        cell.birthdayLabel.text = birthday
      }
      
      if let birthplace = profileData?.birthPlace {
        cell.birthPlaceLabel.text = birthplace
      }
      
      cell.actorProfileImage.image = profileImage
      cell.actorProfileImage.layer.cornerRadius =
        cell.actorProfileImage.frame.size.height/2
      cell.actorProfileImage.layer.masksToBounds = true
      cell.actorProfileImage.clipsToBounds = true
      
      
      self.peopleDetailTableView.rowHeight = 150
      
      return cell
      
    case 1:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: bioCellIdentifier) as! BioCell
      
      if let bio = profileData?.bio {
        cell.bioText.text = bio
      }
      
      self.peopleDetailTableView.rowHeight = 200
      
      return cell
    case 2:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: castDetailCellIdentifier) as! CastDetailCell
      
      switch indexPath.row {
      case 0:
        cell.castLabel.text = "Cast"
        cell.totalLabel.text = ""
      default:
        cell.castLabel.text = "Crew"
        cell.totalLabel.text = ""
      }
      
      self.peopleDetailTableView.rowHeight = 44
      
      return cell
    case 3:
      let cell = peopleDetailTableView.dequeueReusableCell(withIdentifier: imagesCellIdentifier) as! ImagesPeopleCell
      cell.extraPhotosArray = self.personalImagesArray
  
    //  print(self.personalImagesArray.count)
     // print(cell.extraPhotosArray.count)
    
      self.peopleDetailTableView.rowHeight = 200
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



