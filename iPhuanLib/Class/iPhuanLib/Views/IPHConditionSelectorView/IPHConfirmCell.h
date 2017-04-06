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
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, copy)  IPHOnConfirmButtonBlock onConfirmButtonBlock;


@end
