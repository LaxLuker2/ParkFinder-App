//
//  UIView+takeSnapshot.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 3/26/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func takeSnapshot() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
