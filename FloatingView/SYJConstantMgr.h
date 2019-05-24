//
//  SYJConstantMgr.h
//  HelloWord
//
//  Created by syj on 2019/1/22.
//  Copyright © 2019 syj. All rights reserved.
//

#ifndef SYJConstantMgr_h
#define SYJConstantMgr_h

/*------------------------公共部分定义---开始--------------------*/

#define s_ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define s_ScreenHeight    [UIScreen mainScreen].bounds.size.height

#define s_IOS7    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)
#define s_IOS8    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
#define s_IOS10    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=10.0)
#define s_IOS11    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=11.0)
#define s_IOS12    ([[[UIDevice currentDevice] systemVersion] doubleValue]>=12.0)


#define s_iPhoneXS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define s_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define s_iPhoneX_All (s_iPhoneX || s_iPhoneXR || s_iPhoneXS_Max)
#define s_iPhoneHasLiuHai ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? YES : NO)


#define s_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define s_NavBarHeight 44.0
#define s_TabBarHeight (s_StatusBarHeight > 20 ? 83:49)
#define s_TopHeight (s_StatusBarHeight + s_NavBarHeight)

#define s_Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define s_ColorAlpha(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])


#define s_NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)


#define s__WEAK_SELF     __weak typeof(self) weakSelf = self;
#define s__STRONG_SELF   __strong typeof(weakSelf) strongSelf = weakSelf;

typedef void(^SyjHandleBlock)(void);




#endif /* SYJConstantMgr_h */


