//
//  IPHDeluxeRoom.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHDeluxeRoom.h"
#import "IPHAppImage.h"

@interface IPHDeluxeRoom ()
@property (nonatomic, readwrite, copy) NSString *roomType;
@property (nonatomic, readwrite, copy) NSString *area;
@property (nonatomic, readwrite, copy) NSString *price;
@property (nonatomic, readwrite, copy) NSArray<IPHAppImage *> *images;

@end

@implementation IPHDeluxeRoom

#pragma mark - IPHBaseModelProtocal

- (NSDictionary *)attributeMapDictionary {
    return @{@"roomType": @"roomType",
             @"area": @"area",
             @"price": @"price",
             @"images": @"imgUrlList"};
}


#pragma mark - 方式一实现对象和数组属性的映射

- (NSDictionary *)attributeTypesMapDictionary {
    return @{@"images": @"IPHAppImage"};
}

- (id <IPHBaseModelProtocal>)handleAttributeValue:(id <IPHBaseModelProtocal>)object forAttributeName:(NSString *)attributeName {
    if ([@"images" isEqualToString:attributeName]) {
        IPHAppImage *image = (IPHAppImage *)object;
        image.imageType = IPHAppImageTypeHotel;
        return image;
    }
    return object;
}


#pragma mark - 方式二实现对象和数组属性的映射
// 也可手动解析imgUrlList里面的数据
//- (void)setImages:(NSArray<IPHAppImage *> *)images{
//    id obj = nil;
//    if ([images isKindOfClass:[NSArray class]] && images.count > 0) {
//        obj = images[0];
//    }
//    
//    // 如果images元素的类型为字典则手动进行数据处理
//    if ([obj isKindOfClass:[NSDictionary class]]) {
//        NSMutableArray *imageList = [[NSMutableArray alloc] initWithCapacity:images.count];
//        for (NSDictionary *imageDic in images) {
//            IPHAppImage *image = [[IPHAppImage alloc] initWithIphDictionary:imageDic];
//            
//            // 特殊数据处理，将所有图片的类型都设置为酒店类型
//            image.imageType = IPHAppImageTypeHotel;
//            [imageList addObject:image];
//        }
//        _images = [[NSArray alloc] initWithArray:imageList];
//        return;
//    }
//    
//    // 如果images元素已经为IPHAppImage对象，则直接赋值
//    _images = [images copy];
//}


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
