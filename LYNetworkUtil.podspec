Pod::Spec.new do |spec|
  spec.name         = "LYNetworkUtil"
  spec.version      = "0.0.1"
  spec.summary      = "easy network using and object mapabl, build with Moya & Rx & HandyJson"
  spec.homepage     = "https://leonyue.github.io/"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.platform     = :ios
  spec.platform     = :ios, "10.0"
  spec.swift_versions    = "4.0"
  spec.author             = { "岳得建" => "4940748@qq.com" }
  spec.source       = { :git => "/Users/yuedj/Documents/LYNetworkUtil", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.swift"
  spec.dependency "HandyJSON", "~> 5.0.0"
  spec.dependency "Moya", "~> 12.0.1"
  spec.dependency "Moya/RxSwift"
end
