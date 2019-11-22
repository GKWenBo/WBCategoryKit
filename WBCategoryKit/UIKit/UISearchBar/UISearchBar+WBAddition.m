//
//  UISearchBar+WBAddition.m
//  JulyGame
//
//  Created by Admin on 2018/2/7.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UISearchBar+WBAddition.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"
#import "WBUIImage.h"
#import "WBCategoryKitCore.h"
#import "WBUIView.h"

@implementation UISearchBar (WBAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        WBExtendImplementationOfVoidMethodWithTwoArguments([UISearchBar class], @selector(setShowsCancelButton:animated:), BOOL, BOOL, ^(UISearchBar *selfObject, BOOL firstArgv, BOOL secondArgv) {
            if (selfObject.wb_cancelButton && selfObject.wb_cancelButtonFont) {
                selfObject.wb_cancelButton.titleLabel.font = selfObject.wb_cancelButtonFont;
            }
        });
            
        WBExtendImplementationOfVoidMethodWithSingleArgument([UISearchBar class], @selector(setPlaceholder:), NSString *, (^(UISearchBar *selfObject, NSString *placeholder) {
            if (selfObject.wb_placeholderColor || selfObject.wb_font) {
                NSMutableDictionary<NSString *, id> *attributes = [[NSMutableDictionary alloc] init];
                if (selfObject.wb_placeholderColor) {
                    attributes[NSForegroundColorAttributeName] = selfObject.wb_placeholderColor;
                }
                if (selfObject.wb_font) {
                    attributes[NSFontAttributeName] = selfObject.wb_font;
                }
                selfObject.wb_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
            }
        }));
        
        if (@available(iOS 13.0, *)) {
            // -[_UISearchBarLayout applyLayout] 是 iOS 13 系统新增的方法，该方法可能会在 -[UISearchBar layoutSubviews] 后调用，作进一步的布局调整。
            Class _UISearchBarLayoutClass = NSClassFromString([NSString stringWithFormat:@"_%@%@",@"UISearchBar", @"Layout"]);
            WBOverrideImplementation(_UISearchBarLayoutClass, NSSelectorFromString(@"applyLayout"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UIView *selfObject) {
                    
                    // call super
                    void (^callSuperBlock)(void) = ^{
                        void (*originSelectorIMP)(id, SEL);
                        originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                        originSelectorIMP(selfObject, originCMD);
                    };

                    UISearchBar *searchBar = (UISearchBar *)((UIView *)[selfObject wb_valueForKey:[NSString stringWithFormat:@"_%@",@"searchBarBackground"]]).superview.superview;
                    
                    NSAssert(searchBar == nil || [searchBar isKindOfClass:[UISearchBar class]], @"not a searchBar");

                    if (searchBar && searchBar.wb_searchController.isBeingDismissed && searchBar.wb_usedAsTableHeaderView) {
                        CGRect previousRect = searchBar.wb_backgroundView.frame;
                        callSuperBlock();
                        // applyLayout 方法中会修改 _searchBarBackground  的 frame ，从而覆盖掉 wb_usedAsTableHeaderView 做出的调整，所以这里还原本次修改。
                        searchBar.wb_backgroundView.frame = previousRect;
                    } else {
                        callSuperBlock();
                    }
                };
            });
            
            // iOS 13 后，cancelButton 的 frame 由 -[_UISearchBarSearchContainerView layoutSubviews] 去修改
            Class _UISearchBarSearchContainerViewClass = NSClassFromString([NSString stringWithFormat:@"_%@%@",@"UISearchBarSearch", @"ContainerView"]);
            WBExtendImplementationOfVoidMethodWithoutArguments(_UISearchBarSearchContainerViewClass, @selector(layoutSubviews), ^(UIView *selfObject) {
                UISearchBar *searchBar = (UISearchBar *)selfObject.superview.superview;
                NSAssert(searchBar == nil || [searchBar isKindOfClass:[UISearchBar class]], @"not a searchBar");
                [searchBar wb_adjustCancelButtonFrameIfNeeded];
            });
        }
            
            Class UISearchBarTextFieldClass = NSClassFromString([NSString stringWithFormat:@"%@%@",@"UISearchBarText", @"Field"]);
            WBOverrideImplementation(UISearchBarTextFieldClass, @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UITextField *textField, CGRect frame) {
                    
                    UISearchBar *searchBar = nil;
                    if (@available(iOS 13.0, *)) {
                        searchBar = (UISearchBar *)textField.superview.superview.superview;
                    } else {
                        searchBar = (UISearchBar *)textField.superview.superview;
                    }
                    
                    NSAssert(searchBar == nil || [searchBar isKindOfClass:[UISearchBar class]], @"not a searchBar");
                    
                    if (searchBar) {
                        frame = [searchBar wb_adjustedSearchTextFieldFrameByOriginalFrame:frame];
                    }
                    
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                    originSelectorIMP(textField, originCMD, frame);
                    
                    [searchBar wb_searchTextFieldFrameDidChange];
                };
            });
            
            
            WBExtendImplementationOfVoidMethodWithoutArguments([UISearchBar class], @selector(layoutSubviews), ^(UISearchBar *selfObject) {
                // 修复 iOS 13 backgroundView 没有撑开到顶部的问题
                if (WB_IOS_SYSTEM_VERSION >= 13.0 && selfObject.wb_usedAsTableHeaderView && selfObject.wb_isActive) {
                    selfObject.wb_backgroundView.wb_height = WB_StatusBarHeightConstant + selfObject.wb_height;
                    selfObject.wb_backgroundView.wb_top = -WB_StatusBarHeightConstant;
                }
                [selfObject wb_adjustCancelButtonFrameIfNeeded];
                [selfObject wb_fixDismissingAnimationIfNeeded];
                [selfObject wb_fixSearchResultsScrollViewContentInsetIfNeeded];
                
            });
            
            WBOverrideImplementation([UISearchBar class], @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UISearchBar *selfObject, CGRect frame) {
                    
                    frame = [selfObject wb_adjustedSearchBarFrameByOriginalFrame:frame];
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, frame);
                    
                };
            });
    });
}

