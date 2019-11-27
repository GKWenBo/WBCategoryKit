//
//  WBKeyboardManager.m
//  Pods
//
//  Created by 文波 on 2019/11/26.
//

#import "WBKeyboardManager.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"

@interface UIView (WBKeyboardManager)

- (id)wb_keyboardFindFirstResponder;

@end

@implementation UIView (WBKeyboardManager)

- (id)wb_keyboardFindFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView wb_keyboardFindFirstResponder];
        if (responder) return responder;
    }
    return nil;
}

@end

@interface UIResponder ()

/// 系统自己的isFirstResponder有延迟，这里手动记录UIResponder是否isFirstResponder，QMUIKeyboardManager内部自己使用
@property(nonatomic, assign) BOOL keyboardManager_isFirstResponder;

@end

@implementation UIResponder (WBKeyboardManager)

// MARK: -------- getter && setter
- (void)setKeyboardManager_isFirstResponder:(BOOL)keyboardManager_isFirstResponder {
    objc_setAssociatedObject(self, @selector(keyboardManager_isFirstResponder), @(keyboardManager_isFirstResponder), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isKeyboardManager_isFirstResponder {
    return [objc_getAssociatedObject(self, @selector(keyboardManager_isFirstResponder)) boolValue];
}

- (void)setWb_keyboardManager:(WBKeyboardManager *)wb_keyboardManager {
    objc_setAssociatedObject(self, @selector(wb_keyboardManager), wb_keyboardManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WBKeyboardManager *)wb_keyboardManager {
    return objc_getAssociatedObject(self, @selector(wb_keyboardManager));
}

// MARK: ------- Load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        WBOverrideImplementation([UIResponder class], @selector(becomeFirstResponder), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^BOOL(UIResponder *selfObject) {
                selfObject.keyboardManager_isFirstResponder = YES;
                
                BOOL (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (BOOL(*)(id, SEL))originalIMPProvider();
                
                BOOL res = originSelectorIMP(selfObject, originCMD);
                return res;
            };
        });
        
        WBOverrideImplementation([UIResponder class], @selector(resignFirstResponder), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^BOOL(UIResponder *selfObject) {
                selfObject.keyboardManager_isFirstResponder = NO;
                
                BOOL (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (BOOL(*)(id, SEL))originalIMPProvider();
                
                BOOL res = originSelectorIMP(selfObject, originCMD);
                return res;
            };
        });
    });
}

@end

// MARK: ------- WBUIKeyboardUserInfo

@interface WBUIKeyboardUserInfo ()

@property(nonatomic, weak, readwrite) WBKeyboardManager *keyboardManager;
@property(nonatomic, strong, readwrite) NSNotification *notification;
@property(nonatomic, weak, readwrite) UIResponder *targetResponder;
@property(nonatomic, assign) BOOL isTargetResponderFocused;

@property(nonatomic, assign, readwrite) CGFloat width;
@property(nonatomic, assign, readwrite) CGFloat height;

@property(nonatomic, assign, readwrite) CGRect beginFrame;
@property(nonatomic, assign, readwrite) CGRect endFrame;
@property(nonatomic, assign, readwrite) NSTimeInterval animationDuration;
@property(nonatomic, assign, readwrite) UIViewAnimationCurve animationCurve;
@property(nonatomic, assign, readwrite) UIViewAnimationOptions animationOptions;

@end

@implementation WBUIKeyboardUserInfo

