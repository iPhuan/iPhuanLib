//
//  IPHRoom.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/26.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHRoom.h"
#import "IPHImage.h"

@implementation IPHRoom

- (NSDictionary *)attributeMapDictionary {
    return @{@"roomType": @"roomType",
             @"area": @"area",
             @"price": @"price",
             @"images": @"imgUrlList"};
}


//- (NSDictionary *)attributeTypesMapDictionary {
//    return @{@"images": @"IPHImage"};
//}

// 也可手动解析imgUrlList里面的数据
- (void)setImages:(NSArray<IPHImage *> *)images{
    id obj = nil;
    if ([images isKindOfClass:[NSArray class]] && images.count > 0) {
        obj = images[0];
    }
    
    // 如果images元素的类型为字典则手动进行数据处理
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *imageList = [[NSMutableArray alloc] initWithCapacity:images.count];
        for (NSDictionary *imageDic in images) {
            IPHImage *image = [[IPHImage alloc] initWithDictionary:imageDic];
            
            // 特殊数据处理，将所有图片的类型都设置为酒店类型
            image.imageType = IPHImageTypeHotel;
            [imageList addObject:image];
        }
        _images = [[NSArray alloc] initWithArray:imageList];
        return;
    }
    
    // 如果images元素已经为IPHImage对象，则直接赋值
    _images = images;
}


@end
