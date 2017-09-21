#
#  Be sure to run `pod spec lint ZXGQRCode.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZXGQRCode"
  s.summary      = "简单方便的二维码扫描和生成框架."
  s.homepage     = "https://github.com/onzxgway/ZXGQRCode"
  s.license      = "MIT"
  s.author       = { "onzxgway" => "zhuxianguo529@163.com" }

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/onzxgway/ZXGQRCode.git", :tag => s.version}

  s.social_media_url   = "https://onzxgway.github.io"
  s.source_files  = "ZXGQRCode","ZXGQRCode/**/*.{h,m}"
  s.requires_arc  = true
end