- (void)setNotification:(NSNotification *)notification {
    _notification = notification;
    if (self.originUserInfo) {
        
        _animationDuration = [[self.originUserInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        _animationCurve = (UIViewAnimationCurve)[[self.originUserInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        _animationOptions = self.animationCurve<<16;
        
        CGRect beginFrame = [[self.originUserInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endFrame = [[self.originUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        if (@available(iOS 13.0, *)) {
            // iOS 13 分屏键盘 x 不是 0，不知道是系统 BUG 还是故意这样，先这样保护，再观察一下后面的 beta 版本
            if (WB_IS_SPLIT_SCREEN_IPAD && beginFrame.origin.x > 0) {
                beginFrame.origin.x = 0;
            }
            if (WB_IS_SPLIT_SCREEN_IPAD && endFrame.origin.x > 0) {
                endFrame.origin.x = 0;
            }
        }
        
        _beginFrame = beginFrame;
        _endFrame = endFrame;
    }
}

- (void)setTargetResponder:(UIResponder *)targetResponder {
    _targetResponder = targetResponder;
    self.isTargetResponderFocused = targetResponder && targetResponder.keyboardManager_isFirstResponder;
}

- (NSDictionary *)originUserInfo {
    return self.notification ? self.notification.userInfo : nil;
}

- (CGFloat)width {
    CGRect keyboardRect = [WBKeyboardManager convertKeyboardRect:_endFrame
                                                          toView:nil];
    return keyboardRect.size.width;
}

- (CGFloat)height {
    CGRect keyboardRect = [WBKeyboardManager convertKeyboardRect:_endFrame
                                                          toView:nil];
    return keyboardRect.size.height;
}

- (CGFloat)heightInView:(UIView *)view {
    if (!view) {
        return [self height];
    }
    CGRect keyboardRect = [WBKeyboardManager convertKeyboardRect:_endFrame
                                                          toView:view];
    CGRect visibleRect = CGRectIntersection(WBCGRectFlatted(view.bounds), WBCGRectFlatted(keyboardRect));
    if (!WBCGRectIsValidated(visibleRect)) {
        return 0;
    }
    return visibleRect.size.height;
}

- (CGRect)beginFrame {
    return _beginFrame;
}

- (CGRect)endFrame {
    return _endFrame;
}

- (NSTimeInterval)animationDuration {
    return _animationDuration;
}

- (UIViewAnimationCurve)animationCurve {
    return _animationCurve;
}

- (UIViewAnimationOptions)animationOptions {
    return _animationOptions;
}

@end

@interface WBUIKeyboardViewFrameObserver : NSObject

@property (nonatomic, copy) void (^keyboardViewChangeFrameBlock)(UIView *keyboardView);
- (void)addToKeyboardView:(UIView *)keyboardView;
+ (instancetype)observerForView:(UIView *)keyboardView;

@end

static char kAssociatedObjectKey_KeyboardViewFrameObserver;
@implementation WBUIKeyboardViewFrameObserver
{
    __unsafe_unretained UIView *_keyboardView;
}

- (void)addToKeyboardView:(UIView *)keyboardView {
    if (_keyboardView == keyboardView) {
        return;
    }
    if (_keyboardView) {
        [self removeFrameObserver];
        objc_setAssociatedObject(_keyboardView, &kAssociatedObjectKey_KeyboardViewFrameObserver, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _keyboardView = keyboardView;
    if (keyboardView) {
        [self addFrameObserver];
    }
    objc_setAssociatedObject(keyboardView, &kAssociatedObjectKey_KeyboardViewFrameObserver, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addFrameObserver {
    if (!_keyboardView) {
        return;
    }
    [_keyboardView addObserver:self forKeyPath:@"frame" options:kNilOptions context:NULL];
    [_keyboardView addObserver:self forKeyPath:@"center" options:kNilOptions context:NULL];
    [_keyboardView addObserver:self forKeyPath:@"bounds" options:kNilOptions context:NULL];
    [_keyboardView addObserver:self forKeyPath:@"transform" options:kNilOptions context:NULL];
}

- (void)removeFrameObserver {
    [_keyboardView removeObserver:self forKeyPath:@"frame"];
    [_keyboardView removeObserver:self forKeyPath:@"center"];
    [_keyboardView removeObserver:self forKeyPath:@"bounds"];
    [_keyboardView removeObserver:self forKeyPath:@"transform"];
    _keyboardView = nil;
}

- (void)dealloc {
    [self removeFrameObserver];
}

+ (instancetype)observerForView:(UIView *)keyboardView {
    if (!keyboardView) {
        return nil;
    }
    return objc_getAssociatedObject(keyboardView, &kAssociatedObjectKey_KeyboardViewFrameObserver);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:@"frame"] &&
        ![keyPath isEqualToString:@"center"] &&
        ![keyPath isEqualToString:@"bounds"] &&
        ![keyPath isEqualToString:@"transform"]) {
        return;
    }
    if ([[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
        return;
    }
    if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] != NSKeyValueChangeSetting) {
        return;
    }
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (newValue == [NSNull null]) { newValue = nil; }
    if (self.keyboardViewChangeFrameBlock) {
        self.keyboardViewChangeFrameBlock(_keyboardView);
    }
}


@end

/**
1. 系统键盘app启动第一次使用键盘的时候，会调用两轮键盘通知事件，之后就只会调用一次。而搜狗等第三方输入法的键盘，目前发现每次都会调用三次键盘通知事件。总之，键盘的通知事件是不确定的。

2. 搜狗键盘可以修改键盘的高度，在修改键盘高度之后，会调用键盘的keyboardWillChangeFrameNotification和keyboardWillShowNotification通知。

3. 如果从一个聚焦的输入框直接聚焦到另一个输入框，会调用前一个输入框的keyboardWillChangeFrameNotification，在调用后一个输入框的keyboardWillChangeFrameNotification，最后调用后一个输入框的keyboardWillShowNotification（如果此时是浮动键盘，那么后一个输入框的keyboardWillShowNotification不会被调用；）。

4. iPad可以变成浮动键盘，固定->浮动：会调用keyboardWillChangeFrameNotification和keyboardWillHideNotification；浮动->固定：会调用keyboardWillChangeFrameNotification和keyboardWillShowNotification；浮动键盘在移动的时候只会调用keyboardWillChangeFrameNotification通知，并且endFrame为zero，fromFrame不为zero，而是移动前键盘的frame。浮动键盘在聚焦和失焦的时候只会调用keyboardWillChangeFrameNotification，不会调用show和hide的notification。

5. iPad可以拆分为左右的小键盘，小键盘的通知具体基本跟浮动键盘一样。

6. iPad可以外接键盘，外接键盘之后屏幕上就没有虚拟键盘了，但是当我们输入文字的时候，发现底部还是有一条灰色的候选词，条东西也是键盘，它也会触发跟虚拟键盘一样的通知事件。如果点击这条候选词右边的向下箭头，则可以完全隐藏虚拟键盘，这个时候如果失焦再聚焦发现还是没有这条候选词，也就是键盘完全不出来了，如果输入文字，候选词才会重新出来。总结来说就是这条候选词是可以关闭的，关闭之后只有当下次输入才会重新出现。（聚焦和失焦都只调用keyboardWillChangeFrameNotification和keyboardWillHideNotification通知，而且frame始终不变，都是在屏幕下面）

7. iOS8 hide 之后高度变成0了，keyboardWillHideNotification还是正常的，所以建议不要使用键盘高度来做动画，而是用键盘的y值；在show和hide的时候endFrame会出现一些奇怪的中间值，但最终值是对的；两个输入框切换聚焦，iOS8不会触发任何键盘通知；iOS8的浮动切换正常；

8. iOS8在 固定->浮动 的过程中，后面的keyboardWillChangeFrameNotification和keyboardWillHideNotification里面的endFrame是正确的，而iOS10和iOS9是错的，iOS9的y值是键盘的MaxY，而iOS10的y值是隐藏状态下的y，也就是屏幕高度。所以iOS9和iOS10需要在keyboardDidChangeFrameNotification里面重新刷新一下。
*/

@interface WBKeyboardManager ()

@property(nonatomic, strong) NSMutableArray <NSValue *> *targetResponderValues;

@property(nonatomic, strong) WBUIKeyboardUserInfo *lastUserInfo;
@property(nonatomic, assign) CGRect keyboardMoveBeginRect;

@property(nonatomic, weak) UIResponder *currentResponder;
//@property(nonatomic, weak) UIResponder *currentResponderWhenResign;

@end

static WBKeyboardManager *kKeyboardManagerInstance;

@implementation WBKeyboardManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kKeyboardManagerInstance = [[WBKeyboardManager alloc]initWithDelegate:nil];
    });
}

- (instancetype)init {
    NSAssert(NO, @"请使用initWithDelegate:初始化");
    return [self initWithDelegate:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(NO, @"请使用initWithDelegate:初始化");
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<WBUIKeyboardManagerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _delegateEnabled = YES;
        _targetResponderValues = [[NSMutableArray alloc] init];
        
        [self addKeyboardNotification];
    }
    return self;
}

- (BOOL)addTargetResponder:(UIResponder *)targetResponder {
    if (!targetResponder || ![targetResponder isKindOfClass:[UIResponder class]]) {
        return NO;
    }
    targetResponder.wb_keyboardManager = self;
    [self.targetResponderValues addObject:[self packageTargetResponder:targetResponder]];
    return YES;
}

- (NSArray<UIResponder *> *)allTargetResponders {
    NSMutableArray *targetResponders = nil;
    for (int i = 0; i < self.targetResponderValues.count; i++) {
        if (!targetResponders) {
            targetResponders = [[NSMutableArray alloc] init];
        }
        id unPackageValue = [self unPackageTargetResponder:self.targetResponderValues[i]];
        if (unPackageValue && [unPackageValue isKindOfClass:[UIResponder class]]) {
            [targetResponders addObject:(UIResponder *)unPackageValue];
        }
    }
    return [targetResponders copy];
}

- (BOOL)removeTargetResponder:(UIResponder *)targetResponder {
    if (targetResponder && [self.targetResponderValues containsObject:[self packageTargetResponder:targetResponder]]) {
        [self.targetResponderValues removeObject:[self packageTargetResponder:targetResponder]];
        return YES;
    }
    return NO;
}

- (UIResponder *)unPackageTargetResponder:(NSValue *)value {
    if (!value) {
        return nil;
    }
    id unPackageValue = [value nonretainedObjectValue];
    if (![unPackageValue isKindOfClass:[UIResponder class]]) {
        return nil;
    }
    return (UIResponder *)unPackageValue;
}

#pragma mark - Notification
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    if (WB_IS_DEBUG) {
        NSLog(@"keyboardWillShowNotification - %@", NSStringFromClass(self.class));
    }
    
    if (![self isAppActive] || ![self isLocalKeyboard:notification]) {
        NSLog(@"%@app is not active", NSStringFromClass(self.class))
        return;
    }
    
    if (![self shouldReceiveShowNotification]) {
        return;
    }
    
    WBUIKeyboardUserInfo *userInfo = [self newUserInfoWithNotification:notification];
    self.lastUserInfo = userInfo;
    userInfo.targetResponder = self.currentResponder ?: nil;
    
    if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardWillShowWithUserInfo:)]) {
        [self.delegate keyboardWillShowWithUserInfo:userInfo];
    }
    
    // 额外处理iPad浮动键盘
    if (WB_IS_IPAD) {
        [self keyboardDidChangedFrame:[self.class keyboardView]];
    }
}

- (void)keyboardDidChangedFrame:(UIView *)keyboardView {
    if (keyboardView != [self.class keyboardView]) {
        return;
    }
    
    // 也需要判断targetResponder
    if (![self shouldReceiveShowNotification] && ![self shouldReceiveHideNotification]) {
        return;
    }
    
    if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardWillChangeFrameWithUserInfo:)]) {
        
        UIWindow *keyboardWindow = keyboardView.window;
        
        if (self.keyboardMoveBeginRect.size.width == 0 && self.keyboardMoveBeginRect.size.height == 0) {
            // 第一次需要初始化
            self.keyboardMoveBeginRect = CGRectMake(0, keyboardWindow.bounds.size.height, keyboardWindow.bounds.size.width, 0);
        }
        
        CGRect endFrame = CGRectZero;
        if (keyboardWindow) {
            endFrame = [keyboardWindow convertRect:keyboardView.frame toWindow:nil];
        } else {
            endFrame = keyboardView.frame;
        }
        
        // 自己构造一个QMUIKeyboardUserInfo，一些属性使用之前最后一个keyboardUserInfo的值
        WBUIKeyboardUserInfo *keyboardMoveUserInfo = [[WBUIKeyboardUserInfo alloc] init];
        keyboardMoveUserInfo.keyboardManager = self;
        keyboardMoveUserInfo.targetResponder = self.lastUserInfo ? self.lastUserInfo.targetResponder : nil;
        keyboardMoveUserInfo.animationDuration = self.lastUserInfo ? self.lastUserInfo.animationDuration : 0.25;
        keyboardMoveUserInfo.animationCurve = self.lastUserInfo ? self.lastUserInfo.animationCurve : 7;
        keyboardMoveUserInfo.animationOptions = self.lastUserInfo ? self.lastUserInfo.animationOptions : keyboardMoveUserInfo.animationCurve<<16;
        keyboardMoveUserInfo.beginFrame = self.keyboardMoveBeginRect;
        keyboardMoveUserInfo.endFrame = endFrame;
        
        if (WB_IS_DEBUG) {
            NSLog(@"keyboardDidMoveNotification - %@\n", self);
        }
        
        [self.delegate keyboardWillChangeFrameWithUserInfo:keyboardMoveUserInfo];
        
        self.keyboardMoveBeginRect = endFrame;
        
        if (self.currentResponder) {
            UIWindow *mainWindow = UIApplication.sharedApplication.keyWindow ?: UIApplication.sharedApplication.windows.firstObject;
            if (mainWindow) {
                CGRect keyboardRect = keyboardMoveUserInfo.endFrame;
                CGFloat distanceFromBottom = [WBKeyboardManager distanceFromMinYToBottomInView:mainWindow keyboardRect:keyboardRect];
                if (distanceFromBottom < keyboardRect.size.height) {
                    if (!self.currentResponder.keyboardManager_isFirstResponder) {
                        // willHide
                        self.currentResponder = nil;
                    }
                } else if (distanceFromBottom > keyboardRect.size.height && !self.currentResponder.isFirstResponder) {
                    if (!self.currentResponder.keyboardManager_isFirstResponder) {
                        // 浮动
                        self.currentResponder = nil;
                    }
                }
            }
        }
        
    }
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    if (WB_IS_DEBUG) {
        NSLog(@"keyboardDidShowNotification - %@", NSStringFromClass(self.class));
    }
    
    if (![self isAppActive] || ![self isLocalKeyboard:notification]) {
        NSLog(@"%@app is not active", NSStringFromClass(self.class))
        return;
    }
    
    WBUIKeyboardUserInfo *userInfo = [self newUserInfoWithNotification:notification];
    self.lastUserInfo = userInfo;
    userInfo.targetResponder = self.currentResponder ?: nil;
    
    id firstResponder = [self firstResponderInWindows];
    BOOL shouldReceiveDidShowNotification = self.targetResponderValues.count <= 0 || (firstResponder && firstResponder == self.currentResponder);
    
    if (shouldReceiveDidShowNotification) {
        if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardDidShowWithUserInfo:)]) {
            [self.delegate keyboardDidShowWithUserInfo:userInfo];
        }
        // 额外处理iPad浮动键盘
        if (WB_IS_IPAD) {
            [self keyboardDidChangedFrame:[self.class keyboardView]];
        }
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if (WB_IS_DEBUG) {
        NSLog(@"keyboardWillHideNotification - %@", NSStringFromClass(self.class));
    }
    
    if (![self isAppActive] || ![self isLocalKeyboard:notification]) {
        NSLog(@"%@app is not active", NSStringFromClass(self.class));
        return;
    }
    
    if (![self shouldReceiveHideNotification]) {
        return;
    }
    
    WBUIKeyboardUserInfo *userInfo = [self newUserInfoWithNotification:notification];
    self.lastUserInfo = userInfo;
    userInfo.targetResponder = self.currentResponder ?: nil;
    
    if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardWillHideWithUserInfo:)]) {
        [self.delegate keyboardWillHideWithUserInfo:userInfo];
    }
    
    // 额外处理iPad浮动键盘
    if (WB_IS_IPAD) {
        [self keyboardDidChangedFrame:[self.class keyboardView]];
    }
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    if (WB_IS_DEBUG) {
        NSLog(@"keyboardDidHideNotification - %@", NSStringFromClass(self.class));
    }
    
    if (![self isAppActive] || ![self isLocalKeyboard:notification]) {
        NSLog(@"%@app is not active", NSStringFromClass(self.class))
        return;
    }
    
    WBUIKeyboardUserInfo *userInfo = [self newUserInfoWithNotification:notification];
    self.lastUserInfo = userInfo;
    userInfo.targetResponder = self.currentResponder ?: nil;
    
    if ([self shouldReceiveHideNotification]) {
        if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardDidHideWithUserInfo:)]) {
            [self.delegate keyboardDidHideWithUserInfo:userInfo];
        }
    }
    
    if (self.currentResponder && !self.currentResponder.keyboardManager_isFirstResponder && !WB_IS_IPAD) {
        // 时机最晚，设置为 nil
        self.currentResponder = nil;
    }
    
    // 额外处理iPad浮动键盘
    if (WB_IS_IPAD) {
        if (self.targetResponderValues.count <= 0 || self.currentResponder) {
            [self keyboardDidChangedFrame:[self.class keyboardView]];
        }
    }
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    if (WB_IS_DEBUG) {
        NSLog(@"keyboardWillChangeFrameNotification - %@", NSStringFromClass(self.class));
    }
    
    if (![self isAppActive] || ![self isLocalKeyboard:notification]) {
        NSLog(@"%@app is not active", NSStringFromClass(self.class));
        return;
    }
    
    WBUIKeyboardUserInfo *userInfo = [self newUserInfoWithNotification:notification];
    self.lastUserInfo = userInfo;
    
    if ([self shouldReceiveShowNotification] || [self shouldReceiveHideNotification]) {
        userInfo.targetResponder = self.currentResponder ?: nil;
    } else {
        return;
    }
    
    if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardWillChangeFrameWithUserInfo:)]) {
        [self.delegate keyboardWillChangeFrameWithUserInfo:userInfo];
    }
    
    // 额外处理iPad浮动键盘
    if (WB_IS_IPAD) {
        [self addFrameObserverIfNeeded];
    }
}

