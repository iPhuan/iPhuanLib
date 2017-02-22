//
//  IPHCommonMacros.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/21.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#pragma mark - System Singleton
/*****************************************************************************************/
#define IPH_APPLICATION         [UIApplication sharedApplication]
#define IPH_APP_WINDOW          IPH_APPLICATION.keyWindow
#define IPH_NOTIOFICATION       [NSNotificationCenter defaultCenter]
#define IPH_USER_DEFAULT        [NSUserDefaults standardUserDefaults]
#define IPH_FILE_MANAGER        [NSFileManager defaultManager]
#define IPH_DEVICE              [UIDevice currentDevice]


#pragma mark - Geometry
/*****************************************************************************************/
#define IPHScreenWidth         [UIScreen mainScreen].bounds.size.width
#define IPHScreenHeight        [UIScreen mainScreen].bounds.size.height
#define IPHScreenBounds        [UIScreen mainScreen].bounds.size.height
#define IPHSizeMultiple        (IPHScreenWidth/320.0)
#define IPHFitSize(X)          ((X) * IPHSizeMultiple)


#pragma mark - Conditional Judgment
/*****************************************************************************************/
#define IPHIsAvailableString(X)        (X && ![@"" isEqualToString:X])
#define IPHIsUnAvailableString(X)      (!X || [@"" isEqualToString:X])
#define IPHUnNilString(X)              X?:@""
#define IPHIsAtLeastiOSVersion(X)      ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)


#pragma mark - Color
/*****************************************************************************************/
#define IPHRGBColor(r,g,b)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define IPHRGBAColor(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define IPHHexColor(c)             [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f]


#pragma mark - Others
/*****************************************************************************************/
#define IPHImageNamed(name)                                [UIImage imageNamed:name]
#define IPH_OVERRIDE_WARN(baseClassName, subClassName)      { NSAssert([baseClassName isEqualToString:subClassName], @"Subclass should override the method!");}



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
