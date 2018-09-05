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
  s.source_files = 'WBCategoryKit/WBCategoryKit.h'
  s.frameworks = 'UIKit', 'Foundation' , 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate'
  s.requires_arc = true
  
  s.subspec 'Foundation' do |ss|
      ss.source_files = 'WBCategoryKit/Foundation/**/*.{h,m}'
      ss.frameworks = 'Foundation', 'UIKit'
      end
  
  s.subspec 'Macro' do |ss|
      ss.source_files = 'WBCategoryKit/Macro/*.{h}'
      ss.frameworks = 'Foundation', 'UIKit'
  end
  
  s.subspec 'QuartzCore' do |ss|
      ss.source_files = 'WBCategoryKit/QuartzCore/**/*.{h,m}'
      ss.frameworks = 'Foundation', 'UIKit', 'QuartzCore'
  end
  
  s.subspec 'UIKit' do |ss|
      ss.source_files = 'WBCategoryKit/UIKit/**/*.{h,m}'
      ss.frameworks = 'Foundation', 'UIKit', 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate'
      ss.dependency 'WBCategoryKit/Foundation'
      ss.dependency 'WBCategoryKit/Macro'
  end
  
end
