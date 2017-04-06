//
//  IPHRoom.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModel.h"
@class IPHImage;

@interface IPHRoom : IPHBaseModel
@property (nonatomic, readonly, copy) NSString *roomType;
@property (nonatomic, readonly, copy) NSString *area;
@property (nonatomic, readonly, copy) NSString *price;
@property (nonatomic, readonly, copy) NSArray<IPHImage *> *images;

@end
