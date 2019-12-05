//
//  UIImageHelper.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/28.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    public class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func imageWithAlpha(_ alpha: CGFloat) -> UIImage {
           let colorWithAlpha = UIColor(patternImage: self).withAlphaComponent(alpha)
           return UIImage.imageWithColor(colorWithAlpha, size: CGSize(width: self.cgImage?.width ?? 1, height: self.cgImage?.height ?? 1))
       }
}
