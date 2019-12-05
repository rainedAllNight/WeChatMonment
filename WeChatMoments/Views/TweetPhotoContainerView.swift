//
//  TweetPhotoView.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/29.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit
import Kingfisher

class TweetPhotoContainerView: UIView {
    
    private var imageViews = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImageView()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        
    }
    
    private func addImageView() {
        for _ in 0..<9 {
            let imageView = UIImageView.init(frame: CGRect.zero)
            imageView.backgroundColor = BackgroundColor
            imageViews.append(imageView)
            self.addSubview(imageView)
        }
    }
    
    func update(_ imageUrls: [String]) {
        imageViews.forEach {$0.isHidden = true}
        if imageUrls.count == 0 {
            self.bounds.size = CGSize.zero
            return
        }
        
        let totalCount = imageUrls.count
        for (i, url) in imageUrls.enumerated() {
            var rowNum = i / 3
            var cloumNum = i % 3
            if totalCount == 4 {
                rowNum = i / 2
                cloumNum = i % 2
            }
            let x = CGFloat(cloumNum) * (MonmentContentImageWidth + MonmentContentImagePadding)
            let y = CGFloat(rowNum) * (MonmentContentImageWidth + MonmentContentImagePadding)
            let frame = CGRect(x: x, y: y, width: MonmentContentImageWidth, height: MonmentContentImageWidth)
        
            imageViews[i].isHidden = false
            imageViews[i].frame = frame
            let optionInfo = KingfisherOptionsInfoItem.backgroundDecode
            // single image
            imageViews[i].kf.setImage(with: URL(string: url), options: [optionInfo])
        }
        
        if imageUrls.count == 1 {
            //如果能从json数据或者url中获取图片大小，使用这种方式计算单张图片大小
//            let size = self.getSingleImageSize(originalSize)
            //这里没有就写死
            imageViews[0].frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 150, height: UIScreen.main.bounds.width - 130)
            updateFrame(imageViews[0])
        } else if imageUrls.count > 1 {
            updateFrame(imageViews[imageUrls.count - 1])
        }
    }
    
    private func updateFrame(_ lastImageView: UIImageView) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.bounds.width, height: lastImageView.frame.origin.y + lastImageView.bounds.height)
    }
    
    private func getSingleImageSize(_ originalSize: CGSize) -> CGSize {
        let originalWidth = originalSize.width
        let originalHeight = originalSize.height
        let maxWidth = UIScreen.main.bounds.width - 150
        let maxHeight = UIScreen.main.bounds.width - 130
        
        var newWidth: CGFloat = 0
        var newHeight: CGFloat = 0
        if originalHeight / originalWidth > 3.0 {
            newHeight = maxHeight
            newWidth = newHeight / 2.0
        } else {
            newWidth = maxWidth
            newHeight = maxWidth * originalHeight / originalWidth
        }
        
        return CGSize(width: newWidth, height: newHeight)
    }
}
