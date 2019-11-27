//
//  WBKeyboardManager.h
//  Pods
//
//  Created by 文波 on 2019/11/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WBUIKeyboardManagerDelegate;
@class WBUIKeyboardUserInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol WBUIKeyboardManagerDelegate <NSObject>

@optional

/**
 *  键盘即将显示
 */
- (void)keyboardWillShowWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo;

/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHideWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo;

/**
 *  键盘frame即将发生变化。
 *  这个delegate除了对应系统的willChangeFrame通知外，在iPad下还增加了监听键盘frame变化的KVO来处理浮动键盘，所以调用次数会比系统默认多。需要让界面或者某个view跟随键盘运动，建议在这个通知delegate里面实现，因为willShow和willHide在手机上是准确的，但是在iPad的浮动键盘下是不准确的。另外，如果不需要跟随浮动键盘运动，那么在逻辑代码里面可以通过判断键盘的位置来过滤这种浮动的情况。
 */
- (void)keyboardWillChangeFrameWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo;

/**
 *  键盘已经显示
 */
- (void)keyboardDidShowWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo;

/**
 *  键盘已经隐藏
 */
- (void)keyboardDidHideWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo;

/**
 *  键盘frame已经发生变化。
 */
- (void)keyboardDidChangeFrameWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo;

@end

@interface WBKeyboardManager : NSObject

/// 指定初始化方法，以 delegate 的方式将键盘事件传递给监听者
/// @param delegate 代理
- (instancetype)initWithDelegate:(id<WBUIKeyboardManagerDelegate> _Nullable)delegate NS_DESIGNATED_INITIALIZER;

/// 获取当前的 delegate
@property(nonatomic, weak, readonly) id<WBUIKeyboardManagerDelegate> delegate;

/// 是否允许触发delegate的回调，常见的场景例如在 UIViewController viewWillAppear: 里打开，在 viewWillDisappear: 里关闭，从而避免在键盘升起的状态下手势返回时界面布局会跟着键盘往下移动
/// 默认为 YES。
@property(nonatomic, assign) BOOL delegateEnabled;

/// 是否忽视 `applicationState` 状态的影响。默认为 NO，也即只有 `UIApplicationStateActive` 才会响应通知，如果设置为 YES，则任何 state 都会响应通知。
@property(nonatomic, assign) BOOL ignoreApplicationState;

/// 添加触发键盘事件的 UIResponder，一般是 UITextView 或者 UITextField ，不添加 targetResponder 的话，则默认接受任何 UIResponder 产生的键盘通知。 添加成功将会返回YES，否则返回NO。
/// @param targetResponder UIResponder
- (BOOL)addTargetResponder:(UIResponder *)targetResponder;

/// 获取当前所有的 target UIResponder，若不存在则返回 nil
- (NSArray<UIResponder *> *)allTargetResponders;

/// 移除 targetResponder 跟 keyboardManager 的关系，如果成功会返回 YES
/// @param targetResponder 要移除的UIResponder
- (BOOL)removeTargetResponder:(UIResponder *)targetResponder;

/// 把键盘的rect转为相对于view的rect。一般用来把键盘的rect转化为相对于当前 self.view 的 rect，然后获取 y 值来布局对应的 view（这里一般不要获取键盘的高度，因为对于iPad的键盘，浮动状态下键盘的高度往往不是我们想要的）。
/// @param rect 键盘的rect，一般拿 keyboardUserInfo.endFrame
/// @param view 一个特定的view或者window，如果传入nil则相对有当前的 mainWindow
+ (CGRect)convertKeyboardRect:(CGRect)rect
                       toView:(UIView * _Nullable)view;

/// 获取键盘到顶部到相对于view底部的距离，这个值在某些情况下会等于endFrame.size.height或者visibleKeyboardHeight，不过在iPad浮动键盘的时候就包括了底部的空隙。所以建议使用这个方法。
/// @param view 获取键盘到顶部到相对于view底部的距离，这个值在某些情况下会等于endFrame.size.height或者visibleKeyboardHeight，不过在iPad浮动键盘的时候就包括了底部的空隙。所以建议使用这个方法。
/// @param rect rect description
+ (CGFloat)distanceFromMinYToBottomInView:(UIView *)view
                             keyboardRect:(CGRect)rect;

///  根据键盘的动画参数自己构建一个动画，调用者只需要设置view的位置即可
/// @param animated 是否动画
/// @param keyboardUserInfo keyboardUserInfo description
/// @param animations animations description
/// @param completion completion description
+ (void)animateWithAnimated:(BOOL)animated
           keyboardUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion;

