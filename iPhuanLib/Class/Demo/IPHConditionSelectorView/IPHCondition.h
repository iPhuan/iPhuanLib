//
//  IPHCondition.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/3/31.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModel.h"
#import "IPHConditionProtocol.h"

extern NSString *const IPHInvalidCode;

@interface IPHCondition : IPHBaseModel <IPHConditionProtocol>

@property (nonatomic, copy) NSString *conditionId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isUnlimited;


@end
