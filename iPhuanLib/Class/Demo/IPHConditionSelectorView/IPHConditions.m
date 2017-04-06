//
//  IPHConditions.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/3/31.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHConditions.h"
#import "IPHCondition.h"

NSString *const kIPHInvalidId = @"invalid";

@interface IPHConditions ()
@property (nonatomic, readwrite, copy) NSArray<IPHCondition *> *starConditions;
@property (nonatomic, readwrite, copy) NSArray<IPHCondition *> *priceConditions;


@end

@implementation IPHConditions

- (NSDictionary*)attributeMapDictionary{
    return @{@"starConditions":@"starConditions",
             @"priceConditions":@"priceConditions"};
}

- (NSDictionary *)attributeTypesMapDictionary {
    return @{@"starConditions": @"IPHCondition",
             @"priceConditions": @"IPHCondition"};
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        _starConditions = [self p_conditionsFromConditionList:_starConditions];
        _priceConditions = [self p_conditionsFromConditionList:_priceConditions];
    }
    return self;
}


// 添加无限制的条件
- (NSArray *)p_conditionsFromConditionList:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    [array insertObject:[self p_unlimitedCondition] atIndex:0];
    return [array copy];
}

- (IPHCondition *)p_unlimitedCondition{
    IPHCondition *condition = [[IPHCondition alloc] init];
    condition.title = @"不限";
    condition.conditionId = kIPHInvalidId;
    condition.isUnlimited = YES;
    return condition;
}

@end
