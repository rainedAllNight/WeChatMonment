//
//  TweetHeaderTableViewCell.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/23.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit
import Kingfisher

class TweetHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ tweet: TweetModel?) {
        nickNameLabel.text = tweet?.sender?.nick
        contentLabel.text = tweet?.content
        avatarImageView.kf.setImage(with: URL(string: tweet?.sender?.avatar ?? ""), options: [KingfisherOptionsInfoItem.processor(RoundCornerImageProcessor(cornerRadius: 6, targetSize: avatarImageView.bounds.size))])
    }

}