// MARK: getter && setter
static char kWBAssociatedObjectKey_usedAsTableHeaderView;
- (void)setWb_usedAsTableHeaderView:(BOOL)wb_usedAsTableHeaderView {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_usedAsTableHeaderView, @(wb_usedAsTableHeaderView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wb_usedAsTableHeaderView {
    return [objc_getAssociatedObject(self, &kWBAssociatedObjectKey_usedAsTableHeaderView) boolValue];
}

static char kWBAssociatedObjectKey_textFieldMargins;
- (void)setWb_textFieldMargins:(UIEdgeInsets)wb_textFieldMargins {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_textFieldMargins, [NSNumber valueWithUIEdgeInsets:wb_textFieldMargins], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)wb_textFieldMargins {
    return [objc_getAssociatedObject(self, &kWBAssociatedObjectKey_textFieldMargins) UIEdgeInsetsValue];
}

static char kWBAssociatedObjectKey_PlaceholderColor;
- (void)setWb_placeholderColor:(UIColor *)wb_placeholderColor {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_PlaceholderColor, wb_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) {
        // 触发 setPlaceholder 里更新 placeholder 样式的逻辑
        self.placeholder = self.placeholder;
    }
}

- (UIColor *)wb_placeholderColor {
    return objc_getAssociatedObject(self, &kWBAssociatedObjectKey_PlaceholderColor);
}

static char kWBAssociatedObjectKey_TextColor;
- (void)setWb_textColor:(UIColor *)wb_textColor {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_TextColor, wb_textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.wb_textField.textColor = wb_textColor;
}

- (UIColor *)wb_textColor {
    return objc_getAssociatedObject(self, &kWBAssociatedObjectKey_TextColor);
}

static char kWBAssociatedObjectKey_font;
- (void)setWb_font:(UIFont *)wb_font {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_font, wb_font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) {
        // 触发 setPlaceholder 里更新 placeholder 样式的逻辑
        self.placeholder = self.placeholder;
    }
    self.wb_textField.font = wb_font;
}

- (UIFont *)wb_font {
    return objc_getAssociatedObject(self, &kWBAssociatedObjectKey_font);
}

- (UITextField *)wb_textField {
    UITextField *textField = [self wb_valueForKey:@"searchField"];
    return textField;
}

- (UIButton *)wb_cancelButton {
    UIButton *button = [self wb_valueForKey:@"cancelButton"];
    return button;
}