/// 这个方法特殊处理 iPad Pro 外接键盘的情况。使用外接键盘在完全不显示键盘的时候，不会调用willShow的通知，所以导致一些通过willShow回调来显示targetResponder的场景（例如微信朋友圈的评论输入框）无法把targetResponder正常的显示出来。通过这个方法，你只需要关心你的show和hide的状态就好了，不需要关心是否 iPad Pro 的情况。
/// @param keyboardUserInfo 键盘信息
/// @param showBlock 键盘显示回调的block，不能把showBlock理解为系统的show通知，而是你有输入框聚焦了并且期望键盘显示出来。
/// @param hideBlock 键盘隐藏回调的block，不能把hideBlock理解为系统的hide通知，而是键盘即将消失在界面上并且你期望跟随键盘变化的UI回到默认状态。
+ (void)handleKeyboardNotificationWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo
                                     showBlock:(void (^)(WBUIKeyboardUserInfo *keyboardUserInfo))showBlock
                                     hideBlock:(void (^)(WBUIKeyboardUserInfo *keyboardUserInfo))hideBlock;

/// 键盘面板的私有view，可能为nil
+ (UIView *)keyboardView;

/// 键盘面板所在的私有window，可能为nil
+ (UIWindow *)keyboardWindow;

/// 是否有键盘在显示
+ (BOOL)isKeyboardVisible;

/// 当前那键盘相对于屏幕的frame
+ (CGRect)currentKeyboardFrame;

/// 当前键盘高度键盘的可见高度
+ (CGFloat)visibleKeyboardHeight;

@end

// MARK: -------- WBUIKeyboardUserInfo
@interface WBUIKeyboardUserInfo : NSObject

/**
 *  所在的KeyboardManager
 */
@property(nonatomic, weak, readonly) WBKeyboardManager *keyboardManager;

/**
 *  当前键盘的notification
 */
@property(nonatomic, strong, readonly) NSNotification *notification;

/**
 *  notification自带的userInfo
 */
@property(nonatomic, strong, readonly) NSDictionary *originUserInfo;

/**
 *  触发键盘事件的UIResponder，注意这里的 `targetResponder` 不一定是通过 `addTargetResponder:` 添加的 UIResponder，而是当前触发键盘事件的 UIResponder。
 */
@property(nonatomic, weak, readonly) UIResponder *targetResponder;

/**
 *  获取键盘实际宽度
 */
@property(nonatomic, assign, readonly) CGFloat width;

/**
 *  获取键盘的实际高度
 */
@property(nonatomic, assign, readonly) CGFloat height;

/**
 *  获取当前键盘在view上的可见高度，也就是键盘和view重叠的高度。如果view=nil，则直接返回键盘的实际高度。
 */
- (CGFloat)heightInView:(UIView *)view;

/**
 *  获取键盘beginFrame
 */
@property(nonatomic, assign, readonly) CGRect beginFrame;

/**
 *  获取键盘endFrame
 */
@property(nonatomic, assign, readonly) CGRect endFrame;

/**
 *  获取键盘出现动画的duration，对于第三方键盘，这个值有可能为0
 */
@property(nonatomic, assign, readonly) NSTimeInterval animationDuration;

/**
 *  获取键盘动画的Curve参数
 */
@property(nonatomic, assign, readonly) UIViewAnimationCurve animationCurve;

/**
 *  获取键盘动画的Options参数
 */
@property(nonatomic, assign, readonly) UIViewAnimationOptions animationOptions;

@end

// MARK: -------- Category
@interface UIResponder (WBKeyboardManager)

/// 持有KeyboardManager对象
@property(nonatomic, strong) WBKeyboardManager *wb_keyboardManager;

@end

@interface UITextField (WBKeyboardManager)

/// 键盘相关block，搭配QMUIKeyboardManager一起使用

@property(nonatomic, copy) void (^wb_keyboardWillShowNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardWillHideNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardWillChangeFrameNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardDidShowNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardDidHideNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardDidChangeFrameNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);

@end

@interface UITextView (WBKeyboardManager)

/// 键盘相关block，搭配QMUIKeyboardManager一起使用

@property(nonatomic, copy) void (^wb_keyboardWillShowNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardWillHideNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardWillChangeFrameNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardDidShowNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardDidHideNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);
@property(nonatomic, copy) void (^wb_keyboardDidChangeFrameNotificationBlock)(WBUIKeyboardUserInfo *keyboardUserInfo);

@end

NS_ASSUME_NONNULL_END
