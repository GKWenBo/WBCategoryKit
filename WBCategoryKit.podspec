Pod::Spec.new do |s|
  s.name             = 'WBCategoryKit'
  s.version          = '1.0.0'
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
      ss.source_files = 'WBCategoryKit/Foundation/NSDictionary/**/*.{h,m}', 'WBCategoryKit/Foundation/NSData/**/*.{h,m}', 'WBCategoryKit/Foundation/NSString/**/*.{h,m}', 'WBCategoryKit/Foundation/NSArray/**/*.{h,m}', 'WBCategoryKit/Foundation/NSUserDefaults/**/*.{h,m}', 'WBCategoryKit/Foundation/NSObject/**/*.{h,m}', 'WBCategoryKit/Foundation/NSDate/**/*.{h,m}', 'WBCategoryKit/Foundation/WBFoundation.h'
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
      ss.source_files = 'WBCategoryKit/UIKit/UIFont/**/*.{h,m}', 'WBCategoryKit/UIKit/UIImage/**/*.{h,m}', 'WBCategoryKit/UIKit/UIScrollView/**/*.{h,m}', 'WBCategoryKit/UIKit/UIScreen/**/*.{h,m}', 'WBCategoryKit/UIKit/UIWindow/**/*.{h,m}', 'WBCategoryKit/UIKit/UIApplication/**/*.{h,m}', 'WBCategoryKit/UIKit/UITableViewCell/**/*.{h,m}', 'WBCategoryKit/UIKit/UIButton/**/*.{h,m}', 'WBCategoryKit/UIKit/UIColor/**/*.{h,m}', 'WBCategoryKit/UIKit/UIAlertController/**/*.{h,m}', 'WBCategoryKit/UIKit/UIView/**/*.{h,m}', 'WBCategoryKit/UIKit/UINavigationItem/**/*.{h,m}', 'WBCategoryKit/UIKit/WKWebView/**/*.{h,m}', 'WBCategoryKit/UIKit/UITextView/**/*.{h,m}', 'WBCategoryKit/UIKit/UICollectionView/**/*.{h,m}', 'WBCategoryKit/UIKit/UIImagePickerController/**/*.{h,m}', 'WBCategoryKit/UIKit/UIBarButtonItem/**/*.{h,m}', 'WBCategoryKit/UIKit/UINavigationBar/**/*.{h,m}', 'WBCategoryKit/UIKit/UIViewController/**/*.{h,m}', 'WBCategoryKit/UIKit/UISearchBar/**/*.{h,m}', 'WBCategoryKit/UIKit/UIControl/**/*.{h,m}', 'WBCategoryKit/UIKit/WBUIKit.h'
      ss.frameworks = 'Foundation', 'UIKit', 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate'
      ss.dependency 'WBCategoryKit/Foundation'
      ss.dependency 'WBCategoryKit/Macro'
  end
  
end
