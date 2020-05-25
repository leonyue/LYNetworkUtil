Pod::Spec.new do |spec|
  spec.name         = "LYNetworkUtil"
  spec.version      = "0.0.1"
  spec.summary      = "easy network using and object mapabl, build with Moya & Rx & HandyJson"
  spec.homepage     = "https://leonyue.github.io/"
  spec.license      = "MIT"
  spec.author             = { "岳得建" => "4940748@qq.com" }
  spec.source       = { :git => "/Users/yuedj/Documents/LYNetworkUtil.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.swift"
  spec.exclude_files = "Classes/Exclude"
  spec.dependency "HandyJSON", "~> 5.0.0"
  #, "Moya", "~> 12.0.1", "Moya/RxSwift"

end
