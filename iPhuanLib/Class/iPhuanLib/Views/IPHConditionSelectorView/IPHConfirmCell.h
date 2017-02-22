//
//  IPHConfirmTableViewCell.h
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/27.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IPHOnConfirmButtonBlock)(void);


@interface IPHConfirmCell : UITableViewCell
@property (strong, nonatomic) UIColor *buttonBackgroundColor;
@property (copy, nonatomic)  IPHOnConfirmButtonBlock onConfirmButtonBlock;


@end
