//
//  IPHConditionCell.h
//  iPhuanLib
//
//  Created by iPhuan on 2016/12/27.
//  Copyright © 2016年 iPhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPHConditionCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *headerTitleColor;
@property (nonatomic, strong) UIColor *buttonNormalColor;
@property (nonatomic, strong) UIColor *buttonSelectedColor;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

- (void)setConditionsData:(NSArray *)conditionsData selectedConditions:(NSMutableArray *)selectedConditions;

+ (CGFloat)getCellHeightWithConditions:(NSArray *)conditions;

@end
