//
//  TweetModel.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/22.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation

struct TweetModel: Codable {
    
    var sender: UserModel?
    
    var images: [[String: String]]?
    
    var content: String?
    
    var comments: [CommentModel]?
    
}

struct CommentModel: Codable {
    
    var content: String = ""
    
    var sender: UserModel?
}
