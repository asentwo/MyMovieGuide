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
    
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
  }
}
