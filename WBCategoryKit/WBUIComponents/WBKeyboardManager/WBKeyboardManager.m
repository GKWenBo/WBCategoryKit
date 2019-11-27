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

- (id)wb_findFirstResponder;

@end

@implementation UIView (WBKeyboardManager)

- (id)wb_findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView wb_findFirstResponder];
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

@property(nonatomic, assign) BOOL debug;

@end

static WBKeyboardManager *kKeyboardManagerInstance;

@implementation WBKeyboardManager

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

#pragma mark - Notification
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
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
