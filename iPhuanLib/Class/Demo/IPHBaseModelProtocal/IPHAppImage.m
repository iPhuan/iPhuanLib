//
//  IPHAppImage.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHAppImage.h"

@interface IPHAppImage ()
@property (nonatomic, readwrite, copy) NSString *imageId;
@property (nonatomic, readwrite, copy) NSString *desc;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *url;

@end


@implementation IPHAppImage

#pragma mark - IPHBaseModelProtocal

- (NSDictionary *)attributeMapDictionary {
    return @{@"imageId": @"imageId",
             @"desc": @"desc",
             @"type": @"type",
             @"url": @"url"};
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




@end
