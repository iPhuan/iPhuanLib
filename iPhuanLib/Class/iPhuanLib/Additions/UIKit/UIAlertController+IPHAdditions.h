//
//  UIAlertController+IPHAdditions.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/1/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 可以在pch文件中通过定义JSC_ALERTVIEW_CANCEL_TITLE来修改alertView为一个点击按钮时的按钮标题
#ifndef JSC_ALERTVIEW_CANCEL_TITLE
#define JSC_ALERTVIEW_CANCEL_TITLE  @"确定"
#endif

extern NSString *const IPHActionSheetShowErrorMessage;

// block中index的下标对应的action按钮顺序为`otherActions`，`destructiveAction`，`cancelAction`
typedef void(^IPHAlertActionHandler)(UIAlertAction *action, NSUInteger index);


@interface UIAlertController (IPHAlertView)

// 默认为一个显示为“确定”标题的按钮
+ (instancetype)iph_popupAlertViewInController:(UIViewController *)viewController
                                         title:(NSString *)title
                                       message:(NSString *)message;

+ (instancetype)iph_popupAlertViewInController:(UIViewController *)viewController
                                         title:(NSString *)title
                                       message:(NSString *)message
                             cancelActionTitle:(NSString *)cancelActionTitle;

+ (instancetype)iph_popupAlertViewInController:(UIViewController *)viewController
                                         title:(NSString *)title
                                       message:(NSString *)message
                                       handler:(IPHAlertActionHandler)handler
                             cancelActionTitle:(NSString *)cancelActionTitle
                             otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)iph_popupAlertViewInController:(UIViewController *)viewController
                                         title:(NSString *)title
                                       message:(NSString *)message
                                       handler:(IPHAlertActionHandler)handler
                        destructiveActionTitle:(NSString *)destructiveActionTitle
                             cancelActionTitle:(NSString *)cancelActionTitle
                             otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

// 初始化一个AlertView样式的UIAlertController对象，不弹出视图
+ (instancetype)iph_alertViewControllerWithTitle:(NSString *)title
                                         message:(NSString *)message
                                         handler:(IPHAlertActionHandler)handler
                          destructiveActionTitle:(NSString *)destructiveActionTitle
                               cancelActionTitle:(NSString *)cancelActionTitle
                               otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface UIAlertController (IPHActionSheet)

// 默认添加cancelActionTitle “取消”按钮
+ (instancetype)iph_showActionSheetInController:(UIViewController *)viewController
                                          title:(NSString *)title
                                        message:(NSString *)message
                                        handler:(IPHAlertActionHandler)handler
                              otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)iph_showActionSheetInController:(UIViewController *)viewController
                                          title:(NSString *)title
                                        message:(NSString *)message
                                        handler:(IPHAlertActionHandler)handler
                         destructiveActionTitle:(NSString *)destructiveActionTitle
                              cancelActionTitle:(NSString *)cancelActionTitle
                              otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

// 初始化一个ActionSheet样式的UIAlertController对象，不弹出视图
+ (instancetype)iph_actionSheetControllerWithTitle:(NSString *)title
                                           message:(NSString *)message
                                           handler:(IPHAlertActionHandler)handler
                                 cancelActionTitle:(NSString *)cancelActionTitle
                                 otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

// 初始化一个ActionSheet样式的UIAlertController对象，不弹出视图
+ (instancetype)iph_actionSheetControllerWithTitle:(NSString *)title
                                           message:(NSString *)message
                                           handler:(IPHAlertActionHandler)handler
                            destructiveActionTitle:(NSString *)destructiveActionTitle
                                 cancelActionTitle:(NSString *)cancelActionTitle
                                 otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface UIAlertController (IPHAdditions)

// 初始化一个UIAlertController对象，不弹出视图
+ (instancetype)iph_alertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                     handler:(IPHAlertActionHandler)handler
                      destructiveActionTitle:(NSString *)destructiveActionTitle
                           cancelActionTitle:(NSString *)cancelActionTitle
                           otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

// 建议不要调用该方法
+ (instancetype)iph_alertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                     handler:(IPHAlertActionHandler)handler
                      destructiveActionTitle:(NSString *)destructiveActionTitle
                           cancelActionTitle:(NSString *)cancelActionTitle
                            otherActionTitle:(NSString *)otherActionTitle
                                        args:(va_list)args;

@end



