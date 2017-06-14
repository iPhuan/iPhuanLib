//
//  IPHOverseasHotel.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHOverseasHotel.h"
#import "IPHDeluxeRoom.h"

@interface IPHOverseasHotel ()
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *basePrice;
@property (nonatomic, readwrite, copy) NSString *cityId;
@property (nonatomic, readwrite, copy) NSString *cityName;
@property (nonatomic, readwrite, copy) NSString *commentCount;
@property (nonatomic, readwrite, strong) IPHDeluxeRoom *recommendRoom;
@property (nonatomic, readwrite, copy) NSArray<IPHDeluxeRoom *> *rooms;

@property (nonatomic, copy) NSString *hasWifiTag;


@end

@implementation IPHOverseasHotel

#pragma mark - IPHBaseModelProtocal
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

// 映射指定属性recommendRoom和rooms对应的数据类型为IPHDeluxeRoom对象
- (NSDictionary *)attributeTypesMapDictionary {
    return @{@"recommendRoom": @"IPHDeluxeRoom",
             @"rooms": @"IPHDeluxeRoom"};
}

// 设置地址，城市，是否有wifi在值为nil时的默认值
- (NSDictionary *)attributeDefaultValueMapDictionary {
    return @{@"address": @"地址未知",
             @"cityName": @"城市未知",
             @"hasWifiTag": @"0"};
}

// 父类过滤条件已满足需求，过滤Json数据中的 "cityCode": "(null)", "cityName": "<null>",此时可以不重写该方法。
- (NSArray<NSString *> *)filterStrings {
    return @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
}


#pragma mark - NSCopying
// 实现NSCopying协议
- (id)copyWithZone:(NSZone *)zone {
    return [self iph_copyWithZone:zone];
}


#pragma mark - NSCoding
// 实现NSCoding协议
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self iph_encodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self iph_decodeWithCoder:aDecoder];
    }
    return self;
}

#pragma mark - description
- (NSString *)description {
    return [self iph_description];
}


#pragma mark - 

- (BOOL)hasWifi{
    return [_hasWifiTag boolValue];
}


@end
