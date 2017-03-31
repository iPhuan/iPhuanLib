//
//  UIViewController+IPHAlertController.m
//  wifiapp
//
//  Created by iPhuan on 2017/1/15.
//  Copyright © 2017年 bangtai. All rights reserved.
//

#define IPH_SHOW_ALERT_CONTROLLER(VC, ti, msg, block, destructive, cancel, other) UIAlertController *alertController = [UIAlertController iph_alertControllerWithTitle:ti  \
message:msg  \
preferredStyle:UIAlertControllerStyleAlert \
handler:block \
destructiveActionTitle:destructive \
cancelActionTitle:cancel \
otherActionTitle:other \
args:nil]; \
[VC presentViewController:alertController animated:YES completion:nil];


#define IPH_SHOW_ALERT_CONTROLLER_VA(VC, ti, msg, style, block, destructive, cancel, other, ags) va_start(ags, other); \
UIAlertController *alertController = [UIAlertController iph_alertControllerWithTitle:ti \
message:msg  \
preferredStyle:style \
handler:block \
destructiveActionTitle:destructive \
cancelActionTitle:cancel \
otherActionTitle:other \
args:ags]; \
BOOL canShowAlertController = YES; \
if (alertController.preferredStyle == UIAlertControllerStyleActionSheet && alertController.popoverPresentationController) { \
canShowAlertController = NO; \
} \
if (canShowAlertController) { \
[VC presentViewController:alertController animated:YES completion:nil]; \
}else{ \
IPHLog(@"Your application has presented a UIAlertController (<UIAlertController: %p>) of style UIAlertControllerStyleActionSheet. %@", alertController, IPHActionSheetShowErrorMessage); \
} \
va_end(ags); \



#import "UIViewController+IPHAlertController.h"

@implementation UIViewController (IPHAlertView)

-  (void)iph_popupAlertViewWithTitle:(NSString *)title
                             message:(NSString *)message {
    IPH_SHOW_ALERT_CONTROLLER(self, title, message, nil, nil, JSC_ALERTVIEW_CANCEL_TITLE, nil);
}

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                  cancelActionTitle:(NSString *)cancelActionTitle {
    IPH_SHOW_ALERT_CONTROLLER(self, title, message, nil, nil, cancelActionTitle, nil);
}

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                            handler:(IPHAlertActionHandeler)handler
                  cancelActionTitle:(NSString *)cancelActionTitle
                  otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_SHOW_ALERT_CONTROLLER_VA(self, title, message, UIAlertControllerStyleAlert, handler, nil, cancelActionTitle, otherActionTitles, args);
}

- (void)iph_popupAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                            handler:(IPHAlertActionHandeler)handler
             destructiveActionTitle:(NSString *)destructiveActionTitle
                  cancelActionTitle:(NSString *)cancelActionTitle
                  otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_SHOW_ALERT_CONTROLLER_VA(self, title, message, UIAlertControllerStyleAlert, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

@end

@implementation UIViewController (IPHActionSheet)

- (void)iph_showActionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                             handler:(IPHAlertActionHandeler)handler
                   otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_SHOW_ALERT_CONTROLLER_VA(self, title, message, UIAlertControllerStyleActionSheet, handler, nil, @"取消", otherActionTitles, args);
}

- (void)iph_showActionSheetWithTitle:(NSString *)title
                             message:(NSString *)message
                             handler:(IPHAlertActionHandeler)handler
              destructiveActionTitle:(NSString *)destructiveActionTitle
                   cancelActionTitle:(NSString *)cancelActionTitle
                   otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_SHOW_ALERT_CONTROLLER_VA(self, title, message, UIAlertControllerStyleActionSheet, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

@end
