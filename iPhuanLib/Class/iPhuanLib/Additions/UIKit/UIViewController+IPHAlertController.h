//
//  UIViewController+IPHAlertController.h
//  wifiapp
//
//  Created by iPhuan on 2017/1/15.
//  Copyright © 2017年 bangtai. All rights reserved.
//

#import "UIAlertController+IPHAdditions.h"

@interface UIViewController (IPHAlertView)

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message;

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                  cancelActionTitle:(NSString *)cancelActionTitle;

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                            handler:(IPHAlertActionHandeler)handler
                  cancelActionTitle:(NSString *)cancelActionTitle
                  otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                            handler:(IPHAlertActionHandeler)handler
             destructiveActionTitle:(NSString *)destructiveActionTitle
                  cancelActionTitle:(NSString *)cancelActionTitle
                  otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface UIViewController (IPHActionSheet)

// 默认添加cancelActionTitle “取消”按钮
- (void)iph_showActionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                             handler:(IPHAlertActionHandeler)handler
                   otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)iph_showActionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                             handler:(IPHAlertActionHandeler)handler
              destructiveActionTitle:(NSString *)destructiveActionTitle
                   cancelActionTitle:(NSString *)cancelActionTitle
                   otherActionTitles:(NSString *)otherActionTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
