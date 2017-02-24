////
////  PeopleDetailViewController.swift
////  MyMovieGuide
////
////  Created by Justin Doo on 2/21/17.
////  Copyright © 2017 JustinDoo. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//class PeopleDetailViewController : UIViewController {
//  
//  
//  @IBOutlet weak var peopleDetailTableView: UITableView!
//  
//  let networkManager = NetworkManager.sharedManager
//  
//  var id: NSNumber?
//  
//  var peopleData: PeopleData?
//  var profileImage: UIImage?
//  
//  var profileArray: [PeopleData] = []
//  var bioArray: [String] = []
//  var castCrewArray: [String] = []
//  var personalImagesArray: [UIImage] = []
//  var moviePostersArray: [UIImage] = []
//  
//  
//  
//  
//  //Reuse Identifiers
//  let profileCellIdentifier = "actorProfileCell"
//  let titleCellIndetifier = "titleCell"
//  let bioCellIdentifier = "bioCell"
//  let castDetailCellIdentifier = "castDetailsCell"
//  let crewDetailCellIdentifier = "crewDetailsCell"
//  let imagesCellIdentifier = "imagesCell"
//  
//
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//   
//    
//    
//    
//    
//    
//    
//  }
//}
//
//
//
//
//
//extension PeopleDetailViewController : UITableViewDataSource {
//  
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return totalArray.count
//  }
//  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    switch section {
//    case 0:
//      <#code#>
//    default:
//      <#code#>
//    }
//      }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    
//    
//    
//  }
//}
//
//
