//
//  Extensions.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/22/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit
import ParticlesLoadingView





//used to add blur to image
extension UIImageView
{
  func addBlurEffect()
  {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    blurEffectView.alpha = 0.3
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
  }
}

//used for making cast photos circular
extension UIImage {
  var circleMask: UIImage {
    let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
    let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
    imageView.contentMode = UIViewContentMode.scaleAspectFill
    imageView.image = self
    imageView.layer.cornerRadius = square.width/2
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 5
    imageView.layer.masksToBounds = true
    UIGraphicsBeginImageContext(imageView.bounds.size)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
  }
}

//used to change button color on the fly
extension UIButton {
  func setBackgroundColor(color: UIColor, forState: UIControlState) {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
    UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.setBackgroundImage(colorImage, for: forState)
  }}


extension UIViewController {
  
  //Round corners for button and border color
  func roundButtonCornersAndAddBorderColor(button: UIButton) {
    
    button.backgroundColor = UIColor.black.withAlphaComponent(0.5)//black color
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.white.cgColor
  }
  
  //Round corners for tint background
  func roundImageViewCorners(imageView: UIImageView) {
    imageView.layer.cornerRadius = 8.0
    imageView.clipsToBounds = true
  }
  
  //Used to delay a function
  func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  }
}

//Used to determine selected cell in collectionview
extension UICollectionView {
  func indexPathForView(view: AnyObject) -> IndexPath? {
    let originInCollectioView = self.convert(CGPoint.zero, from: (view as! UIView))
    return self.indexPathForItem(at: originInCollectioView) as IndexPath?
  }
}



