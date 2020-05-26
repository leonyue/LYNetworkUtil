//
//  Response+Mapable.swift
//  Evi_International
//
//  Created by 有来有趣 on 2019/5/23.
//  Copyright © 2019 hxsz. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Moya

/// 网络请求响应（HandyJSON）
/// HandyJSON的已知优势不需要手动写JSON键值转化
/// 暂未实现data的数组支持
public struct ResponseModel<T: HandyJSON>: HandyJSON {
    var result: Int?
    var message: String?
    var data: T?
    public init() {
        
    }
}


/// 网络请求错误
///
/// - formatError: JSON格式化错误
/// - serverError: 服务器通过携带的错误信息 result + message
public enum ResponseError: Error, CustomStringConvertible {
    /// json格式不对,解析ResponseModel失败
    case formatError
    /// 服务器通过携带的错误信息 result + message
    case serverError(Int?, String?)
    
    public var description: String {
        switch self {
        case .formatError:
            return "响应数据异常"
        case .serverError(let code, let msg):
            return msg ?? "code:\(code ?? 0)"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .formatError:
            return "响应数据异常"//.localized
        case .serverError(let code, let msg):
            return msg ?? "code:\(code ?? 0)"
        }
    }
}


// MARK: - 扩展Moya + Rx
public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// 转换HandyJSON Model
    ///
    /// - Parameter type: 待转换的HandyJSON Model类型
    /// - Returns: HandyJSON Model对象
    func mapT<T: HandyJSON>(to type: T.Type) -> Single<T?> {
        return map(to: T.self).flatMap({ (responseModel) -> Single<T?> in
            if let result = responseModel.result,
                result == 1 {
                return Single.just(responseModel.data)
            } else {
                return Single.error(ResponseError.serverError(responseModel.result, responseModel.message))
            }
        })
    }
    
    /// 转换ResponseModel
    ///
    /// - Parameter type: 待转换的ResponseModel的data类型
    /// - Returns: ResponseModel对象
    func map<T: HandyJSON>(to type: T.Type) -> Single<ResponseModel<T>> {
        return flatMap { response -> Single<ResponseModel<T>> in
            if let jsonStr = String(data: response.data, encoding: .utf8),
                let commonResponse = ResponseModel<T>.deserialize(from: jsonStr) {
                return Single.just(commonResponse)
            } else {
                return Single.error(ResponseError.formatError)
            }
        }
    }
    
    
}
