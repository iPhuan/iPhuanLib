//
//  IPHHotel.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHHotel.h"

@interface IPHHotel ()
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *basePrice;
@property (nonatomic, readwrite, copy) NSString *cityId;
@property (nonatomic, readwrite, copy) NSString *cityName;
@property (nonatomic, readwrite, copy) NSString *commentCount;
@property (nonatomic, readwrite, copy) NSString *hasWifiTag;
@property (nonatomic, readwrite, strong) IPHRoom *recommendRoom;
@property (nonatomic, readwrite, copy) NSArray<IPHRoom *> *rooms;

@end

@implementation IPHHotel

// 映射对象属性，key为属性的名称，Value为Json数据中对应的字段
- (NSDictionary *)attributeMapDictionary {
    return @{@"name": @"name",
             @"address": @"address",
             @"basePrice": @"basePrice",
             @"cityId": @"cityCode",
             @"cityName": @"cityName",
             @"commentCount": @"commentCount",
             @"hasWifiTag": @"hasWifi",
             @"recommendRoom": @"recommendRoom",
             @"rooms": @"rooms"};
}

// 映射指定属性recommendRoom和rooms对应的数据类型为IPHRoom对象
- (NSDictionary *)attributeTypesMapDictionary {
    return @{@"recommendRoom": @"IPHRoom",
             @"rooms": @"IPHRoom"};
}

// 设置地址，城市，是否有wifi在值为nil时的默认值
- (NSDictionary *)attributeDefaultValueMapDictionary {
    return @{@"address": @"地址未知",
             @"cityName": @"城市未知",
             @"hasWifiTag": @"0"};
}

// 父类过滤条件已满足需求，过滤Json数据中的 "cityCode": "(null)", "cityName": "<null>",此时可以不重写该方法。
- (NSArray<NSString *> *)filterStrings {
    return [super filterStrings];
}

- (BOOL)hasWifi{
    return [_hasWifiTag boolValue];
}


@end
