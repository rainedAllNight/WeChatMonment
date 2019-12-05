//
//  TweetPhotoTableViewCell.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/23.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit

class TweetPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoContainerView: TweetPhotoContainerView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ row: WCRow) {
        let images = row.data as? [[String: String]]
        guard let imageUrls = images?.compactMap({$0["url"]}) else {return}
        self.photoContainerView.update(imageUrls)
        if row.cachedRowHeight == nil {
            self.containerViewHeightConstraint.constant = self.photoContainerView.bounds.height
        }
    }

}
