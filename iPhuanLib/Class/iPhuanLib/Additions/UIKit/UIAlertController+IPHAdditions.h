//
//  UIAlertController+IPHAdditions.h
//
//
//  Created by iPhuan on 2017/1/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^IPHAlertActionHandeler)(UIAlertAction *action, NSUInteger index);


@interface UIAlertController (IPHAlertView)

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message;

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message
                                    cancelActionTitle:(NSString *)cancelActionTitle;

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message
                                              handler:(IPHAlertActionHandeler)handler
                                    cancelActionTitle:(NSString *)cancelActionTitle
                                    otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message
                                              handler:(IPHAlertActionHandeler)handler
                               destructiveActionTitle:(NSString *)destructiveActionTitle
                                    cancelActionTitle:(NSString *)cancelActionTitle
                                    otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertController *)iph_alertViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                handler:(IPHAlertActionHandeler)handler
                                 destructiveActionTitle:(NSString *)destructiveActionTitle
                                      cancelActionTitle:(NSString *)cancelActionTitle
                                      otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface UIAlertController (IPHActionSheet)

+ (UIAlertController *)iph_showActionSheetInController:(UIViewController *)viewController
                                                 title:(NSString *)title
                                               message:(NSString *)message
                                               handler:(IPHAlertActionHandeler)handler
                                     otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertController *)iph_showActionSheetInController:(UIViewController *)viewController
                                                 title:(NSString *)title
                                               message:(NSString *)message
                                               handler:(IPHAlertActionHandeler)handler
                                destructiveActionTitle:(NSString *)destructiveActionTitle
                                     cancelActionTitle:(NSString *)cancelActionTitle
                                     otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertController *)iph_actionSheetControllerWithTitle:(NSString *)title
                                                  message:(NSString *)message
                                                  handler:(IPHAlertActionHandeler)handler
                                        cancelActionTitle:(NSString *)cancelActionTitle
                                        otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertController *)iph_actionSheetControllerWithTitle:(NSString *)title
                                                  message:(NSString *)message
                                                  handler:(IPHAlertActionHandeler)handler
                                   destructiveActionTitle:(NSString *)destructiveActionTitle
                                        cancelActionTitle:(NSString *)cancelActionTitle
                                        otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface UIAlertController (IPHAdditions)

+ (UIAlertController *)iph_alertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                            handler:(IPHAlertActionHandeler)handler
                             destructiveActionTitle:(NSString *)destructiveActionTitle
                                  cancelActionTitle:(NSString *)cancelActionTitle
                                  otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

// Do not call this method
+ (UIAlertController *)iph_alertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                            handler:(IPHAlertActionHandeler)handler
                             destructiveActionTitle:(NSString *)destructiveActionTitle
                                  cancelActionTitle:(NSString *)cancelActionTitle
                                   otherActionTitle:(NSString *)otherActionTitle
                                               args:(va_list)args;

@end



