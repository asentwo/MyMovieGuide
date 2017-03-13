//
//  ViewController.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 1/25/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import UIKit


enum Selection: Int {
  case genres
  case inTheatres
  case upcoming
}


class MoviesMasterViewController: UIViewController {
  
  
  @IBOutlet weak var segmentedController: UISegmentedControl!
  
  
  let networkSessionCreator = NetworkManager.sharedManager
  private var viewControllers = [Selection: UIViewController]()// referencing enum "Selection"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupView()
  }
  
  
  //MARK: - View - Child Views are all container views, this determines which view will be displayed based on what is selected by the segmentedController
  
  private func setupView() {
    
    setupSegmentedController()
    updateView()
  }
  
  //Used to switch views based on segmented catagory selected
  private func updateView() {
    
    //The Master VC keeps a reference to all the child VCs, each child vc is only instantiated once and never lose their state even when they are not visible
    
    //Deciding which view to show based on enum value
    if segmentedController.selectedSegmentIndex == Selection.genres.rawValue {
      
      //Remove Unselected View Controllers
      remove(asChildViewController: viewControllers[.inTheatres])
      remove(asChildViewController: viewControllers[.upcoming])
      
      //Create Selected View Controller
      viewControllers[.genres] = viewControllers[.genres] ??
        createMoviesGenresViewController()
      
      //Add Selected View Controller
      add(asChildViewController :viewControllers[.genres])
      
    } else if segmentedController.selectedSegmentIndex == 1 {
      
      //Remove Unselected View Controllers
      remove(asChildViewController: viewControllers[.genres])
      remove(asChildViewController: viewControllers[.upcoming])
      
      //Create Selected View Controller
      viewControllers[.inTheatres] = viewControllers[.inTheatres] ??
      createMoviesInTheatresViewController()
      
      //Add Selected View Controller
      add(asChildViewController: viewControllers[.inTheatres])
    } else {
      
      //Remove Unselected View Controllers
      remove(asChildViewController: viewControllers[.genres])
      remove(asChildViewController: viewControllers[.inTheatres])
      
      //Create Selected View Controller
      viewControllers[.upcoming] = viewControllers[.upcoming] ??
      createMoviesUpcomingViewController()
      
      //Add Selected View Controller
      add(asChildViewController: viewControllers[.upcoming])
    }
  }
  
  //Setup segmentedController catagories
  private func setupSegmentedController() {
    
    segmentedController.removeAllSegments()
    segmentedController.insertSegment(withTitle: "Genres", at: 0, animated: false)
    segmentedController.insertSegment(withTitle: "In Theatres", at: 1, animated: false)
    segmentedController.insertSegment(withTitle: "Upcoming", at: 2, animated: false)
    segmentedController.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    
    //Select initial segment (Home View)
    segmentedController.selectedSegmentIndex = 0
    
  }
  
  //MARK: Actions
  func selectionDidChange(_ sender: UISegmentedControl) {
    updateView()
  }
  
  
  // MARK: - Create Child View Controllers Programatically - Activated when Segmented Controller pressed
  
  private func createMoviesGenresViewController() -> MoviesGenresViewController {
    // Load Storyboard
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    // Instantiate View Controller
    let viewController = storyboard.instantiateViewController(withIdentifier: "MoviesGenresViewController") as! MoviesGenresViewController
    
    // Add View Controller as Child View Controller
    self.add(asChildViewController: viewController)
    
    return viewController
  }
  
  
  private func createMoviesInTheatresViewController() -> InTheatresMoviesViewController {
    //Load Storyboard
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    // Instaniate View Controller
    let viewController = storyboard.instantiateViewController(withIdentifier: "InTheatresMoviesViewController") as! InTheatresMoviesViewController
    
    //Add View Controller as Child View Controller
    self.add(asChildViewController: viewController)
    
     return viewController
  }
  
  private func createMoviesUpcomingViewController() -> UpcomingMoviesViewController {
    // Load Storyboard
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    // Instantiate View Controller  MoviesUpcomingViewController
    let viewController = storyboard.instantiateViewController(withIdentifier: "UpcomingMoviesViewController") as! UpcomingMoviesViewController
    // Add View Controller as Child View Controller
    self.add(asChildViewController: viewController)
    
    return viewController
  }
  
  
  
  //MARK: - Helper Methods for Child View Controllers
  
  //Adds Child View Controller
  private func add(asChildViewController viewController: UIViewController?){
    guard let viewController = viewController else { return }
    
    // Add Child View Controller
    addChildViewController(viewController)
    
    //Add Child View as Subview
    view.addSubview(viewController.view)
    
    //Configure Child View
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    //Notify Child View Controller
    viewController.didMove(toParentViewController: self)
  }
  
  //Removes Child View Controller
  private func remove(asChildViewController viewController: UIViewController?) {
    guard let viewController = viewController else { return }
    
    //Notify Child View Controller
    viewController.willMove(toParentViewController: nil)
    
    //Remove Child View From Superview
    viewController.view.removeFromSuperview()
    
    //Notify Child View Controller it's being removed
    viewController.removeFromParentViewController()
  }
  
}

