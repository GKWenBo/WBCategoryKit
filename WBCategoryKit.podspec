Pod::Spec.new do |s|
  s.name             = 'WBCategoryKit'
  s.version          = '1.1.0'
  s.summary          = 'Some useful Objective-C Categories, Custom UIComponents and Macro'
  s.homepage         = 'https://github.com/wenmobo/WBCategoryKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wenmobo' => '1050794513@qq.com' }
  s.source           = { :git => 'https://github.com/wenmobo/WBCategoryKit.git', :tag => s.version.to_s }
  s.social_media_url = 'http://blogwenbo.com/'
  s.ios.deployment_target = '8.0'
  s.source_files = 'WBCategoryKit/WBCategoryKit.h'
  s.frameworks = 'UIKit', 'Foundation' , 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate', 'ImageIO', 'CoreText', 'CoreGraphics', 'CoreTelephony'
  s.requires_arc = true
  
  #WBUIComponents
  s.subspec 'WBUIComponents' do |folder1|
    folder1.source_files = 'WBCategoryKit/WBUIComponents/WBUIComponents.h'
    folder1.frameworks = 'Foundation', 'UIKit'
    
      #WBKeyboardManager
      folder1.subspec 'WBKeyboardManager' do |folder2|
        folder2.source_files = 'WBCategoryKit/WBUIComponents/WBKeyboardManager/**/*.{h,m}'
        folder2.frameworks = 'Foundation'
        folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #WBUIButton
      folder1.subspec 'WBUIButton' do |folder2|
        folder2.source_files = 'WBCategoryKit/WBUIComponents/WBUIButton/**/*.{h,m}'
        folder2.frameworks = 'UIKit'
        folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
        folder2.dependency 'WBCategoryKit/UIKit/CALayer'
      end

      #WBPermission
      folder1.subspec 'WBPermission' do |folder2|
      	folder2.source_files = 'WBCategoryKit/WBUIComponents/WBPermission/**/*.{h,m}'
      	folder2.frameworks = 'UIKit', 'CoreMotion', 'Photos', 'AssetsLibrary', 'AddressBook', 'Contacts', 'CoreLocation', 'EventKit', 'HealthKit', 'MediaPlayer', 'CoreTelephony', 'Speech', 'UserNotifications'
      	folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #WBUICollectionView
      folder1.subspec 'WBUICollectionView' do |folder2|
      	folder2.source_files = 'WBCategoryKit/WBUIComponents/WBUICollectionView/**/*.{h,m}'
      	folder2.frameworks = 'UIKit'
      	folder2.dependency 'WBCategoryKit/UIKit/CALayer'
      	folder2.dependency 'WBCategoryKit/UIKit/UIScrollView'
      	folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #WBUILabel
      folder1.subspec 'WBUILabel' do |folder2|
      	folder2.source_files = 'WBCategoryKit/WBUIComponents/WBUILabel/**/*.{h,m}'
      	folder2.frameworks = 'UIKit'
      	folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #WBFileManager
      folder1.subspec 'WBFileManager' do |folder2|
      	folder2.source_files = 'WBCategoryKit/WBUIComponents/WBFileManager/**/*.{h,m}'
      	folder2.frameworks = 'Foundation'
      end

      #WBCountdownManager
      folder1.subspec 'WBCountdownManager' do |folder2|
      	folder2.source_files = 'WBCategoryKit/WBUIComponents/WBCountdownManager/**/*.{h,m}'
      	folder2.frameworks = 'Foundation', 'UIKit'
      end

      #WBLogUnicode
      folder1.subspec 'WBLogUnicode' do |folder2|
        folder2.source_files = 'WBCategoryKit/WBUIComponents/WBLogUnicode/**/*.{h,m}'
        folder2.frameworks = 'Foundation'
      end
  end
  
  #Foundation
  s.subspec 'Foundation' do |folder1|
      folder1.source_files = 'WBCategoryKit/Foundation/WBFoundation.h'
      folder1.frameworks = 'Foundation', 'UIKit'
      
      #NSData
      folder1.subspec 'NSData' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSData/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      #NSDictionary
      folder1.subspec 'NSDictionary' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSDictionary/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
          folder2.dependency 'WBCategoryKit/Foundation/NSString'
      end
      
      #NSString
      folder1.subspec 'NSString' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSString/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'CoreTelephony'
          folder2.dependency 'WBCategoryKit/Foundation/NSArray'
          folder2.dependency 'WBCategoryKit/Foundation/NSCharacterSet'
      end
      
      #NSArray
      folder1.subspec 'NSArray' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSArray/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      #NSUserDefaults
      folder1.subspec 'NSUserDefaults' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSUserDefaults/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      #NSObject
      folder1.subspec 'NSObject' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSObject/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      #NSDate
      folder1.subspec 'NSDate' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSDate/**/*.{h,m}'
          folder2.frameworks = 'Foundation'
      end
      
      #NSMutableAttributedString
      folder1.subspec 'NSMutableAttributedString' do |folder2|
          folder2.source_files = 'WBCategoryKit/Foundation/NSMutableAttributedString/**/*.{h,m}'
          folder2.frameworks = 'Foundation','UIKit'
      end

      #NSCharacterSet
      folder1.subspec 'NSCharacterSet' do |folder2|
        folder2.source_files = 'WBCategoryKit/Foundation/NSCharacterSet/**/*.{h,m}'
        folder2.frameworks = 'Foundation','UIKit'
      end

  end
  
  #WBCategoryKitCore
  s.subspec 'WBCategoryKitCore' do |ss|
      ss.source_files = 'WBCategoryKit/WBCategoryKitCore/**/*.{h,m}'
      ss.frameworks = 'Foundation', 'UIKit'
      ss.dependency 'WBCategoryKit/Foundation/NSString'
  end
  
  #UIKit
  s.subspec 'UIKit' do |folder1|
      folder1.source_files = 'WBCategoryKit/UIKit/WBUIKit.h'
      folder1.frameworks = 'Foundation', 'UIKit', 'WebKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary', 'QuartzCore', 'Accelerate'
      
      #UIFont
      folder1.subspec 'UIFont' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIFont/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
          folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end
      
      #UIImage
      folder1.subspec 'UIImage' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIImage/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'ImageIO', 'CoreText', 'AVFoundation', 'Accelerate'
          folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
          folder2.dependency 'WBCategoryKit/UIKit/UIColor'
      end
      
      #UIScrollView
      folder1.subspec 'UIScrollView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIScrollView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
          folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end
      
      #UIScreen
      folder1.subspec 'UIScreen' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIScreen/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIWindow
      folder1.subspec 'UIWindow' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIWindow/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIApplication
      folder1.subspec 'UIApplication' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIApplication/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UITableViewCell
      folder1.subspec 'UITableViewCell' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UITableViewCell/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIButton
      folder1.subspec 'UIButton' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIButton/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIColor
      folder1.subspec 'UIColor' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIColor/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIAlertController
      folder1.subspec 'UIAlertController' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIAlertController/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIView
      folder1.subspec 'UIView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'QuartzCore'
      end
      
      #UINavigationItem
      folder1.subspec 'UINavigationItem' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UINavigationItem/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #WKWebView
      folder1.subspec 'WKWebView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/WKWebView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'WebKit'
          folder2.dependency 'WBCategoryKit/UIKit/UIColor'
      end
      
      #UICollectionView
      folder1.subspec 'UICollectionView' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UICollectionView/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIImagePickerController
      folder1.subspec 'UIImagePickerController' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIImagePickerController/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'MobileCoreServices', 'Photos', 'AssetsLibrary'
          folder2.dependency 'WBCategoryKit/Foundation/NSDate'
      end
      
      #UIBarButtonItem
      folder1.subspec 'UIBarButtonItem' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIBarButtonItem/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UINavigationBar
      folder1.subspec 'UINavigationBar' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UINavigationBar/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UIViewController
      folder1.subspec 'UIViewController' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIViewController/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
      end
      
      #UISearchBar
      folder1.subspec 'UISearchBar' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UISearchBar/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit'
          folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
          folder2.dependency 'WBCategoryKit/UIKit/UIImage'
          folder2.dependency 'WBCategoryKit/UIKit/UIView'
      end
      
      #UIControl
      folder1.subspec 'UIControl' do |folder2|
          folder2.source_files = 'WBCategoryKit/UIKit/UIControl/**/*.{h,m}'
          folder2.frameworks = 'Foundation', 'UIKit', 'AVFoundation'
      end

      #CALayer
      folder1.subspec 'CALayer' do |folder2|
      	  folder2.source_files = 'WBCategoryKit/UIKit/CALayer/**/*.{h,m}'
      	  folder2.frameworks = 'UIKit'
      	  folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #UILabel
      folder1.subspec 'UILabel' do |folder2|
      	  folder2.source_files = "WBCategoryKit/UIKit/UILabel/**/*.{h,m}"
      	  folder2.frameworks = 'UIKit'
      	  folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #UIImageView
      folder1.subspec 'UIImageView' do |folder2|
          folder2.source_files = "WBCategoryKit/UIKit/UIImageView/**/*.{h,m}"
          folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      end

      #UIBarItem
      folder1.subspec 'UIBarItem' do |folder2|
      	  folder2.source_files = "WBCategoryKit/UIKit/UIBarItem/**/*.{h,m}"
      	  folder2.frameworks = 'UIKit'
      	  folder2.dependency 'WBCategoryKit/WBCategoryKitCore'
      	  folder2.dependency 'WBCategoryKit/UIKit/UIViewController'
      	  folder2.dependency 'WBCategoryKit/UIKit/UIImage'
      end
  end
  
end
