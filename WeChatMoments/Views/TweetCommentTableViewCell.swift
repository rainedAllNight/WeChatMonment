//
//  TweetCommentTableViewCell.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/23.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit

class TweetCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ comments: [CommentModel]?) {
        var comment = comments?.reduce("", { (result, model) -> String in
            let comment = (model.sender?.nick ?? "") + ": " + model.content + "\n"
            return result + comment
            })
        comment?.removeLast() //remove last "\n"
        commentLabel.text = comment
    }
}
