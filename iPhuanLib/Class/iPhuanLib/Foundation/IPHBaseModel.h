//
//  IPHBaseModel.h
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPHBaseModel : NSObject <NSCoding, NSCopying>

// 返回对象属性的映射字典，Key为属性的名称，Value为映射的数据字典的Key；方法initWithDictionary就是基于该映射来实现的，基于该映射来通过一个字典来初始化该对象。
- (NSDictionary *)attributeMapDictionary; // 在子类中重写该方法



// 当属性的值为空时通过该映射来设定对应属性的默认值，
- (NSDictionary *)attributeDefaultValueMapDictionary; // 在子类中重写该方法



// 如果用于初始化的数据中，对应字段的字符串包含数组里过滤的字符串，则该字典的对应属性将直接设为nil
- (NSArray<NSString *> *)filterStrings; // 在子类中重写该方法



/*
 如果属性为对象或者数组，且对象为IPHBaseModel的子类或者数组的元素也都为IPHBaseModel的子类，可通过该映射来为对应属性初始化对应类型的数据，Key为属性的名称，当属性为IPHBaseModel子类时Value为该属性的类名，当属性为数组时，Value为该数组中元素的类名。
 如：
 @interface IPHTestModel : IPHBaseModel
 @property (nonatomic, readonly, strong) IPHHotel *hotel;
 @property (nonatomic, readonly, copy) NSArray<IPHHotel *> *hotels;
 
 IPHHotel为IPHBaseModel的子类，
 - (NSDictionary *)attributeTypesMapDictionary {
 return @{@"hotel": @"IPHHotel",
 @"hotels": @"IPHHotel"};
 }
 通过该映射，在通过initWithDictionary方法给IPHTestModel对象初始化的时候，除了普通的字符串属性可以直接赋值外，对象属性和数组属性也能正确的初始化为对应类型的数据，hotel属性里面是IPHHotel对象而不是没有转化过的字典，hotels元素里面也都对应为IPHHotel对象。
 */
- (NSDictionary *)attributeTypesMapDictionary; // 在子类中重写该方法



/*
对应于attributeTypesMapDictionary，当IPHBaseModel将字典转化为IPHBaseModel对象之后，会调用该方法，将对象传递过来允许开发人员在该方法中对该对象进行二次处理，处理完后IPHBaseModel才将最终的值赋给对应的对象和数组属性。object即为传递过来的对象，通过attributeName可判断当前是在对哪个属性赋值，如：
- (__kindof IPHBaseModel *)handleAttributeValue:(__kindof IPHBaseModel *)object forAttributeName:(NSString *)attributeName {
    if ([@"hotel" isEqualToString:attributeName]) {
        IPHHotel *hotel = object;
        hotel.type = IPHHotelTypeFamilyHotel;
        return hotel;
    }
    return object;
}
*/
- (__kindof IPHBaseModel *)handleAttributeValue:(__kindof IPHBaseModel *)object forAttributeName:(NSString *)attributeName; // 在子类中重写该方法


// IPHBaseModel通过initWithDictionary初始化对象后会调用该方法，开发者可在该方法中进行相关初始化操作
- (void)setup;



// 通过数据字典初始化对象，基于attributeMapDictionary映射来初始化对应的属性
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;



// 将对象转化为字典
- (NSDictionary *)toDictionary;



// 获取适用于存档的Data数据
- (NSData *)archivedData;


@end
