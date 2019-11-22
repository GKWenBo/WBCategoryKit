//
//  UITabBar+WBAdditional.m
//  Pods
//
//  Created by WenBo on 2019/11/21.
//

#import "UITabBar+WBAdditional.h"
#import <objc/runtime.h>

#import "WBCategoryKitCore.h"
#import "UITabBarItem+WBAdditional.h"
#import "UIBarItem+WBAdditional.h"
#import "WBUIViewController.h"
#import "WBUIImage.h"

static NSInteger const kLastTouchedTabBarItemIndexNone = -1;

@interface UITabBar ()

@property(nonatomic, assign) BOOL canItemRespondDoubleTouch;
@property(nonatomic, assign) NSInteger lastTouchedTabBarItemViewIndex;
@property(nonatomic, assign) NSInteger tabBarItemViewTouchCount;

#ifdef WB_IOS13_SDK_ALLOWED
@property(nonatomic, strong) UITabBarAppearance *wb_tabBarAppearance API_AVAILABLE(ios(13.0));
#endif

@end

@implementation UITabBar (WBAdditional)
// MARK:getter && setter
- (void)setCanItemRespondDoubleTouch:(BOOL)canItemRespondDoubleTouch {
    objc_setAssociatedObject(self, @selector(canItemRespondDoubleTouch), @(canItemRespondDoubleTouch), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canItemRespondDoubleTouch {
    return [objc_getAssociatedObject(self, @selector(canItemRespondDoubleTouch)) boolValue];
}

- (void)setLastTouchedTabBarItemViewIndex:(NSInteger)lastTouchedTabBarItemViewIndex {
    objc_setAssociatedObject(self, @selector(lastTouchedTabBarItemViewIndex), @(lastTouchedTabBarItemViewIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)lastTouchedTabBarItemViewIndex {
    return [objc_getAssociatedObject(self, @selector(lastTouchedTabBarItemViewIndex)) integerValue];
}

- (void)setTabBarItemViewTouchCount:(NSInteger)tabBarItemViewTouchCount {
    objc_setAssociatedObject(self, @selector(tabBarItemViewTouchCount), @(tabBarItemViewTouchCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)tabBarItemViewTouchCount {
    return [objc_getAssociatedObject(self, @selector(tabBarItemViewTouchCount)) integerValue];
}

// MARK: Configuration Property
#ifdef WB_IOS13_SDK_ALLOWED
- (UITabBarAppearance *)wb_tabBarAppearance {
    UITabBarAppearance *wb_tabBarAppearance = objc_getAssociatedObject(self, @selector(wb_tabBarAppearance));
    if (!wb_tabBarAppearance) {
        wb_tabBarAppearance = [[UITabBarAppearance alloc] init];
        [wb_tabBarAppearance configureWithDefaultBackground];
        objc_setAssociatedObject(self, @selector(wb_tabBarAppearance), wb_tabBarAppearance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return wb_tabBarAppearance;
}

- (void)updateTabBarAppearance {
    if (@available(iOS 13.0, *)) {
        UITabBar.appearance.standardAppearance = self.wb_tabBarAppearance;
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.standardAppearance = self.wb_tabBarAppearance;
        }];
    }
}
#endif

- (void)setWb_tabBarStyle:(UIBarStyle)wb_tabBarStyle {
    objc_setAssociatedObject(self, @selector(wb_tabBarStyle), @(wb_tabBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        self.wb_tabBarAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:wb_tabBarStyle == UIBarStyleDefault ? UIBlurEffectStyleSystemChromeMaterialLight : UIBlurEffectStyleSystemChromeMaterialDark];
        [self updateTabBarAppearance];
    } else {
#endif
        [UITabBar appearance].barStyle = wb_tabBarStyle;
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.barStyle = wb_tabBarStyle;
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIBarStyle)wb_tabBarStyle {
    return [objc_getAssociatedObject(self, @selector(wb_tabBarStyle)) integerValue];
}

- (void)setWb_tabBarBarTintColor:(UIColor *)wb_tabBarBarTintColor {
    objc_setAssociatedObject(self, @selector(wb_tabBarBarTintColor), wb_tabBarBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        self.wb_tabBarAppearance.backgroundColor = wb_tabBarBarTintColor;
        [self updateTabBarAppearance];
    } else {
#endif
        [UITabBar appearance].barTintColor = wb_tabBarBarTintColor;
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.barTintColor = wb_tabBarBarTintColor;
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIColor *)wb_tabBarBarTintColor {
    return objc_getAssociatedObject(self, @selector(wb_tabBarBarTintColor));
}

- (void)setWb_tabBarBackgroundImage:(UIImage *)wb_tabBarBackgroundImage {
    objc_setAssociatedObject(self, @selector(wb_tabBarBackgroundImage), wb_tabBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        self.wb_tabBarAppearance.backgroundImage = wb_tabBarBackgroundImage;
        [self updateTabBarAppearance];
    } else {
#endif
        [UITabBar appearance].backgroundImage = wb_tabBarBackgroundImage;
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.backgroundImage = wb_tabBarBackgroundImage;
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIImage *)wb_tabBarBackgroundImage {
    return objc_getAssociatedObject(self, @selector(wb_tabBarBackgroundImage));
}

- (void)setWb_tabBarShadowImageColor:(UIColor *)wb_tabBarShadowImageColor {
    objc_setAssociatedObject(self, @selector(wb_tabBarShadowImageColor), wb_tabBarShadowImageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        self.wb_tabBarAppearance.shadowColor = wb_tabBarShadowImageColor;
        [self updateTabBarAppearance];
    } else {
#endif
        UIImage *shadowImage = [UIImage wb_imageWithColor:wb_tabBarShadowImageColor
                                                     size:CGSizeMake(1, [WBHelper wb_pixelOne])
                                             cornerRadius:0];
        [[UITabBar appearance] setShadowImage:shadowImage];
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.shadowImage = shadowImage;
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIColor *)wb_tabBarShadowImageColor {
    return objc_getAssociatedObject(self, @selector(wb_tabBarShadowImageColor));
}

- (void)setWb_tabBarItemTitleFont:(UIFont *)wb_tabBarItemTitleFont {
    objc_setAssociatedObject(self, @selector(wb_tabBarItemTitleFont), wb_tabBarItemTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        [self.wb_tabBarAppearance wb_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
            attributes[NSFontAttributeName] = wb_tabBarItemTitleFont;
            itemAppearance.normal.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        if (wb_tabBarItemTitleFont) {
            textAttributes[NSFontAttributeName] = wb_tabBarItemTitleFont;
        }
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            }];
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIFont *)wb_tabBarItemTitleFont {
    return objc_getAssociatedObject(self, @selector(wb_tabBarItemTitleFont));
}

- (void)setWb_tabBarItemTitleColor:(UIColor *)wb_tabBarItemTitleColor {
    objc_setAssociatedObject(self, @selector(wb_tabBarItemTitleColor), wb_tabBarItemTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        [self.wb_tabBarAppearance wb_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
            attributes[NSForegroundColorAttributeName] = wb_tabBarItemTitleColor;
            itemAppearance.normal.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSForegroundColorAttributeName] = wb_tabBarItemTitleColor;
        [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            }];
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIColor *)wb_tabBarItemTitleColor {
    return objc_getAssociatedObject(self, @selector(wb_tabBarItemTitleColor));
}

- (void)setWb_tabBarItemTitleColorSelected:(UIColor *)wb_tabBarItemTitleColorSelected {
    objc_setAssociatedObject(self, @selector(wb_tabBarItemTitleColorSelected), wb_tabBarItemTitleColorSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        [self.wb_tabBarAppearance wb_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.selected.titleTextAttributes.mutableCopy;
            attributes[NSForegroundColorAttributeName] = wb_tabBarItemTitleColorSelected;
            itemAppearance.selected.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
    NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected]];
    textAttributes[NSForegroundColorAttributeName] = wb_tabBarItemTitleColorSelected;
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
        [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        }];
    }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIColor *)wb_tabBarItemTitleColorSelected {
    return objc_getAssociatedObject(self, @selector(wb_tabBarItemTitleColorSelected));
}

- (void)setWb_tabBarItemImageColor:(UIColor *)wb_tabBarItemImageColor {
    objc_setAssociatedObject(self, @selector(wb_tabBarItemImageColor), wb_tabBarItemImageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        [self.wb_tabBarAppearance wb_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            itemAppearance.normal.iconColor = wb_tabBarItemImageColor;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
    [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
        [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (item == tabBarController.tabBar.selectedItem) return;
            if (item.image.renderingMode == UIImageRenderingModeAlwaysOriginal) return;
            item.image = [item.image wb_imageWithTintColor:wb_tabBarItemImageColor];
        }];
    }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIColor *)wb_tabBarItemImageColor {
    return objc_getAssociatedObject(self, @selector(wb_tabBarItemImageColor));
}

- (void)setWb_tabBarItemImageColorSelected:(UIColor *)wb_tabBarItemImageColorSelected {
    objc_setAssociatedObject(self, @selector(wb_tabBarItemImageColorSelected), wb_tabBarItemImageColorSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#ifdef WB_IOS13_SDK_ALLOWED
    if (@available(iOS 13.0, *)) {
        [self.wb_tabBarAppearance wb_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            itemAppearance.selected.iconColor = wb_tabBarItemImageColorSelected;
        }];
        [self updateTabBarAppearance];
    } else {
#endif
        // iOS 12 及以下使用 tintColor 实现，tintColor 并没有声明 UI_APPEARANCE_SELECTOR，所以暂不使用 appearance 的方式去修改（虽然 appearance 方式实测是生效的）
        [[UIViewController wb_appearanceUpdatingTabBarControllers] enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.tintColor = wb_tabBarItemImageColorSelected;
        }];
#ifdef WB_IOS13_SDK_ALLOWED
    }
#endif
}

- (UIColor *)wb_tabBarItemImageColorSelected {
    return objc_getAssociatedObject(self, @selector(wb_tabBarItemImageColorSelected));
}

// MARK: Load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        WBOverrideImplementation([UITabBar class], @selector(setItems:animated:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^void(UITabBar *selfObject, NSArray<UITabBarItem *> *items, BOOL animated) {
                
                ///call super
                void (*originSelectorIMP)(id, SEL, NSArray<UITabBarItem *> *items, BOOL);
                originSelectorIMP = (void (*)(id, SEL, NSArray<UITabBarItem *> *items, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, items, animated);
                
                [items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
                    // 双击 tabBarItem 的功能需要在设置完 item 后才能获取到 qmui_view 来实现
                    UIControl *itemView = (UIControl *)item.wb_view;
                    [itemView addTarget:selfObject action:@selector(handleTabBarItemViewEvent:) forControlEvents:UIControlEventTouchUpInside];
                }];
                
            };
        });
        
        WBOverrideImplementation([UITabBar class], @selector(setSelectedItem:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UITabBar *selfObject, UITabBarItem *selectedItem) {
              NSInteger olderSelectedIndex = selfObject.selectedItem ? [selfObject.items indexOfObject:selfObject.selectedItem] : -1;
                
                // call super
                void (*originSelectorIMP)(id, SEL, UITabBarItem *);
                originSelectorIMP = (void (*)(id, SEL, UITabBarItem *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, selectedItem);
                
                NSInteger newerSelectedIndex = [selfObject.items indexOfObject:selectedItem];
                // 只有双击当前正在显示的界面的 tabBarItem，才能正常触发双击事件
                selfObject.canItemRespondDoubleTouch = olderSelectedIndex == newerSelectedIndex;
            };
        });
        
        WBOverrideImplementation([UITabBar class], @selector(setFrame:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UITabBar *selfObject, CGRect frame) {
                if (WB_IOS_SYSTEM_VERSION < 11.2 && WB_IS_58INCH_SCREEN) {
                    if (CGRectGetHeight(frame) == WB_TabBarHeight && CGRectGetMaxY(frame) < CGRectGetHeight(selfObject.superview.bounds)) {
                        // iOS 11 在界面 push 的过程中 tabBar 会瞬间往上跳，所以做这个修复。这个 bug 在 iOS 11.2 里已被系统修复。
                        // https://github.com/Tencent/QMUI_iOS/issues/217
                        frame = WBCGRectSetY(frame, CGRectGetHeight(selfObject.superview.bounds) - CGRectGetHeight(frame));
                    }
                }
                
                // 修复这个 bug：https://github.com/Tencent/QMUI_iOS/issues/309
                if (@available(iOS 11, *)) {
                    if (WB_IS_NOTCHED_SCREEN && ((CGRectGetHeight(frame) == 49 || CGRectGetHeight(frame) == 32))) {// 只关注全面屏设备下的这两种非正常的 tabBar 高度即可
                        CGFloat bottomSafeAreaInsets = selfObject.safeAreaInsets.bottom > 0 ? selfObject.safeAreaInsets.bottom : selfObject.superview.safeAreaInsets.bottom;// 注意，如果只是拿 selfObject.safeAreaInsets 判断，会肉眼看到高度的跳变，因此引入 superview 的值（虽然理论上 tabBar 不一定都会布局到 UITabBarController.view 的底部）
                        if (bottomSafeAreaInsets == CGRectGetHeight(selfObject.frame)) {
                            return;// 由于这个系统 bug https://github.com/Tencent/QMUI_iOS/issues/446，这里先暂时屏蔽本次 frame 变化
                        }
                        frame.size.height += bottomSafeAreaInsets;
                        frame.origin.y -= bottomSafeAreaInsets;
                    }
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, frame);
            };
        });
        
        ///以下代码修复两个仅存在于 12.1.0 版本的系统 bug，实测 12.1.1 苹果已经修复
        if (@available(iOS 12.1, *)) {
            WBOverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    // Fixed: UITabBar layout is broken on iOS 12.1
                    // https://github.com/Tencent/QMUI_iOS/issues/410
                    
                    if (WB_IOS_VERSION_NUMBER < 120101) {
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }
                    
                    if (WB_IOS_VERSION_NUMBER < 120101) {
                        // Fixed: iOS 12.1 UITabBarItem positioning issue during swipe back gesture (when UINavigationBar is hidden)
                        // https://github.com/Tencent/QMUI_iOS/issues/422
                        if (WB_IS_NOTCHED_SCREEN) {
                            if ((CGRectGetHeight(selfObject.frame) == 48 && CGRectGetHeight(firstArgv) == 33) || (CGRectGetHeight(selfObject.frame) == 31 && CGRectGetHeight(firstArgv) == 20)) {
                                return;
                            }
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
        
        /// iOS 13 下如果以 UITabBarAppearance 的方式将 UITabBarItem 的 font 大小设置为超过默认的 10，则会出现布局错误，文字被截断，所以这里做了个兼容
        /// https://github.com/Tencent/QMUI_iOS/issues/740
        if (@available(iOS 13.0, *)) {
            WBOverrideImplementation(NSClassFromString(@"UITabBarButtonLabel"), @selector(setAttributedText:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
                return ^(UILabel *selfObject, NSAttributedString *firstArgv) {
                    // call super
                    void (*originSelectorIMP)(id, SEL, NSAttributedString *);
                    originSelectorIMP = (void (*)(id, SEL, NSAttributedString *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                    
                    CGFloat fontSize = selfObject.font.pointSize;
                    if (fontSize > 10) {
                        [selfObject sizeToFit];
                    }
                };
            });
        }
        
        /// 以下是将 iOS 12 修改 UITabBar 样式的接口转换成用 iOS 13 的新接口去设置（因为新旧方法是互斥的，所以统一在新系统都用新方法）
#ifdef WB_IOS13_SDK_ALLOWED
        if (@available(iOS 13.0, *)) {
            void (^syncAppearance)(UITabBar *, void(^barActionBlock)(UITabBarAppearance *appearance), void (^itemActionBlock)(UITabBarItemAppearance *itemAppearance)) = ^void(UITabBar *tabBar, void(^barActionBlock)(UITabBarAppearance *appearance), void (^itemActionBlock)(UITabBarItemAppearance *itemAppearance)) {
                if (!barActionBlock && !itemActionBlock) return;
                
                UITabBarAppearance *appearance = tabBar.standardAppearance;
                if (barActionBlock) {
                    barActionBlock(appearance);
                }
                if (itemActionBlock) {
                    [appearance wb_applyItemAppearanceWithBlock:itemActionBlock];
                }
                tabBar.standardAppearance = appearance;
            };
            
            WBExtendImplementationOfVoidMethodWithSingleArgument([UITabBar class], @selector(setTintColor:), UIColor *, ^(UITabBar *selfObject, UIColor *tintColor) {
                syncAppearance(selfObject, nil, ^void(UITabBarItemAppearance *itemAppearance) {
                    itemAppearance.selected.iconColor = tintColor;
                    
                    NSMutableDictionary<NSAttributedStringKey, id> *textAttributes = itemAppearance.selected.titleTextAttributes.mutableCopy;
                    textAttributes[NSForegroundColorAttributeName] = tintColor;
                    itemAppearance.selected.titleTextAttributes = textAttributes.copy;
                });
            });
            
            WBExtendImplementationOfVoidMethodWithSingleArgument([UITabBar class], @selector(setBarTintColor:), UIColor *, ^(UITabBar *selfObject, UIColor *barTintColor) {
                syncAppearance(selfObject, ^void(UITabBarAppearance *appearance) {
                    appearance.backgroundColor = barTintColor;
                }, nil);
            });
            
            WBExtendImplementationOfVoidMethodWithSingleArgument([UITabBar class], @selector(setUnselectedItemTintColor:), UIColor *, ^(UITabBar *selfObject, UIColor *tintColor) {
                syncAppearance(selfObject, nil, ^void(UITabBarItemAppearance *itemAppearance) {
                    itemAppearance.normal.iconColor = tintColor;
                    
                    NSMutableDictionary *textAttributes = itemAppearance.selected.titleTextAttributes.mutableCopy;
                    textAttributes[NSForegroundColorAttributeName] = tintColor;
                    itemAppearance.normal.titleTextAttributes = textAttributes.copy;
                });
            });
            
            WBExtendImplementationOfVoidMethodWithSingleArgument([UITabBar class], @selector(setBackgroundImage:), UIImage *, ^(UITabBar *selfObject, UIImage *image) {
                syncAppearance(selfObject, ^void(UITabBarAppearance *appearance) {
                    appearance.backgroundImage = image;
                }, nil);
            });
            
            WBExtendImplementationOfVoidMethodWithSingleArgument([UITabBar class], @selector(setShadowImage:), UIImage *, ^(UITabBar *selfObject, UIImage *shadowImage) {
                syncAppearance(selfObject, ^void(UITabBarAppearance *appearance) {
                    appearance.shadowImage = shadowImage;
                }, nil);
            });
            
            WBExtendImplementationOfVoidMethodWithSingleArgument([UITabBar class], @selector(setBarStyle:), UIBarStyle, ^(UITabBar *selfObject, UIBarStyle barStyle) {
                syncAppearance(selfObject, ^void(UITabBarAppearance *appearance) {
                    appearance.backgroundEffect = [UIBlurEffect effectWithStyle:barStyle == UIBarStyleDefault ? UIBlurEffectStyleSystemMaterialLight : UIBlurEffectStyleSystemMaterialDark];
                }, nil);
            });
        }
#endif
    });
}

- (UIView *)wb_backgroundView {
    return [self wb_valueForKey:@"_backgroundView"];
}

- (UIImageView *)wb_shadowImageView {
    if (@available(iOS 13, *)) {
        return [self.wb_backgroundView wb_valueForKey:@"_shadowView1"];
    } else if (@available(iOS 10, *)) {
        // iOS 10 及以后，在 UITabBar 初始化之后就能获取到 backgroundView 和 shadowView 了
        return [self.wb_backgroundView wb_valueForKey:@"_shadowView"];
    }
    // iOS 9 及以前，shadowView 要在 UITabBar 第一次 layoutSubviews 之后才会被创建，直至 UITabBarController viewWillAppear: 时仍未能获取到 shadowView，所以为了省去调用时机的考虑，这里获取不到的时候会主动触发一次 tabBar 的布局
    UIImageView *shadowView = [self wb_valueForKey:@"_shadowView"];
    if (!shadowView) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        shadowView = [self wb_valueForKey:@"_shadowView"];
    }
    return shadowView;
}

// MARK:Event Response
- (void)handleTabBarItemViewEvent:(UIControl *)itemView {
    if (!self.canItemRespondDoubleTouch) {
        return;
    }
    
    if (!self.selectedItem.wb_tabbarItemDoubleTapBlock) {
        return;
    }
    
    // 如果一定时间后仍未触发双击，则废弃当前的点击状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self revertTabBarItemTouch];
    });
    
    NSInteger selectedIndex = [self.items indexOfObject:self.selectedItem];
    
    if (self.lastTouchedTabBarItemViewIndex == kLastTouchedTabBarItemIndexNone) {
        // 记录第一次点击的 index
        self.lastTouchedTabBarItemViewIndex = selectedIndex;
    } else if (self.lastTouchedTabBarItemViewIndex != selectedIndex) {
        // 后续的点击如果与第一次点击的 index 不一致，则认为是重新开始一次新的点击
        [self revertTabBarItemTouch];
        self.lastTouchedTabBarItemViewIndex = selectedIndex;
        return;
    }
    
    self.tabBarItemViewTouchCount ++;
    if (self.tabBarItemViewTouchCount == 2) {
        // 第二次点击了相同的 tabBarItem，触发双击事件
        UITabBarItem *item = self.items[selectedIndex];
        if (item.wb_tabbarItemDoubleTapBlock) {
            item.wb_tabbarItemDoubleTapBlock(item, selectedIndex);
        }
        [self revertTabBarItemTouch];
    }
}

- (void)revertTabBarItemTouch {
    self.lastTouchedTabBarItemViewIndex = kLastTouchedTabBarItemIndexNone;
    self.tabBarItemViewTouchCount = 0;
}

@end


#ifdef WB_IOS13_SDK_ALLOWED

@implementation UITabBarAppearance (WBAdditional)

- (void)wb_applyItemAppearanceWithBlock:(void (^)(UITabBarItemAppearance * _Nonnull))block {
    block(self.stackedLayoutAppearance);
    block(self.inlineLayoutAppearance);
    block(self.compactInlineLayoutAppearance);
}

@end

#endif


