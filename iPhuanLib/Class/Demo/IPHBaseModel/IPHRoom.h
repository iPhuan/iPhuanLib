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
@property (nonatomic, copy) NSString *roomType;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) NSArray<IPHImage *> *images;

@end
