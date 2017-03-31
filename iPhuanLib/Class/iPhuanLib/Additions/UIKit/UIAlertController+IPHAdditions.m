//
//  UIAlertController+IPHAdditions.m
//
//
//  Created by iPhuan on 2017/1/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "UIAlertController+IPHAdditions.h"


NSString *const IPHActionSheetShowErrorMessage = @"The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. You must provide location information for this popover through the alert controller's popoverPresentationController. You must provide either a sourceView and sourceRect or a barButtonItem.";


#define IPH_ALERT_CONTROLLER(VC, ti, msg, block, destructive, cancel, other) UIAlertController *alertController = [self iph_alertControllerWithTitle:ti  \
message:msg  \
preferredStyle:UIAlertControllerStyleAlert \
handler:block \
destructiveActionTitle:destructive \
cancelActionTitle:cancel \
otherActionTitle:other \
args:nil]; \
[VC presentViewController:alertController animated:YES completion:nil]; \
return alertController;


#define IPH_ALERT_CONTROLLER_VA(VC, ti, msg, style, block, destructive, cancel, other, ags) va_start(ags, other);  \
UIAlertController *alertController = [self iph_alertControllerWithTitle:ti  \
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
return alertController;


#pragma mark - IPHAdditions

@implementation UIAlertController (IPHAdditions)

+ (UIAlertController *)iph_alertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                            handler:(IPHAlertActionHandeler)handler
                             destructiveActionTitle:(NSString *)destructiveActionTitle
                                  cancelActionTitle:(NSString *)cancelActionTitle
                                  otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    UIViewController *VC = nil;
    IPH_ALERT_CONTROLLER_VA(VC, title, message, preferredStyle, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

+ (UIAlertController *)iph_alertControllerWithTitle:(NSString *)title
                                            message:(NSString *)message
                                     preferredStyle:(UIAlertControllerStyle)preferredStyle
                                            handler:(IPHAlertActionHandeler)handler
                             destructiveActionTitle:(NSString *)destructiveActionTitle
                                  cancelActionTitle:(NSString *)cancelActionTitle
                                   otherActionTitle:(NSString *)otherActionTitle
                                               args:(va_list)args {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    NSInteger index = -1;
    if (otherActionTitle) {
        NSString *actionTitle = otherActionTitle;
        while (actionTitle) {
            index++;
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (handler) {
                    handler(action, index);
                }
            }];
            [alertController addAction:alertAction];
            actionTitle = va_arg(args, NSString *);
        }
    }
    
    if (destructiveActionTitle) {
        index++;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:destructiveActionTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (handler) {
                handler(action, index);
            }
        }];
        [alertController addAction:alertAction];
    }
    
    if (cancelActionTitle) {
        index++;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (handler) {
                handler(action, index);
            }
        }];
        [alertController addAction:alertAction];
    }
    return alertController;
}


@end


#pragma mark - IPHAlertView

@implementation UIAlertController (IPHAlertView)

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message {
    IPH_ALERT_CONTROLLER(viewController, title, message, nil, nil, JSC_ALERTVIEW_CANCEL_TITLE, nil);
}

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message
                                    cancelActionTitle:(NSString *)cancelActionTitle {
    IPH_ALERT_CONTROLLER(viewController, title, message, nil, nil, cancelActionTitle, nil);
}

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message
                                              handler:(IPHAlertActionHandeler)handler
                                    cancelActionTitle:(NSString *)cancelActionTitle
                                    otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_ALERT_CONTROLLER_VA(viewController, title, message, UIAlertControllerStyleAlert, handler, nil, cancelActionTitle, otherActionTitles, args);
}

+ (UIAlertController *)iph_popupAlertViewInController:(UIViewController *)viewController
                                                title:(NSString *)title
                                              message:(NSString *)message
                                              handler:(IPHAlertActionHandeler)handler
                               destructiveActionTitle:(NSString *)destructiveActionTitle
                                    cancelActionTitle:(NSString *)cancelActionTitle
                                    otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_ALERT_CONTROLLER_VA(viewController, title, message, UIAlertControllerStyleAlert, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

+ (UIAlertController *)iph_alertViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                handler:(IPHAlertActionHandeler)handler
                                 destructiveActionTitle:(NSString *)destructiveActionTitle
                                      cancelActionTitle:(NSString *)cancelActionTitle
                                      otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    UIViewController *VC = nil;
    IPH_ALERT_CONTROLLER_VA(VC, title, message, UIAlertControllerStyleAlert, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

@end


#pragma mark - IPHActionSheet

@implementation UIAlertController (IPHActionSheet)

+ (UIAlertController *)iph_showActionSheetInController:(UIViewController *)viewController
                                                 title:(NSString *)title
                                               message:(NSString *)message
                                               handler:(IPHAlertActionHandeler)handler
                                     otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_ALERT_CONTROLLER_VA(viewController, title, message, UIAlertControllerStyleActionSheet, handler, nil, @"取消", otherActionTitles, args);
}

+ (UIAlertController *)iph_showActionSheetInController:(UIViewController *)viewController
                                                 title:(NSString *)title
                                               message:(NSString *)message
                                               handler:(IPHAlertActionHandeler)handler
                                destructiveActionTitle:(NSString *)destructiveActionTitle
                                     cancelActionTitle:(NSString *)cancelActionTitle
                                     otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    IPH_ALERT_CONTROLLER_VA(viewController, title, message, UIAlertControllerStyleActionSheet, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

+ (UIAlertController *)iph_actionSheetControllerWithTitle:(NSString *)title
                                                  message:(NSString *)message
                                                  handler:(IPHAlertActionHandeler)handler
                                        cancelActionTitle:(NSString *)cancelActionTitle
                                        otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    UIViewController *VC = nil;
    IPH_ALERT_CONTROLLER_VA(VC, title, message, UIAlertControllerStyleActionSheet, handler, nil, cancelActionTitle, otherActionTitles, args);
}

+ (UIAlertController *)iph_actionSheetControllerWithTitle:(NSString *)title
                                                  message:(NSString *)message
                                                  handler:(IPHAlertActionHandeler)handler
                                   destructiveActionTitle:(NSString *)destructiveActionTitle
                                        cancelActionTitle:(NSString *)cancelActionTitle
                                        otherActionTitles:(NSString *)otherActionTitles, ... {
    va_list args;
    UIViewController *VC = nil;
    IPH_ALERT_CONTROLLER_VA(VC, title, message, UIAlertControllerStyleActionSheet, handler, destructiveActionTitle, cancelActionTitle, otherActionTitles, args);
}

@end


