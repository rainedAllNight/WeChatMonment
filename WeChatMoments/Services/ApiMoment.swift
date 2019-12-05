//
//  MomentApi.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/22.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation
import Moya

enum ApiMonment {
    
    case fetchUserProfileInfo
    
    case fetchTweets
}

extension ApiMonment: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://thoughtworks-mobile-2018.herokuapp.com")!
    }
    
    var path: String {
        switch self {
        case .fetchUserProfileInfo:
            return "/user/jsmith"
            
        case .fetchTweets:
            return "/user/jsmith/tweets"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
    
}
