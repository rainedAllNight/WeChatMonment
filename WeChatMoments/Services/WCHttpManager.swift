//
//  WCHttpManager.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/22.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit
import Moya
import Result

fileprivate typealias Success = (_ response: HttpResponse?) -> ()
public typealias ModelSuccess<M> = (_ response: M) -> ()
public typealias ListSuccess<M> = (_ response: [M]) -> ()
public typealias Failure = (HttpError) -> ()

public class WCHttpManager<WCTarget: TargetType, M> {
    
    /// 对内基础请求方法
    ///
    /// - Parameters:
    ///   - target: TargetType
    ///   - success: 成功
    ///   - failure: 失败
    fileprivate class func request(_ target: WCTarget, success: Success? = nil, failure: Failure? = nil) {
        
        let completion = {(result: Result<Moya.Response, MoyaError>) in
            switch result {
            case let .success(response):
                let responseData = HttpResponse(response.data)
                do {
                    let _ = try response.filterSuccessfulStatusCodes()
                    success?(responseData)
                } catch {
                    failure?(responseData.error)
                }
                
            case let .failure(error):
                if let data = error.response?.data {
                    let responseData = HttpResponse(data)
                    failure?(responseData.error)
                } else {
                    failure?(HttpError.other(message: error.localizedDescription, code: (error as NSError).code))
                }
            }
        }
        
        let provider = getProvider()
        provider.request(target, completion: completion)
    }
    

    fileprivate class func getProvider() -> MoyaProvider<WCTarget> {
        let providerParameter = HttpProviderParameter<WCTarget>()
        let provider = MoyaProvider<WCTarget>(endpointClosure: providerParameter.endpointClosure, requestClosure: providerParameter.requestClosure, stubClosure: providerParameter.stubClosure, callbackQueue: nil, manager: .default, trackInflights: false)
        return provider
    }
}

struct HttpProviderParameter<WCTarget: TargetType> {
    
    // endpoint
    var endpointClosure = {(target: WCTarget) -> Endpoint in

        return Endpoint(url: URL(target: target).absoluteString,
                                    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                    method: target.method,
                                    task: target.task,
                                    httpHeaderFields: [:])
    }
    
    // request
    var requestClosure = {(endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
        do {
            var urlRequest = try endpoint.urlRequest()
            urlRequest.timeoutInterval = 60
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    // stub
    var stubClosure = { (target: WCTarget) -> StubBehavior in
        return .never
    }

}

extension WCHttpManager where M: Codable {
    
    private class func request(_ target: WCTarget, success: ModelSuccess<M>? = nil, listSuccess: ListSuccess<M>? = nil, failure: Failure? = nil) {
        self.request(target, success: { (response) in
            guard let response = response else {
                failure?(HttpError.responseEmpty)
                return
            }
            do {
                if let success = success {
                    let model: M = try response.decodeToObject()
                    success(model)
                } else if let listSuccess = listSuccess {
                    let models: [M] = try response.decodeToObjectList()
                    listSuccess(models)
                }
                
            } catch let error as HttpError {
                failure?(error)
            } catch {
                #if Debug
                fatalError("未知错误")
                #endif
            }

        }) { (error) in
            failure?(error)
        }
    }
    
    /// request model
    ///
    /// - Parameters:
    ///   - target: TargetType
    ///   - success: 成功
    ///   - failure: 失败
    public class func requestModel(_ target: WCTarget, success: ModelSuccess<M>?, failure: Failure? = nil) {
        self.request(target, success: success, failure: failure)
    }
    
    /// request model list
    ///
    /// - Parameters:
    ///   - target: TargetType
    ///   - success: 成功
    ///   - failure: 失败
    public class func requestModelList(_ target: WCTarget, success: ListSuccess<M>?, failure: Failure? = nil) {
        self.request(target, listSuccess: success, failure: failure)
    }
}
