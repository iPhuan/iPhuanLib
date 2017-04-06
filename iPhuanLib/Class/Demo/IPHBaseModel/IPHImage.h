//
//  IPHImage.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModel.h"

typedef NS_ENUM(NSUInteger, IPHImageType) {
    IPHImageTypeHotel = 1,
    IPHImageTypeOthers = 2,
};

@interface IPHImage : IPHBaseModel
@property (nonatomic, readonly, copy) NSString *imageId;
@property (nonatomic, readonly, copy) NSString *desc;
@property (nonatomic, readonly, copy) NSString *type;
@property (nonatomic, readonly, copy) NSString *url;

@property (nonatomic, assign) IPHImageType imageType;


@end
