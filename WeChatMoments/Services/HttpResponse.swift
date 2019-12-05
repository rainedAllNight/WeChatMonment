//
//  WCHttpResponse.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/22.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit

public struct HttpResponse {
    
    var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    var code: Int {
        return 0 // no ResultVO
    }
    
    var message: String {
        return "???" //no ResultVO
    }
    
    var error: HttpError {
        return HttpError.serverResponse(message: message, code: code)
    }
    
}

extension HttpResponse {
    
    func decodeToObject<Model: Codable>() throws -> Model {
        do {
            let model = try JSONDecoder().decode(Model.self, from: self.data)
            return model
        } catch {
            throw HttpError.jsonSerializationFailed(message: "json decode to object failed")
        }
    }
    
    func decodeToObjectList<Model: Codable>() throws -> [Model] {
        do {
            let models = try JSONDecoder().decode([Model].self, from: self.data)
            return models
        } catch  {
            throw HttpError.jsonSerializationFailed(message: "json decode to object list failed")
        }
    }
}