- (void)keyboardDidChangeFrameNotification:(NSNotification *)notification {
    if (WB_IS_DEBUG) {
        NSLog(@"keyboardDidChangeFrameNotification - %@", NSStringFromClass(self.class));
    }
    
    if (![self isAppActive] || ![self isLocalKeyboard:notification]) {
        NSLog(@"%@app is not active", NSStringFromClass(self.class));
        return;
    }
    
    WBUIKeyboardUserInfo *userInfo = [self newUserInfoWithNotification:notification];
    self.lastUserInfo = userInfo;
    
    if ([self shouldReceiveShowNotification] || [self shouldReceiveHideNotification]) {
        userInfo.targetResponder = self.currentResponder ?: nil;
    } else {
        return;
    }
    
    if (self.delegateEnabled && [self.delegate respondsToSelector:@selector(keyboardDidChangeFrameWithUserInfo:)]) {
        [self.delegate keyboardDidChangeFrameWithUserInfo:userInfo];
    }
    
    // 额外处理iPad浮动键盘
    if (WB_IS_IPAD) {
        [self keyboardDidChangedFrame:[self.class keyboardView]];
    }
}


#pragma mark - iPad浮动键盘
- (void)addFrameObserverIfNeeded {
    if (![self.class keyboardView]) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    WBUIKeyboardViewFrameObserver *observer = [WBUIKeyboardViewFrameObserver observerForView:[self.class keyboardView]];
    if (!observer) {
        observer = [[WBUIKeyboardViewFrameObserver alloc] init];
        observer.keyboardViewChangeFrameBlock = ^(UIView *keyboardView) {
            [weakSelf keyboardDidChangedFrame:keyboardView];
        };
        [observer addToKeyboardView:[self.class keyboardView]];
        [self keyboardDidChangedFrame:[self.class keyboardView]]; // 手动调用第一次
    }
}

