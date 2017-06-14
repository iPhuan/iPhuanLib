//
//  IPHAppImage.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "NSObject+IPHBaseModel.h"

typedef NS_ENUM(NSUInteger, IPHAppImageType) {
    IPHAppImageTypeHotel = 1,
    IPHAppImageTypeOthers = 2,
};

@interface IPHAppImage : NSObject <IPHBaseModelProtocal, NSCopying, NSCoding>
@property (nonatomic, readonly, copy) NSString *imageId;
@property (nonatomic, readonly, copy) NSString *desc;
@property (nonatomic, readonly, copy) NSString *type;
@property (nonatomic, readonly, copy) NSString *url;

@property (nonatomic, assign) IPHAppImageType imageType;


@end
