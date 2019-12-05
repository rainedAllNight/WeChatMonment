//
//  UINavigationHelper.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/28.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation
import UIKit

public protocol WCNavigationControllerDelegate: class {
    func alphaOfNavigationBar(in navigationController: UINavigationController) -> CGFloat
}

extension UINavigationController {
    
    fileprivate func updateNavBar(_ alpha: CGFloat, originalColor: UIColor) {
        var wcAlpha = alpha > 0.99 ? 0.99 : alpha
        wcAlpha = wcAlpha < 0.0 ? 0.0 : wcAlpha
        let navBgImage = UIImage.imageWithColor(originalColor)
        let navBgImageWithAlpha = navBgImage.imageWithAlpha((wcAlpha))
        self.navigationBar.setBackgroundImage(navBgImageWithAlpha, for: .default)
    }
    
    public func updateNavBar(with originalColor: UIColor) {
        guard let topViewController = self.topViewController else {
            return
        }
        
        if let delegate = topViewController as? WCNavigationControllerDelegate {
            let alpha = delegate.alphaOfNavigationBar(in: self)
            updateNavBar(alpha, originalColor: originalColor)
        } else {
            let navBgImage = UIImage.imageWithColor(originalColor)
            self.navigationBar.setBackgroundImage(navBgImage, for: .default)
        }
    }
}
