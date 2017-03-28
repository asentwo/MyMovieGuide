//
//  MyMovieCollectionViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 3/24/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CDAlertView



class MyMovieCollectionViewController : MasterCollectionViewController {
  
  var movieID: NSNumber!
  var retrievedCoreDataIdArray: [NSManagedObject] = []
  var movieIDArray: [NSNumber] = []
  var myMovieDataArray:[MovieDetailsData] = []
  
  let myMovieReuseIdentifier = "myMovieReuseIdentifier"
  let myMovieToDetailSegue = "myMovieToDetailSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let managedContext =
      appDelegate.persistentContainer.viewContext
    
    let fetchRequest =
      NSFetchRequest<NSManagedObject>(entityName: "Movie")
    
    do {
      retrievedCoreDataIdArray = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    for movie in retrievedCoreDataIdArray {
      
      self.movieID = movie.value(forKey: "id") as? NSNumber
      
      if self.movieIDArray.contains(self.movieID){
        print(self.movieIDArray.count)
      continue
      } else {
      
      self.movieIDArray.append(self.movieID)
    }

    }
    self.navigationItem.title = "My Movies"
   self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 20.0)!, NSForegroundColorAttributeName : UIColor.white];
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    startLoadingScreen()
    
    if movieIDArray.count > 0 {
      
      self.myMovieDataArray = []
     
      for id in movieIDArray {
        MovieDetailsData.updateAllData(urlExtension: String(describing:id), completionHandler: {results
          in
          
          guard let results = results else {
            return
          }
          
          self.myMovieDataArray.append(results)
          
          DispatchQueue.main.async {
            
            self.hideLoadingScreen()
            self.collectionView?.reloadData()
          }
        })
      }
    } else {
      
      DispatchQueue.main.async {
        self.hideLoadingScreen()
        CDAlertView(title: "Sorry", message: "No saved movies", type: .notification).show()
      }
      
    }
  }
  
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return myMovieDataArray.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myMovieReuseIdentifier, for: indexPath) as! MyMovieCollectionViewCell
    
    if self.myMovieDataArray[indexPath.row].poster != nil {
      if let poster = self.myMovieDataArray[indexPath.row].poster {
        DispatchQueue.main.async {
          cell.imageView.sd_setImage(with: URL(string:"\(baseImageURL)\(poster)"), placeholderImage: UIImage(named: "placeholder.png"))
          
        }
      }
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.movieID = myMovieDataArray[indexPath.row].id
    performSegue(withIdentifier: myMovieToDetailSegue, sender: self)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let detailedVC = segue.destination as! MoviesDetailViewController
    detailedVC.iD = self.movieID
    
  }
}
