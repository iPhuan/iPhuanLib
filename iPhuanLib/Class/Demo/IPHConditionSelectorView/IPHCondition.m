//
//  IPHCondition.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/3/31.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHCondition.h"

NSString *const IPHInvalidCode = @"invalid";

@implementation IPHCondition

- (NSDictionary*)attributeMapDictionary{
    return @{@"conditionId":@"code",
             @"title":@"name"};
}


- (BOOL)isUnlimited {
    return [IPHInvalidCode isEqualToString:_conditionId];
}

@end
