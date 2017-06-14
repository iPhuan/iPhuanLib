//
//  IPHOverseasHotel.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "NSObject+IPHBaseModel.h"
@class IPHDeluxeRoom;

@interface IPHOverseasHotel : NSObject <IPHBaseModelProtocal, NSCopying, NSCoding>
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *address;
@property (nonatomic, readonly, copy) NSString *basePrice;
@property (nonatomic, readonly, copy) NSString *cityId;
@property (nonatomic, readonly, copy) NSString *cityName;
@property (nonatomic, readonly, copy) NSString *commentCount;
@property (nonatomic, readonly, strong) IPHDeluxeRoom *recommendRoom; // 包含IPHDeluxeRoom对象的属性
@property (nonatomic, readonly, copy) NSArray<IPHDeluxeRoom *> *rooms; // 包含IPHDeluxeRoom元素的数组属性


// 也可添加不在映射里的属性，比如遵循assign内存管理语义的属性
@property (nonatomic, readonly, assign) BOOL hasWifi;
@property (nonatomic, copy) NSString *country;

@end
