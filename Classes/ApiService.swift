//
//  ApiService.swift
//  Evi_International
//
//  Created by 有来有趣 on 2019/5/23.
//  Copyright © 2019 hxsz. All rights reserved.
//

import Foundation
import Moya
import Alamofire

// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明


/// 增加超时
public protocol TimeoutTarget {
    var timeoutInterval: Double { get }
}

public extension MoyaProvider where Target: TimeoutTarget{
    
    /// 便捷初始化方法
    /// - Parameter httpsKey: httpsKey description
    /// - Parameter httpsName: httpsName description
    convenience init(httpsKey: String?, httpsName: String?) {
        
        var requestTimeOut:Double = 30
        
        let myEndpointClosure = { (target: Target) -> Endpoint in
            let url = target.baseURL.absoluteString + target.path
            let endpoint = Endpoint(
                url: url,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
            requestTimeOut = target.timeoutInterval
            return endpoint
        }
        let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = requestTimeOut
                done(.success(request))
            } catch {
                done(.failure(MoyaError.underlying(error, nil)))
            }
        }
        let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
        //    DLog("\(targetType) - \(changeType)")
        }
        
        if let httpsKey = httpsKey,
            let httpsName = httpsName {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            let certificateData = Data(base64Encoded: httpsKey, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            let certificate = SecCertificateCreateWithData(nil, certificateData! as CFData)
            let certificates :[SecCertificate] = [certificate!]
            let policies: [String: ServerTrustPolicy] = [
                httpsName: .pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: false)
            ]
            let defaultAlamofireManager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
            
            self.init(endpointClosure: myEndpointClosure,
                              requestClosure: requestClosure,
            //                  stubClosure: <#T##(TargetType) -> StubBehavior#>,
            //                  callbackQueue: <#T##DispatchQueue?#>,
                              manager: defaultAlamofireManager,
                              plugins: [networkPlugin],
                              trackInflights: false)
        }
        
        
        self.init(endpointClosure: myEndpointClosure,
                          requestClosure: requestClosure,
        //                  stubClosure: <#T##(TargetType) -> StubBehavior#>,
        //                  callbackQueue: <#T##DispatchQueue?#>,
        //                  manager: <#T##Manager#>,
                          plugins: [networkPlugin],
                          trackInflights: false)
    }
}
