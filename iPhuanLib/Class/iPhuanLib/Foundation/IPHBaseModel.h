//
//  IPHBaseModel.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPHBaseModel : NSObject <NSCoding, NSCopying>

// 返回对象属性的映射字典，Key为属性的名称，Value为映射的数据字典的Key；方法initWithDictionary，toDictionary，description，copyWithZone，initWithCoder，encodeWithCoder都是基于该映射来实现的，只有在该映射中添加了属性名称作为Key，才能在以上几个方法中对该属性进行相关操作。
- (NSDictionary *)attributeMapDictionary; // 在子类中重写该方法


/*
如果属性为对象或者数组，且对象为IPHBaseModel的子类或者数组的元素也都为IPHBaseModel的子类，可通过该映射来为对应属性初始化对应类型的数据，Key为属性的名称，当属性为IPHBaseModel子类时Value为该属性的类名，当属性为数组时，Value为该数组中元素的类名。
如：
@interface IPHTestModel : IPHBaseModel
@property (nonatomic, strong) IPHHotel *hotel;
@property (nonatomic, strong) NSArray<IPHHotel *> *hotels;
 
IPHHotel为IPHBaseModel的子类，
- (NSDictionary *)attributeTypesMapDictionary {
    return @{@"hotel": @"IPHHotel",
             @"hotels": @"IPHHotel"};
}
通过该映射，在通过initWithDictionary方法给IPHTestModel对象初始化的时候，除了普通的字符串属性可以直接赋值外，对象属性和数组属性也能正确的初始化为对应类型的数据，hotel属性里面是IPHHotel对象而不是没有转化过的字典，hotels元素里面也都对应为IPHHotel对象。
*/
- (NSDictionary *)attributeTypesMapDictionary; // 在子类中重写该方法


// 当属性的值为空时通过该映射来设定对应属性的默认值，
- (NSDictionary *)attributeDefaultValueMapDictionary; // 在子类中重写该方法


// 如果用于初始化的数据中，对应字段的字符串包含数组里过滤的字符串，则该字典的对应属性将直接设为nil
- (NSArray<NSString *> *)filterStrings; // 在子类中重写该方法


// 通过数据字典初始化对象，基于attributeMapDictionary映射来初始化对应的属性
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


// 将对象转化为字典，只能将映射当中对应的属性转化
- (NSDictionary *)toDictionary;


// 获取适用于存档的Data数据
- (NSData *)archivedData;


@end
