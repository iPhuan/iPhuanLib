//
//  NSObject+IPHBaseModel.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/13.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModelProtocal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (IPHBaseModel)

// 通过一个字典来初始化对象，该对象需要遵循IPHBaseModelProtocal协议，并实现attributeMapDictionary方法
- (instancetype)initWithIphDictionary:(nullable NSDictionary *)dictionary;
+ (instancetype)iph_objectWithDictionary:(nullable NSDictionary *)dictionary;

// 将一个遵循IPHBaseModelProtocal协议的对象反向转化为字典；如果对象不遵循IPHBaseModelProtocal协议，或者对象的属性不遵循IPHBaseModelProtocal协议，则都进行字典转化
- (nullable NSDictionary *)iph_toDictionary;

// 通过iph_toDictionary方法转化为字典，并输出该字典的UTF-8的description
- (nullable NSString *)iph_description;

// 获取适用于存档的Data数据
- (nullable NSData *)iph_archivedData;

/*
示例：
- (id)copyWithZone:(NSZone *)zone {
    return [self iph_copyWithZone:zone];
}
*/
- (id)iph_copyWithZone:(NSZone *)zone;

/*
 示例：
 - (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self iph_decodeWithCoder:aDecoder];
    }
    return self;
 }
*/
- (void)iph_decodeWithCoder:(NSCoder *)decoder;

/*
 示例：
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self iph_encodeWithCoder:aCoder];
}
*/
- (void)iph_encodeWithCoder:(NSCoder *)encoder;

@end


NS_ASSUME_NONNULL_END