// MARK: ------- Private Method
- (BOOL)shouldReceiveHideNotification {
    if (self.targetResponderValues.count <= 0) {
        return YES;
    } else {
        if (self.currentResponder) {
            return [self.targetResponderValues containsObject:[self packageTargetResponder:self.currentResponder]];
        } else {
            return NO;
        }
    }
}

- (WBUIKeyboardUserInfo *)newUserInfoWithNotification:(NSNotification *)notification {
    WBUIKeyboardUserInfo *userInfo = [[WBUIKeyboardUserInfo alloc] init];
    userInfo.keyboardManager = self;
    userInfo.notification = notification;
    return userInfo;
}

- (UIResponder *)firstResponderInWindows {
    UIResponder *responder = [UIApplication.sharedApplication.keyWindow wb_keyboardFindFirstResponder];
    if (!responder) {
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window != UIApplication.sharedApplication.keyWindow) {
                responder = [window wb_keyboardFindFirstResponder];
                if (responder) {
                    return responder;
                }
            }
        }
    }
    return responder;
}

- (BOOL)shouldReceiveShowNotification {
    UIResponder *firstResponder = [self firstResponderInWindows];
    if (self.currentResponder) {
         // 这里有 BUG，如果点击了 webview 导致键盘下降，这个时候运行 shouldReceiveHideNotification 就会判断错误，所以如果发现是 nil 或是 WKContentView 则值不变
        if (firstResponder && ![firstResponder isKindOfClass:NSClassFromString(@"WKContentView")]) {
            self.currentResponder = firstResponder;
        }
    } else {
        self.currentResponder = firstResponder;
    }

    if (self.targetResponderValues.count <= 0) {
        return YES;
    } else {
        return self.currentResponder && [self.targetResponderValues containsObject:[self packageTargetResponder:self.currentResponder]];
    }
}

