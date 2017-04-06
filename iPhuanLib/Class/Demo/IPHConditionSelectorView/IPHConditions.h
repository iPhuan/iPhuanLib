//
//  IPHConditions.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/3/31.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModel.h"

@class IPHCondition;

@interface IPHConditions : IPHBaseModel
@property (nonatomic, readonly, copy) NSArray<IPHCondition *> *starConditions;
@property (nonatomic, readonly, copy) NSArray<IPHCondition *> *priceConditions;


@end