static char kWBAssociatedObjectKey_cancelButtonFont;
- (void)setWb_cancelButtonFont:(UIFont *)wb_cancelButtonFont {
    objc_setAssociatedObject(self, &kWBAssociatedObjectKey_cancelButtonFont, wb_cancelButtonFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.wb_cancelButton.titleLabel.font = wb_cancelButtonFont;
}

- (UIFont *)wb_cancelButtonFont {
    return objc_getAssociatedObject(self, &kWBAssociatedObjectKey_cancelButtonFont);
}

- (UISegmentedControl *)wb_segmentedControl {
    UISegmentedControl *segmentedControl = [self wb_valueForKey:@"scopeBar"];
    return segmentedControl;
}

- (BOOL)wb_isActive {
    return (self.wb_searchController.isBeingPresented || self.wb_searchController.isActive);
}

- (UISearchController *)wb_searchController {
    return [self wb_valueForKey:@"_searchController"];
}

- (UIView *)wb_backgroundView {
    WB_SUPPRESS_PerformSelectorLeak_WARNING(UIView *backgroundView = [self performSelector:NSSelectorFromString(@"_backgroundView")]; return backgroundView);
}


+ (nullable UIImage *)wb_generateTextFieldBackgroundImageWithColor:(nullable UIColor *)color {
    return [[UIImage wb_imageWithColor:color
                                  size:self.wb_textFieldDefaultSize
                          cornerRadius:0] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}


+ (nullable UIImage *)wb_generateBackgroundImageWithColor:(nullable UIColor *)backgroundColor
                                              borderColor:(nullable UIColor *)borderColor {
    UIImage *backgroundImage = nil;
    if (backgroundColor || borderColor) {
        backgroundImage = [UIImage wb_imageWithColor:backgroundColor ?: [UIColor whiteColor]
                                                size:CGSizeMake(10, 10)
                                        cornerRadius:0];
        if (borderColor) {
            backgroundImage = [backgroundImage wb_imageWithBorderColor:borderColor
                                                           borderWidth:[WBHelper wb_pixelOne]
                                                        borderPosition:WBUIImageBorderPositionBottom];
        }
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    }
    return backgroundImage;
}

#pragma mark - Layout Fix
- (BOOL)wb_shouldFixLayoutWhenUsedAsTableHeaderView {
    if (@available(iOS 11, *)) {
        return self.wb_usedAsTableHeaderView && self.wb_searchController.hidesNavigationBarDuringPresentation;
    }
    return NO;
}

static CGSize textFieldDefaultSize;
+ (CGSize)wb_textFieldDefaultSize {
    if (WBCGSizeIsEmpty(textFieldDefaultSize)) {
        textFieldDefaultSize = CGSizeMake(60, 28);
        // 在 iOS 11 及以上，搜索输入框系统默认高度是 36，iOS 10 及以下的高度是 28
        if (@available(iOS 11.0, *)) {
            textFieldDefaultSize.height = 36;
        }
    }
    return textFieldDefaultSize;
}

- (void)wb_adjustCancelButtonFrameIfNeeded  {
    if (!self.wb_shouldFixLayoutWhenUsedAsTableHeaderView) return;
    if ([self wb_isActive]) {
        CGRect textFieldFrame = self.wb_textField.frame;
        self.wb_cancelButton.wb_top = WBCGRectGetMinYVerticallyCenter(textFieldFrame, self.wb_cancelButton.frame);
        if (self.wb_segmentedControl.superview.wb_top < self.wb_textField.wb_bottom) {
            // scopeBar 显示在搜索框右边
            self.wb_segmentedControl.superview.wb_top = WBCGRectGetMinYVerticallyCenter(textFieldFrame, self.wb_segmentedControl.superview.frame);
        }
    }
}

- (CGRect)wb_adjustedSearchTextFieldFrameByOriginalFrame:(CGRect)frame {
    if (self.wb_shouldFixLayoutWhenUsedAsTableHeaderView) {
        if (self.wb_searchController.isBeingPresented) {
            BOOL statusBarHidden = NO;
            if (@available(iOS 13.0, *)) {
                statusBarHidden = self.window.windowScene.statusBarManager.statusBarHidden;
            } else {
                statusBarHidden = UIApplication.sharedApplication.statusBarHidden;
            }
            CGFloat visibleHeight = statusBarHidden ? 56 : 50;
            frame.origin.y = (visibleHeight - self.wb_textField.wb_height) / 2;
        } else if (self.wb_searchController.isBeingDismissed) {
            frame.origin.y = (56 - self.wb_textField.wb_height) / 2;
        }
    }
    
    // apply wb_textFieldMargins
    if (!UIEdgeInsetsEqualToEdgeInsets(self.wb_textFieldMargins, UIEdgeInsetsZero)) {
        frame = WBCGRectInsetEdges(frame, self.wb_textFieldMargins);
    }
    return frame;
}

- (void)wb_searchTextFieldFrameDidChange {
    // apply SearchBarTextFieldCornerRadius
    CGFloat textFieldCornerRadius = CGRectGetHeight(self.wb_textField.frame) / 2.0;;
    self.wb_textField.layer.cornerRadius = textFieldCornerRadius;
    self.wb_textField.clipsToBounds = textFieldCornerRadius != 0;
    
    [self wb_adjustCancelButtonFrameIfNeeded];
}

- (void)wb_fixDismissingAnimationIfNeeded {
    if (!self.wb_shouldFixLayoutWhenUsedAsTableHeaderView) return;
    
    if (self.wb_searchController.isBeingDismissed) {
        
        if (WB_IS_NOTCHED_SCREEN && self.frame.origin.y == 43) {
            // 修复刘海屏下，系统计算少了一个 pt
            self.frame = WBCGRectSetY(self.frame, WB_StatusBarHeightConstant);
        }
        
        UIView *searchBarContainerView = self.superview;
        // 每次激活搜索框，searchBarContainerView 都会重新创建一个
        if (searchBarContainerView.layer.masksToBounds == YES) {
            searchBarContainerView.layer.masksToBounds = NO;
            // backgroundView 被 searchBarContainerView masksToBounds 裁减掉的底部。
            CGFloat backgroundViewBottomClipped = CGRectGetMaxY([searchBarContainerView convertRect:self.wb_backgroundView.frame fromView:self.wb_backgroundView.superview]) - CGRectGetHeight(searchBarContainerView.bounds);
            // UISeachbar 取消激活时，如果 BackgroundView 底部超出了 searchBarContainerView，需要以动画的形式来过渡：
            if (backgroundViewBottomClipped > 0) {
                CGFloat previousHeight = self.wb_backgroundView.wb_height;
                [UIView performWithoutAnimation:^{
                    // 先减去 backgroundViewBottomClipped 使得 backgroundView 和 searchBarContainerView 底部对齐，由于这个时机是包裹在 animationBlock 里的，所以要包裹在 performWithoutAnimation 中来设置
                    self.wb_backgroundView.wb_height -= backgroundViewBottomClipped;
                }];
                // 再还原高度，这里在 animationBlock 中，所以会以动画来过渡这个效果
                self.wb_backgroundView.wb_height = previousHeight;
                
                // 以下代码为了保持原有的顶部的 mask，否则在 NavigationBar 为透明或者磨砂时，会看到 backgroundView
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathAddRect(path, NULL, CGRectMake(0, 0, searchBarContainerView.wb_width, previousHeight));
                maskLayer.path = path;
                searchBarContainerView.layer.mask = maskLayer;
            }
        }
    }
}

- (void)wb_fixSearchResultsScrollViewContentInsetIfNeeded {
    if (!self.wb_shouldFixLayoutWhenUsedAsTableHeaderView) return;
    if (self.wb_isActive) {
        UIViewController *searchResultsController = self.wb_searchController.searchResultsController;
        if (searchResultsController && [searchResultsController isViewLoaded]) {
            UIView *view = searchResultsController.view;
            UIScrollView *scrollView =
            [view isKindOfClass:UIScrollView.class] ? view :
            [view.subviews.firstObject isKindOfClass:UIScrollView.class] ? view.subviews.firstObject : nil;
            UIView *searchBarContainerView = self.superview;
            if (scrollView && searchBarContainerView) {
                scrollView.contentInset = UIEdgeInsetsMake(searchBarContainerView.wb_height, 0, 0, 0);
            }
        }
    }
}

- (CGRect)wb_adjustedSearchBarFrameByOriginalFrame:(CGRect)frame {
    if (!self.wb_shouldFixLayoutWhenUsedAsTableHeaderView) return frame;
    
    // 重写 setFrame: 是为了这个 issue：https://github.com/Tencent/QMUI_iOS/issues/233
    // iOS 11 下用 tableHeaderView 的方式使用 searchBar 的话，进入搜索状态时 y 偏上了，导致间距错乱
    // iOS 13 iPad 在退出动画时 y 值可能为负，需要修正
    
    if (self.wb_searchController.isBeingDismissed && CGRectGetMinY(frame) < 0) {
        frame = WBCGRectSetY(frame, 0);
    }
    
    if (![self wb_isActive]) {
        return frame;
    }
    
    if (WB_IS_NOTCHED_SCREEN) {
        // 竖屏
        if (CGRectGetMinY(frame) == 38) {
            // searching
            frame = WBCGRectSetY(frame, 44);
        }
        
        // 全面屏 iPad
        if (CGRectGetMinY(frame) == 18) {
            // searching
            frame = WBCGRectSetY(frame, 24);
        }
        
        // 横屏
        if (CGRectGetMinY(frame) == -6) {
            frame = WBCGRectSetY(frame, 0);
        }
    } else {
        
        // 竖屏
        if (CGRectGetMinY(frame) == 14) {
            frame = WBCGRectSetY(frame, 20);
        }
        
        // 横屏
        if (CGRectGetMinY(frame) == -6) {
            frame = WBCGRectSetY(frame, 0);
        }
    }
    // 强制在激活状态下 高度也为 56，方便后续做平滑过渡动画 (iOS 11 默认下，非刘海屏的机器激活后为 50，刘海屏激活后为 55)
    if (frame.size.height != 56) {
        frame.size.height = 56;
    }
    return frame;
}

@end
