//
//  MoviesGenresViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/30/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit
import CDAlertView

class MoviesGenresViewController: MasterViewController {
  
  //MARK: Properties
  @IBOutlet weak var genresTableView: UITableView!
  
  let networkManager = NetworkManager.sharedManager
  let segueIdentifier = "genreToCollectSegue"
  var genreDataArray: [GenreData] = []
  var posterStringArray: [String] = []
  var genreID: NSNumber?
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startLoadingScreen()
    GenreData.updateAllData(urlExtension:"list", completionHandler: { results in
      
      guard let results = results else {
        print("There was an error retrieving genre data")
          CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
        return
      }
      self.genreDataArray = results
      
      for movie in self.genreDataArray {
        if let movieGenreID = movie.id
        {
          //Update posters based on genreID
          GenrePosters.updateGenrePoster(genreID: movieGenreID, urlExtension: "movies", completionHandler: {posters in
            
            guard let posters = posters else {
              CDAlertView(title: "Sorry", message: "There was an error retrieving data!", type: .error).show()
              return
            }
            //Must iterate through multiple arrays with many containing the same poster strings
            for poster in posters {
              
              if let newPoster = poster {
                //Check to see if array already has the current poster string, if it does continue, if not append to array
                if self.posterStringArray.contains(newPoster){
                  continue
                } else {
                  self.posterStringArray.append(newPoster)
                  break// Use to exit out of array after appending the corresponding poster string
                }
              } else {
                print("There was a problem retrieving poster images: \(String(describing: poster))")
                continue// if the poster returned is nil, continue to iterate through arrays until there is one that is not nil
              }
            }
            DispatchQueue.main.async {
              self.hideLoadingScreen()
              self.animateTableView()
            }
          })
        }
      }
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    animateTableView()
  }
  

  
  
  //Parallax
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY =  genresTableView.contentOffset.y
    for cell in  genresTableView.visibleCells as! [GenresTableViewCell] {
      let x = cell.mainImageView.frame.origin.x
      let w = cell.mainImageView.bounds.width
      let h = cell.mainImageView.bounds.height
      let y = ((offsetY - cell.frame.origin.y) / h) * 25
      cell.mainImageView.frame = CGRect(x: x, y: y, width: w, height: h)
      cell.contentMode = UIViewContentMode.scaleAspectFill
    }
  }
}


//MARK: TableView Delegate DataSource
extension MoviesGenresViewController:  UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posterStringArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = genresTableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell") as! GenresTableViewCell
    cell.genreCatagoryLabel.text = genreDataArray[indexPath.row].name
    cell.mainImageView.sd_setImage(with: URL(string: "\(baseImageURL)\(posterStringArray[indexPath.row])"))
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.genreCatagoryLabel.adjustsFontSizeToFitWidth = true
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200.00
  }
}


extension MoviesGenresViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let id = genreDataArray[indexPath.row].id {
      self.genreID = id
    }
    self.performSegue(withIdentifier: segueIdentifier, sender: self)
  }
  
}


//MARK: Segue
extension MoviesGenresViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let genreCollectVC = segue.destination as! MoviesGenresCollectionViewController
    genreCollectVC.genreID = self.genreID
  }
}


//MARK: Animate in cells
extension MoviesGenresViewController {
  
  func animateTableView () {
    genresTableView.reloadData()
    
    let cells = genresTableView.visibleCells
    
    let tableViewHeight = genresTableView.bounds.size.height
    
    var delayCounter: Double = 0// Delay for when tableview cells will appear on screen
    
    for cell in cells {
      //Moves tableview down based on size of the height
      cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
      
    }
    
    for cell in cells {
      
      UIView.animate(withDuration: 1.75, delay: delayCounter * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
        
        cell.transform = CGAffineTransform.identity// identity stands for transform origin
        
      }, completion: nil)
      
      delayCounter += 1
    }
  }
}
