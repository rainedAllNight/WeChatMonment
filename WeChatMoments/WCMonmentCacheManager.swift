//
//  WCMonmentCacheManager.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/12/2.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation

enum CacheTarget {
    
    case monmentTweets([TweetModel]?)
    case monmentUserProfile(UserModel?)
    
    fileprivate var fileDirectory: String {
        switch self {
        case .monmentTweets(_):
            return "monmentTweets"
        case .monmentUserProfile(_):
            return "monmentUserProfile"
        }
    }
    
    fileprivate var cacheData: Data? {
        switch self {
            case .monmentTweets(let tweets):
                return try? JSONEncoder().encode(tweets)
            case .monmentUserProfile(let user):
                return try? JSONEncoder().encode(user)
        }
    }
}


struct WCMonmentCacheManager {
    
    static public func save(_ target: CacheTarget) {
        let cacheData = target.cacheData
        let path = dataFilePath(target)
        try? cacheData?.write(to: URL(fileURLWithPath: path))
    }
    
    static public func getCache<T: Codable>(_ target: CacheTarget) -> T? {
        let path = dataFilePath(target)
        let defaultManager = FileManager()
        if defaultManager.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    static public func isExistCache(_ target: CacheTarget) -> Bool {
        let path = dataFilePath(target)
        let defaultManager = FileManager()
        return defaultManager.fileExists(atPath: path)
    }
    
    // MARK: - Private method
    
    private static func dataFilePath(_ target: CacheTarget) -> String {
        return documentsDirectory().appendingFormat("/\(target.fileDirectory).json")
    }
    
    private static func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
}