- (NSValue *)packageTargetResponder:(UIResponder *)targetResponder {
    if (![targetResponder isKindOfClass:[UIResponder class]]) {
        return nil;
    }
    return [NSValue valueWithNonretainedObject:targetResponder];
}

- (BOOL)isAppActive {
    if (self.ignoreApplicationState) {
        return YES;
    }
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
        return YES;
    }
    return NO;
}

- (BOOL)isLocalKeyboard:(NSNotification *)notification {
    if (@available(iOS 9.0, *)) {
        if ([[notification.userInfo valueForKey:UIKeyboardIsLocalUserInfoKey] boolValue]) {
            return YES;
        }
    } else {
        // Fallback on earlier versions
    }
    if (WB_IS_SPLIT_SCREEN_IPAD) {
        return YES;
    }
    return NO;
}

// MARK: -------- 工具方法
+ (void)animateWithAnimated:(BOOL)animated
           keyboardUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo
                 animations:(void (^)(void))animations
                 completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:keyboardUserInfo.animationDuration
                              delay:0
                            options:keyboardUserInfo.animationOptions|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            if (animations) {
                animations();
            }
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        if (animations) {
            animations();
        }
        if (completion) {
            completion(YES);
        }
    }
}

+ (void)handleKeyboardNotificationWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo
                                     showBlock:(void (^)(WBUIKeyboardUserInfo *keyboardUserInfo))showBlock
                                     hideBlock:(void (^)(WBUIKeyboardUserInfo *keyboardUserInfo))hideBlock {
    // 专门处理 iPad Pro 在键盘完全不显示的情况（不会调用willShow，所以通过是否focus来判断）
    // iPhoneX Max 这里键盘高度不是0，而是一个很小的值
    if ([WBKeyboardManager visibleKeyboardHeight] <= 0 && !keyboardUserInfo.isTargetResponderFocused) {
        if (hideBlock) {
            hideBlock(keyboardUserInfo);
        }
    } else {
        if (showBlock) {
            showBlock(keyboardUserInfo);
        }
    }
}

