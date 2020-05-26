//
//  ApiConfig.swift
//  Evi_International
//
//  Created by 有来有趣 on 2019/5/23.
//  Copyright © 2019 hxsz. All rights reserved.
//

import UIKit
import Moya

public let defaultDownloadDir: URL = {
    let diretoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)
    return diretoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

public var defaultDownloadDestination: DownloadDestination = {
    temporaryURL, response in
    return (defaultDownloadDir.appendingPathComponent(response.suggestedFilename!), [])
}

public enum ApiConfig {
    case login
}

extension ApiConfig: TargetType {
    /// 单独设置超时时间
    public var timeoutInterval: TimeInterval {
        switch self {
        default:
            return 10
        }
    }
    
    public var baseURL: URL {
        return URL(string: "https://www.baidu.com")!
        
    }
    
    public var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}
