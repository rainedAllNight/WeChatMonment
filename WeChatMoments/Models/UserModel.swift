//
//  UserModel.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/22.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation

struct UserModel {
    
    var profileImage: String?
    
    var avatar: String = ""
    
    var nick: String = ""
    
    var userName: String?
}

extension UserModel: Codable {
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile-image"
        case userName = "username"
        case avatar
        case nick
    }
}
