//
//  WBKeyboardManager.m
//  Pods
//
//  Created by 文波 on 2019/11/26.
//

#import "WBKeyboardManager.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"

@interface WBKeyboardManager ()

@property(nonatomic, strong) NSMutableArray <NSValue *> *targetResponderValues;

@property(nonatomic, strong) WBUIKeyboardUserInfo *lastUserInfo;
@property(nonatomic, assign) CGRect keyboardMoveBeginRect;

@property(nonatomic, weak) UIResponder *currentResponder;
//@property(nonatomic, weak) UIResponder *currentResponderWhenResign;

@property(nonatomic, assign) BOOL debug;

@end

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

@implementation WBKeyboardManager


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
