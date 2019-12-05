//
//  HttpError.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/22.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    
    // json解析失败
    case jsonSerializationFailed(message: String)
    
    // 服务器返回的错误
    case serverResponse(message: String, code: Int)
    
    case responseEmpty
    //其他
    case other(message: String, code: Int)
}

extension HttpError {
    
    var message: String {
        switch self {
        case .serverResponse(let message, _):
            return message
            
        case .jsonSerializationFailed(let message):
            return "json解析失败: \(message)"
          
        case .responseEmpty:
            return "response empty"
            
        case .other(let message, _):
            return message
        }
    }
    
    var code: Int {
        switch self {
        case .serverResponse(_, let code):
            return code
            
        case .other(_, let code):
            return code
            
        default:
            return -1
        }
    }
}



