//
//  Extensions.swift
//  MyMovieGuide
//
//  Created by Justin Doo on 2/22/17.
//  Copyright © 2017 JustinDoo. All rights reserved.
//

import Foundation
import UIKit



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
