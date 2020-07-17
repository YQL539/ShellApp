//
//  Constant.h
//  ShellApp
//
//  Created by qinglong yang on 2020/7/17.
//  Copyright © 2020 yql. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define IS_IOS_(NUM) ([[[UIDevice currentDevice] systemVersion] floatValue] >= NUM ? YES : NO)

//屏幕宽高
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
//VIEW宽高
#define VIEWWIDTH (self.view.frame.size.width)
#define VIEWNHEIGHT (self.view.frame.size.height)
//判断iphone ipad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//判断型号尺寸
// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone5系列
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone6系列
#define IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define IS_IPHONE_6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//X系列
#define IS_IPHONE_X_BACK (IS_IPHONE_X && IS_IPHONE_Xr && IS_IPHONE_Xs && IS_IPHONE_Xs_Max)

//showModeHeight
#define kPVLShowModeHeight       ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 24.f : 0.f)
// 状态栏高度
#define STATUS_BAR_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34.f : 0.f)

//适配尺寸
#define GetWidthNum(inch) [CommonUtil getWidthSwitchInch:inch]
#define GetHeightNum(inch) [CommonUtil getHeightSwitchInch:inch]


#define RGB(_r,_g,_b)            [UIColor colorWithRed:_r/255.0 green:_g/255.0 blue:_b/255.0 alpha:1.0]
#define    RGBA(__r,__g,__b,__a)    [UIColor colorWithRed:(__r)/255.0 green:(__g)/255.0 blue:(__b)/255.0 alpha:(__a)/255.0]

//去警告，LeakWarning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* Constant_h */
