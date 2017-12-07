//
//  IPHCommonMacros.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/21.
//  Copyright © 2017年 iPhuan. All rights reserved.
//


#pragma mark - Geometry
/*****************************************************************************************/
#define IPHScreenWidth         [UIScreen mainScreen].bounds.size.width
#define IPHScreenHeight        [UIScreen mainScreen].bounds.size.height
#define IPHScreenBounds        [UIScreen mainScreen].bounds


#define IPHXSizeMultiple      (IPHScreenHeight/667.0)
#define IPHXFitSize(X)        ((X) * IPHXSizeMultiple)   // 以6为参考，5，6，6P，X等比缩放，适应于纵向布局

#define IPH6PSizeMultiple      (IPHScreenWidth <= 375?1.0:(IPHScreenWidth/375.0))
#define IPH6PFitSize(X)        ((X) * IPH6PSizeMultiple)  // 以6为参考，5和6保持一样的值，6P等比缩放

#define IPHRatioMultiple       (IPHScreenWidth/375.0)
#define IPHRatioFitSize(X)     ((X) * IPHRatioMultiple)  // 以6为参考，5和6P等比缩放

#define IPH5SizeMultiple       (IPHScreenWidth >= 375?1.0:(IPHScreenWidth/375.0))
#define IPH5FitSize(X)         ((X) * IPH5SizeMultiple)   // 以6为参考，6和6P保持一样的值，5等比缩放



#define IPHIsIPhoneX  CGSizeEqualToSize(CGSizeMake(1125, 2436), [UIScreen mainScreen].currentMode.size)

#define IPHTopOffset          (IPHIsIPhoneX ? 24 : 0)
#define IPHBottomOffset       (IPHIsIPhoneX ? 34 : 0)
#define IPHNavBarHeight       (IPHIsIPhoneX ? 88 : 64)
#define IPHStatusBarHeight    (IPHIsIPhoneX ? 44 : 20)
#define IPHTabBarHeight       (IPHIsIPhoneX ? 83 : 49)



#pragma mark - Conditional Judgment
/*****************************************************************************************/
#define IPHIsAvailableString(X)        ([X isKindOfClass:[NSString class]] && ![@"" isEqualToString:X])
#define IPHIsUnAvailableString(X)      (![X isKindOfClass:[NSString class]] || [@"" isEqualToString:X])
#define IPHUnNilString(X)              ([X isKindOfClass:[NSString class]]?X:@"")
#define IPHSetAvailableValueForString(string, value)   if (IPHIsUnAvailableString(string)) { \
string = value; \
}
#define IPHIsAtLeastiOSVersion(X)      ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)



#pragma mark - Color
/*****************************************************************************************/
#define IPHRGBColor(r,g,b)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define IPHRGBAColor(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define IPHHexColor(c)             [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f]



#pragma mark - Others
/*****************************************************************************************/
#define IPHImageNamed(name)                                [UIImage imageNamed:name]
#define IPH_OVERRIDE_WARN(baseClassName, subClassName)      { NSAssert(![baseClassName isEqualToString:subClassName], @"Subclass should override the method '%s'", __PRETTY_FUNCTION__);}



#pragma mark - Singleton
/*****************************************************************************************/
#define IPH_SINGLETON(_object_name_, _shared_obj_name_)     \
\
+ (_object_name_ *)_shared_obj_name_ {                      \
    static _object_name_ *z##_shared_obj_name_ = nil;       \
    static dispatch_once_t onceToken;                       \
    dispatch_once(&onceToken, ^{                            \
        z##_shared_obj_name_ = [[self alloc] init];         \
    });                                                     \
    return z##_shared_obj_name_;                            \
}





#pragma mark - Deprecated

#pragma mark - System Singleton // 建议在之后的开发过程中直接使用系统方法去获取单列而废弃宏的用法，以减少工程的耦合性
/*****************************************************************************************/
#define IPH_APPLICATION         [UIApplication sharedApplication]       // First deprecated in iPhuanLib 1.0.1
#define IPH_APP_WINDOW          IPH_APPLICATION.keyWindow               // First deprecated in iPhuanLib 1.0.1
#define IPH_NOTIOFICATION       [NSNotificationCenter defaultCenter]    // First deprecated in iPhuanLib 1.0.1
#define IPH_USER_DEFAULT        [NSUserDefaults standardUserDefaults]   // First deprecated in iPhuanLib 1.0.1
#define IPH_FILE_MANAGER        [NSFileManager defaultManager]          // First deprecated in iPhuanLib 1.0.1
#define IPH_BUNDLE              [NSBundle mainBundle]                   // First deprecated in iPhuanLib 1.0.1
#define IPH_DEVICE              [UIDevice currentDevice]                // First deprecated in iPhuanLib 1.0.1

#pragma mark - Geometry // 请使用IPH6SizeMultiple和IPH6FitSize()，符合设计规范
/*****************************************************************************************/
#define IPHSizeMultiple        (IPHScreenWidth/320.0)                   // First deprecated in iPhuanLib 1.0.1
#define IPHFitSize(X)          ((X) * IPHSizeMultiple)                  // First deprecated in iPhuanLib 1.0.1


#pragma mark - Deprecated
/*****************************************************************************************/
#define IPH6SizeMultiple       (IPHScreenWidth <= 375?1.0:(IPHScreenWidth/375.0))
#define IPH6FitSize(X)         ((X) * IPH6SizeMultiple)   // 请使用IPH6PFitSize

#define IPH6RatioMultiple      (IPHScreenWidth/375.0)
#define IPH6RatioFitSize(X)    ((X) * IPH6RatioMultiple)  // 请使用IPHRatioFitSize
