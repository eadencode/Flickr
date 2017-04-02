//
//  AppUtils.swift
//  fliCKr
//
//  Created by CK on 4/1/17.
//  Copyright © 2017 CK. All rights reserved.
//

import Foundation
import UIKit


class AppUtils  {
    
    
    //TODO:Write as extension to UIImage.
    
    class func imagesizeToFit(image:UIImage,newSize:CGSize , offset:CGPoint)->UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(x: offset.x, y: offset.y, width: newSize.width - offset.x, height: newSize.height - offset.y))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