+ (UIWindow *)keyboardWindow {
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        if ([self getKeyboardViewFromWindow:window]) {
            return window;
        }
    }
    
    NSMutableArray *kbWindows = nil;
    
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        NSString *windowName = NSStringFromClass(window.class);
        if ([windowName isEqualToString:[NSString stringWithFormat:@"UI%@%@", @"Remote", @"KeyboardWindow"]]) {
            // UIRemoteKeyboardWindow（iOS9 以下 UITextEffectsWindow）
            if (!kbWindows) kbWindows = [NSMutableArray new];
            [kbWindows addObject:window];
        }
    }
    
    if (kbWindows.count == 1) {
        return kbWindows.firstObject;
    }
    
    return nil;
}

+ (UIView *)getKeyboardViewFromWindow:(UIWindow *)window {
    if (!window) return nil;
    
    NSString *windowName = NSStringFromClass(window.class);
    if (![windowName isEqualToString:@"UIRemoteKeyboardWindow"]) {
        return nil;
    }
    
    for (UIView *view in window.subviews) {
        NSString *viewName = NSStringFromClass(view.class);
        if (![viewName isEqualToString:@"UIInputSetContainerView"]) {
            continue;
        }
        for (UIView *subView in view.subviews) {
            NSString *subViewName = NSStringFromClass(subView.class);
            if (![subViewName isEqualToString:@"UIInputSetHostView"]) {
                continue;
            }
            return subView;
        }
    }
    
    return nil;
}

