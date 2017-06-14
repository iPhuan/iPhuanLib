//
//  IPHDeluxeRoom.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "NSObject+IPHBaseModel.h"
@class IPHAppImage;

@interface IPHDeluxeRoom : NSObject <IPHBaseModelProtocal, NSCopying, NSCoding>
@property (nonatomic, readonly, copy) NSString *roomType;
@property (nonatomic, readonly, copy) NSString *area;
@property (nonatomic, readonly, copy) NSString *price;
@property (nonatomic, readonly, copy) NSArray<IPHAppImage *> *images;

@end
