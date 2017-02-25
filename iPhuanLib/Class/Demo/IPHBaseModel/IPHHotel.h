//
//  IPHHotel.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModel.h"
@class IPHRoom;

@interface IPHHotel : IPHBaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *basePrice;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *hasWifiTag;
@property (nonatomic, strong) IPHRoom *recommendRoom; // 包含IPHRoom对象的属性
@property (nonatomic, strong) NSArray<IPHRoom *> *rooms; // 包含IPHRoom元素的数组属性


// 也可添加不在映射里的属性，比如遵循assign内存管理语义的属性
@property (nonatomic, assign) BOOL hasWifi;

@end