+ (CGRect)convertKeyboardRect:(CGRect)rect
                       toView:(UIView *)view {
    if (CGRectIsNull(rect) || CGRectIsInfinite(rect)) {
        return rect;
    }
    
    UIWindow *mainWindow = UIApplication.sharedApplication.keyWindow ?: UIApplication.sharedApplication.windows.firstObject;
    if (!mainWindow) {
        if (view) {
            [view convertRect:rect fromView:nil];
        } else {
            return rect;
        }
    }
    
    rect = [mainWindow convertRect:rect fromWindow:nil];
    if (!view) {
        return [mainWindow convertRect:rect toWindow:nil];
    }
    if (view == mainWindow) {
        return rect;
    }
    
    UIWindow *toWindow = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!mainWindow || !toWindow) {
        return [mainWindow convertRect:rect toView:view];
    }
    if (mainWindow == toWindow) {
        return [mainWindow convertRect:rect toView:view];
    }
    
    rect = [mainWindow convertRect:rect toView:mainWindow];
    rect = [toWindow convertRect:rect fromWindow:mainWindow];
    rect = [view convertRect:rect fromView:toWindow];
    
    return rect;
}

+ (CGFloat)distanceFromMinYToBottomInView:(UIView *)view keyboardRect:(CGRect)rect {
    rect = [self convertKeyboardRect:rect toView:view];
    CGFloat distance = CGRectGetHeight(WBCGRectFlatted(view.bounds)) - CGRectGetMinY(rect);
    return distance;
}

+ (UIView *)keyboardView {
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        UIView *view = [self getKeyboardViewFromWindow:window];
        if (view) {
            return view;
        }
    }
    return nil;
}

+ (BOOL)isKeyboardVisible {
    UIView *keyboardView = self.keyboardView;
    UIWindow *keyboardWindow = keyboardView.window;
    if (!keyboardView || !keyboardWindow) {
        return NO;
    }
    CGRect rect = CGRectIntersection(WBCGRectFlatted(keyboardWindow.bounds), WBCGRectFlatted(keyboardView.frame));
    if (WBCGRectIsValidated(rect) && !CGRectIsEmpty(rect)) {
        return YES;
    }
    return NO;
}

+ (CGRect)currentKeyboardFrame {
    UIView *keyboardView = [self keyboardView];
    if (!keyboardView) {
        return CGRectNull;
    }
    UIWindow *keyboardWindow = keyboardView.window;
    if (keyboardWindow) {
        return [keyboardWindow convertRect:WBCGRectFlatted(keyboardView.frame) toWindow:nil];
    } else {
        return WBCGRectFlatted(keyboardView.frame);
    }
}

+ (CGFloat)visibleKeyboardHeight {
    UIView *keyboardView = [self keyboardView];
    UIWindow *keyboardWindow = keyboardView.window;
    if (!keyboardView || !keyboardWindow) {
        return 0;
    } else {
        CGRect visibleRect = CGRectIntersection(WBCGRectFlatted(keyboardWindow.bounds), WBCGRectFlatted(keyboardView.frame));
        if (WBCGRectIsValidated(visibleRect)) {
            return CGRectGetHeight(visibleRect);
        }
        return 0;
    }
}

@end

// MARK: -------- Category
@interface UITextField () <WBUIKeyboardManagerDelegate>

@end

@implementation UITextField (WBKeyboardManager)

static char kAssociatedObjectKey_keyboardWillShowNotificationBlock;
- (void)setWb_keyboardWillShowNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillShowNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardWillShowNotificationBlock, wb_keyboardWillShowNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardWillShowNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillShowNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardWillShowNotificationBlock);
}

static char kAssociatedObjectKey_keyboardDidShowNotificationBlock;
- (void)setWb_keyboardDidShowNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidShowNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardDidShowNotificationBlock, wb_keyboardDidShowNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardDidShowNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidShowNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardDidShowNotificationBlock);
}

static char kAssociatedObjectKey_keyboardWillHideNotificationBlock;
- (void)setWb_keyboardWillHideNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillHideNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardWillHideNotificationBlock, wb_keyboardWillHideNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardWillHideNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillHideNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardWillHideNotificationBlock);
}

static char kAssociatedObjectKey_keyboardDidHideNotificationBlock;
- (void)setWb_keyboardDidHideNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidHideNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardDidHideNotificationBlock, wb_keyboardDidHideNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardDidHideNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidHideNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardDidHideNotificationBlock);
}

static char kAssociatedObjectKey_keyboardWillChangeFrameNotificationBlock;
- (void)setWb_keyboardWillChangeFrameNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillChangeFrameNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardWillChangeFrameNotificationBlock, wb_keyboardWillChangeFrameNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardWillChangeFrameNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillChangeFrameNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardWillChangeFrameNotificationBlock);
}

