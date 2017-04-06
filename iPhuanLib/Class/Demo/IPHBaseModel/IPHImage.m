//
//  IPHImage.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHImage.h"

@interface IPHImage ()
@property (nonatomic, readwrite, copy) NSString *imageId;
@property (nonatomic, readwrite, copy) NSString *desc;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *url;

@end


@implementation IPHImage

- (NSDictionary *)attributeMapDictionary {
    return @{@"imageId": @"imageId",
             @"desc": @"desc",
             @"type": @"type",
             @"url": @"url"};
}



@end
