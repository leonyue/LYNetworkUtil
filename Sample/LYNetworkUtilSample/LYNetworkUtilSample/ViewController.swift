//
//  ViewController.swift
//  LYNetworkUtilSample
//
//  Created by 有来有趣 on 2020/5/25.
//  Copyright © 2020 ly. All rights reserved.
//

import UIKit
import LYNetworkUtil
import Moya
import HandyJSON
import RxSwift

struct TestModel: HandyJSON {
}

enum ApiConfigDemo {
    case login
}

extension ApiConfigDemo: TargetType, TimeoutTarget {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8000")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var timeoutInterval: Double {
        return 5
    }
    
    
}

let apiServiceProvider = MoyaProvider<ApiConfigDemo>(httpsKey: nil, httpsName: nil)

class ViewController: UIViewController {

    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
//        apiServiceProvider.request(.login) { (result) in
//            print(result)
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        apiServiceProvider.rx.request(.login).map(to: TestModel.self).subscribe(onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }


}