static char kAssociatedObjectKey_keyboardDidChagneFrameNotificationBlock;
- (void)setWb_keyboardDidChangeFrameNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidChangeFrameNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardDidChagneFrameNotificationBlock, wb_keyboardDidChangeFrameNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardDidChangeFrameNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidChangeFrameNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardDidChagneFrameNotificationBlock);
}

- (void)initKeyboardManagerIfNeeded {
    if (!self.wb_keyboardManager) {
        self.wb_keyboardManager = [[WBKeyboardManager alloc] initWithDelegate:self];
        [self.wb_keyboardManager addTargetResponder:self];
    }
}

// MARK: ------- WBUIKeyboardManagerDelegate
- (void)keyboardWillShowWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardWillShowNotificationBlock) {
        self.wb_keyboardWillShowNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardWillHideWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardWillHideNotificationBlock) {
        self.wb_keyboardWillHideNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardWillChangeFrameWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardWillChangeFrameNotificationBlock) {
        self.wb_keyboardWillChangeFrameNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardDidShowWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardDidShowNotificationBlock) {
        self.wb_keyboardDidShowNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardDidHideWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardDidHideNotificationBlock) {
        self.wb_keyboardDidHideNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardDidChangeFrameWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardDidChangeFrameNotificationBlock) {
        self.wb_keyboardDidChangeFrameNotificationBlock(keyboardUserInfo);
    }
}

@end

@interface UITextView () <WBUIKeyboardManagerDelegate>

@end

@implementation UITextView (WBKeyboardManager)

static char kAssociatedObjectKey_keyboardWillShowNotificationBlock;
- (void)setWb_keyboardWillShowNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillShowNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardWillShowNotificationBlock, wb_keyboardWillShowNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardWillShowNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillShowNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardWillShowNotificationBlock);
}

static char kAssociatedObjectKey_keyboardDidShowNotificationBlock;
- (void)setWb_keyboardDidShowNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidShowNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardDidShowNotificationBlock, wb_keyboardDidShowNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardDidShowNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidShowNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardDidShowNotificationBlock);
}

static char kAssociatedObjectKey_keyboardWillHideNotificationBlock;
- (void)setWb_keyboardWillHideNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillHideNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardWillHideNotificationBlock, wb_keyboardWillHideNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardWillHideNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillHideNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardWillHideNotificationBlock);
}

static char kAssociatedObjectKey_keyboardDidHideNotificationBlock;
- (void)setWb_keyboardDidHideNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidHideNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardDidHideNotificationBlock, wb_keyboardDidHideNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardDidHideNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidHideNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardDidHideNotificationBlock);
}

static char kAssociatedObjectKey_keyboardWillChangeFrameNotificationBlock;
- (void)setWb_keyboardWillChangeFrameNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillChangeFrameNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardWillChangeFrameNotificationBlock, wb_keyboardWillChangeFrameNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardWillChangeFrameNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardWillChangeFrameNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardWillChangeFrameNotificationBlock);
}

static char kAssociatedObjectKey_keyboardDidChagneFrameNotificationBlock;
- (void)setWb_keyboardDidChangeFrameNotificationBlock:(void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidChangeFrameNotificationBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_keyboardDidChagneFrameNotificationBlock, wb_keyboardDidChangeFrameNotificationBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wb_keyboardDidChangeFrameNotificationBlock) {
        [self initKeyboardManagerIfNeeded];
    }
}

- (void (^)(WBUIKeyboardUserInfo * _Nonnull))wb_keyboardDidChangeFrameNotificationBlock {
    return (void (^)(WBUIKeyboardUserInfo *))objc_getAssociatedObject(self, &kAssociatedObjectKey_keyboardDidChagneFrameNotificationBlock);
}

- (void)initKeyboardManagerIfNeeded {
    if (!self.wb_keyboardManager) {
        self.wb_keyboardManager = [[WBKeyboardManager alloc] initWithDelegate:self];
        [self.wb_keyboardManager addTargetResponder:self];
    }
}

// MARK: ------- WBUIKeyboardManagerDelegate
- (void)keyboardWillShowWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardWillShowNotificationBlock) {
        self.wb_keyboardWillShowNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardWillHideWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardWillHideNotificationBlock) {
        self.wb_keyboardWillHideNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardWillChangeFrameWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardWillChangeFrameNotificationBlock) {
        self.wb_keyboardWillChangeFrameNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardDidShowWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardDidShowNotificationBlock) {
        self.wb_keyboardDidShowNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardDidHideWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardDidHideNotificationBlock) {
        self.wb_keyboardDidHideNotificationBlock(keyboardUserInfo);
    }
}

- (void)keyboardDidChangeFrameWithUserInfo:(WBUIKeyboardUserInfo *)keyboardUserInfo {
    if (self.wb_keyboardDidChangeFrameNotificationBlock) {
        self.wb_keyboardDidChangeFrameNotificationBlock(keyboardUserInfo);
    }
}

@end
