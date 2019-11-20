Pod::Spec.new do |s|
  s.name             = 'WBCategoryKit'
  s.version          = '1.1.0'
  s.summary          = 'Some useful Objective-C Categories and Macro'
  s.homepage         = 'https://github.com/wenmobo/WBCategoryKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenmobo' => '1050794513@qq.com' }
  s.source           = { :git => 'https://github.com/wenmobo/WBCategoryKit.git', :tag => s.version.to_s }
  s.social_media_url = 'http://blogwenbo.com/'
  s.ios.deployment_target = '8.0'
  s.source_files = 'WBCategoryKit/WBCategoryKit.h'
  s.frameworks = 'UIKit', 'Foundation' , 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate', 'ImageIO', 'CoreText', 'CoreGraphics', 'CoreTelephony'
  s.requires_arc = true
  
  s.subspec 'Foundation' do |folder1|
      folder1.source_files = 'WBCategoryKit/Foundation/WBFoundation.h'
      folder1.frameworks = 'Foundation', 'UIKit'
      
      folder1.subspec 'NSData' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSData/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      folder1.subspec 'NSDictionary' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSDictionary/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
          folder2.dependency 'WBCategoryKit/Foundation/NSString'
      end
      
      folder1.subspec 'NSString' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSString/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'CoreTelephony'
      end
      
      folder1.subspec 'NSArray' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSArray/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      folder1.subspec 'NSUserDefaults' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSUserDefaults/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      folder1.subspec 'NSObject' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSObject/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      folder1.subspec 'NSDate' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSDate/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      folder1.subspec 'Runtime' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/Runtime/**/*.{h,m}'
          folder2.frameworks = 'Foundation','UIKit'
          folder2.dependency 'WBCategoryKit/Macro'
          folder2.dependency 'WBCategoryKit/Foundation/NSMethodSignature'
      end
      
      folder1.subspec 'NSMutableAttributedString' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSMutableAttributedString/**/*.{h,m}'
          folder2.frameworks = 'Foundation','UIKit'
      end

      folder1.subspec 'NSMethodSignature' do |folder2|
      	folder2.source_files = 'WBCategoryKit/Foundation/NSMethodSignature/**/*.{h,m}'
      	folder2.frameworks = 'Foundation'
        folder2.dependency 'WBCategoryKit/Macro'
      end

  end
  
  s.subspec 'Macro' do |ss|
      ss.source_files = 'WBCategoryKit/Macro/*.{h}'
      ss.frameworks = 'Foundation', 'UIKit'
      ss.dependency 'WBCategoryKit/Foundation/NSString'
  end
  
  s.subspec 'UIKit' do |folder1|
      folder1.source_files = 'WBCategoryKit/UIKit/WBUIKit.h'
      folder1.frameworks = 'Foundation', 'UIKit', 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate'
      
      folder1.subspec 'UIFont' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIFont/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
          folder2.dependency 'WBCategoryKit/Foundation/Runtime'
          folder2.dependency 'WBCategoryKit/Macro'
      end
      
      folder1.subspec 'UIImage' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIImage/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'ImageIO', 'CoreText', 'AVFoundation', 'Accelerate'
          folder2.dependency 'WBCategoryKit/Macro'
          folder2.dependency 'WBCategoryKit/Foundation/NSObject'
      end
      
      folder1.subspec 'UIScrollView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIScrollView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIScreen' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIScreen/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIWindow' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIWindow/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIApplication' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIApplication/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UITableViewCell' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UITableViewCell/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIButton' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIButton/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIColor' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIColor/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIAlertController' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIAlertController/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'QuartzCore'
          folder2.dependency 'WBCategoryKit/Foundation/Runtime'
          folder2.dependency 'WBCategoryKit/Foundation/NSObject'
      end
      
      folder1.subspec 'UINavigationItem' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UINavigationItem/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'WKWebView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/WKWebView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'WebKit'
      end
      
      folder1.subspec 'UICollectionView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UICollectionView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIImagePickerController' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIImagePickerController/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary'
          folder2.dependency 'WBCategoryKit/Foundation/NSDate'
      end
      
      folder1.subspec 'UIBarButtonItem' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIBarButtonItem/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UINavigationBar' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UINavigationBar/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIViewController' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIViewController/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UISearchBar' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UISearchBar/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      folder1.subspec 'UIControl' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIControl/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'AVFoundation'
      end

      folder1.subspec 'CALayer' do |folder2|
      	  folder2.source_files = 'WBCategoryKit/UIKit/CALayer/**/*.{h,m}'
      	  folder2.frameworks = 'UIkit'
      	  folder2.dependency 'WBCategoryKit/Macro'
      	  folder2.dependency 'WBCategoryKit/Foundation/Runtime'
      	  folder2.dependency 'WBCategoryKit/Foundation/NSObject'
      end

      folder1.subspec 'UILabel' do |folder2|
      	  folder2.source_files = "WBCategoryKit/UIKit/UILabel/**/*.{h,m}"
      	  folder2.frameworks = 'UIKit'
      	  folder2.dependency 'WBCategoryKit/Macro'
      end

      folder1.subspec 'UIImageView' do |folder2|
          folder2.source_files = "WBCategoryKit/UIkit/UIImageView/**/*.{h,m}"
          folder2.dependency 'WBCategoryKit/Foundation/Runtime'
      end
  end
  
end
