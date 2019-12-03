# WBCategoryKit

<p align="left">
<a href="https://travis-ci.org/wenmobo/WBCategoryKit"><img src="https://travis-ci.org/wenmobo/WBCategoryKit.svg?style=flat?branch=master"></a>
<a href="https://travis-ci.org/wenmobo/WBCategoryKit"><img src="https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=flatt"></a>
<a  href="https://cocoapods.org/pods/WBCategoryKit"><img src ="https://img.shields.io/cocoapods/v/WBCategoryKit.svg?style=flat"> </a>
<a  href="https://cocoapods.org/pods/WBCategoryKit"><img src ="https://img.shields.io/packagist/l/doctrine/orm.svg?style=flat"> </a>
<a  href="https://cocoapods.org/pods/WBCategoryKit"><img src ="https://img.shields.io/cocoapods/p/WBCategoryKit.svg?style=flat"> </a>
<a  href="https://cocoapods.org/pods/WBCategoryKit"><img src ="https://img.shields.io/badge/language-objctive--c-red.svg?style=flat"> </a>
</p>

## 中文说明
 > Some useful Objective-C ategories and Macro,that contain UIKit.framework、Foundation.framework、AVFoundation.framework、QuartzCore. framework、CoreTelephony.framework、WebKit.framework、MobileCoreServices.framework、Photos.framework、AssetsLibrary.framework、Accelerate.framework、ImageIO.framework、CoreText.framework、CoreGraphics.framework and so on,i will continue to tidy up updates.

 iOS 系统常用框架分类封装，开发常用宏定义，支持cocoapod集成，支持只集成子模块。持续更新中...

## Requirements

- iOS 8+
- Xcode 8+

## Installation

### Cocoapods安装

- 安装所有分类文件

  ```
  pod 'WBCategoryKit'
  ```
- 安装核心组件

  ```
  pod 'WBCategoryKit/WBCategoryKitCore'
  ```

- 集成子组件

  ```
  pod 'WBCategoryKit/UIKit'
  pod 'WBCategoryKit/Foundation'
  pod 'WBCategoryKit/WBUIComponents'
  ```

或者
```ruby
pod 'WBCategoryKit/UIKit/WKWebView'
```

### 手动集成

将需要的分类文件拖入工程即可。

## Usage

coming soon...

## 补充
本库主要是记录自己积累学习的一个过程，最初在github创建这个工程的时候，我就在自己的博客中写道将来有一天将本库制作成pod公有库，如今完成了本库的制作，虽然在制作过程中遇到了很多的问题，但还是很有成就感。如过在使用过程中，有任何建议或者问题，可以通过以下方式联系我，十分感谢。

author：wenbo    
     QQ：1050794513  
  email：1050794513@qq.com   

  喜欢就❤️下鼓励下吧。

  ## 更新 
  > - 2019-12-03（1.1.0）：重要更新，文件整理归类，添加常用宏定义，工具类，自定义UI组件
  > - 2018-09-27（1.0.7）：修改XR适配宏，删除按钮倒计时分类
  > - 2018-09-05（1.0.2）：修改podspec文件，支持三级目录。

## License

WBCategoryKit is available under the MIT license. See the LICENSE file for more info.
