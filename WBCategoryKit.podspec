Pod::Spec.new do |s|
  s.name             = 'WBCategoryKit'
  s.version          = '0.0.1'
  s.summary          = 'Some useful Objective-C Categories and Macro'
  s.homepage         = 'https://github.com/wenmobo/WBCategoryKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenmobo' => '1050794513@qq.com' }
  s.source           = { :git => 'https://github.com/wenmobo/WBCategoryKit.git', :tag => s.version.to_s }
  s.social_media_url = 'http://blogwenbo.com/'
  s.ios.deployment_target = '8.0'
  s.source_files = 'WBCategoryKit/Classes/**/*.{h,m}'
  s.frameworks = 'UIKit', 'Foundation' , 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore'
  s.requires_arc = true
  #s.dependency 'SDWebImage'
  #s.dependency 'UICKeyChainStore'
end
