//
//  IPHBaseModel.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/2/18.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModel.h"
#import <objc/message.h>


@implementation IPHBaseModel

#pragma mark - Need Override

-(NSDictionary *)attributeMapDictionary {
    IPH_OVERRIDE_WARN(@"IPHBaseModel", NSStringFromClass([self class]));
    return nil;
}

- (NSDictionary *)attributeTypesMapDictionary {
    return nil;
}


- (NSDictionary *)attributeDefaultValueMapDictionary {
    return nil;
}

- (NSArray *)filterStrings{
    // 当值为以下字符串时直接设为nil
    return @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
}


#pragma mark - init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        [self p_setAttributes:dictionary];
    }
    return self;
}

- (void)p_setAttributes:(NSDictionary*)dataDictionary {
    if (dataDictionary == nil) {
        return;
    }
    
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil || attrMapDic.count == 0) {
        return;
    }
    
    NSDictionary *defaultValueDic = [self attributeDefaultValueMapDictionary];
    BOOL needSetDefaultValue = defaultValueDic?YES:NO;
    
    [attrMapDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *dataDicKey, BOOL *stop) {
        if ([self p_validatePropertyNamed:propertyName]) {
            id value = dataDictionary[dataDicKey];
            if ([value isKindOfClass:[NSNull class]]) {
                value = nil;
            }else if ([value isKindOfClass:[NSNumber class]]) {
                value = ((NSNumber *)value).stringValue;
            }else if ([value isKindOfClass:[NSString class]] && [[self filterStrings] containsObject:value]) {
                value = nil;
            }
            
            // 设置默认值
            if (needSetDefaultValue && value == nil) {
                value = defaultValueDic[propertyName];
            }
            
            SEL setSel = [self p_setterSelForPropertyName:propertyName];
            //使用objc_msgSend而不使用setValue是为了保证可以通过重写Set的方法自行给给数组和IPHBaseModel对象处理数据。
            ((id (*)(id, SEL, id))objc_msgSend)(self, setSel, value);
        }
    }];
    
    // 对对象和数组属性单独做数据转化处理
    [self p_setArrayAndObjectAttributes];
}

-(SEL)p_setterSelForPropertyName:(NSString *)propertyName{
    NSString *capital = [[propertyName substringToIndex:1] uppercaseString];
    NSString *setSelStr = [NSString stringWithFormat:@"set%@%@:", capital, [propertyName substringFromIndex:1]];
    return NSSelectorFromString(setSelStr);
}

- (void)p_setArrayAndObjectAttributes {
    // 对对象和数组属性单独处理
    NSDictionary *typesDic = [self attributeTypesMapDictionary];
    if (typesDic.count == 0) {
        return;
    }
    
    [typesDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *propertyType, BOOL *stop) {
        // 检查是否为属性名是否正确
        SEL getSel = NSSelectorFromString(@"propertyName");
        if (![self respondsToSelector:getSel]) {
            IPHLog(@"Error: %@ is not a property, check you return dictionary in 'arrayElementsAndObjectTypesDictionary'.", propertyName);
            return;
        }
        
        // 检查对象是否为IPHBaseModel的子类
        Class propertyClass = NSClassFromString(propertyType);
        if (![propertyClass isSubclassOfClass:self.class]) {
            IPHLog(@"Error: %@ is not a 'IPHBaseModel' Class, check you return dictionary in 'arrayElementsAndObjectTypesDictionary'.", propertyType);
            return;
        }
        
        id originalValue = [self valueForKey:propertyName];
        id transformedValue = nil;
        
        //如果是数组，需要遍历后转化为对象
        if ([originalValue isKindOfClass:[NSArray class]]) {
            NSArray *arrayData = (NSArray *)originalValue;
            NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:arrayData.count];
            [arrayData enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger index, BOOL *stop) {
                // 如果数组里面的元素不是字典，则停止处理
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    *stop = YES;
                }
                
                @autoreleasepool {
                    id model = [[propertyClass alloc] initWithDictionary:dic];
                    [models addObject:model];
                }
            }];
            
            if (models.count > 0) {
                transformedValue = [models copy];
            }
            
        }else if ([originalValue isKindOfClass:[NSDictionary class]]) {
            transformedValue = [[propertyClass alloc] initWithDictionary:originalValue];
        }
        
        if (transformedValue) {
            [self setValue:transformedValue forKey:propertyName];
        }
    }];

}




#pragma mark - Override

- (NSString *)description {
    // 只打印映射中的属性
    NSString *desc = [NSString stringWithFormat:@"%@:{%@}",[self class], [[self toDictionary] description]];
    return desc;
}

- (id)copyWithZone:(NSZone *)zone {
    id object = [[self class] allocWithZone:zone];
    
    // 只copy映射中的属性
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil || attrMapDic.count == 0) {
        return object;
    }
    
    [attrMapDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
        if ([self p_validatePropertyNamed:propertyName]) {
            id value = [self valueForKey:propertyName];
            [object setValue:value forKey:propertyName];
        }
    }];
    
    return object;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        // 只decode映射中的属性
        NSDictionary *attrMapDic = [self attributeMapDictionary];
        if (attrMapDic == nil || attrMapDic.count == 0) {
            return self;
        }
        
        [attrMapDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
            if ([self p_validatePropertyNamed:propertyName]) {
                id value = [decoder decodeObjectForKey:propertyName];
                [self setValue:value forKey:propertyName];
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // 只encode映射中的属性
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil || attrMapDic.count == 0) {
        return;
    }
    
    [attrMapDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
        if ([self p_validatePropertyNamed:propertyName]) {
            id value = [self valueForKey:propertyName];
            if (value) {
                [encoder encodeObject:value forKey:propertyName];
            }
        }
    }];
}

#pragma mark - Public

- (NSDictionary *)toDictionary {
    // 只转化映射中的属性
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil || attrMapDic.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:attrMapDic.count];
    [attrMapDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
        if ([self p_validatePropertyNamed:propertyName]) {
            id value = [self valueForKey:propertyName];
            value = value?:@"";
            dictionary[propertyName] = value;
        }
    }];
    
    return dictionary;
}

// 验证映射是否正确
- (BOOL)p_validatePropertyNamed:(NSString *)propertyName {
    SEL getSel = NSSelectorFromString(propertyName);
    NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
    if (signature) {
        BOOL available = (strcmp(signature.methodReturnType, @encode(id)) == 0);
        NSAssert(!available, @"'%@' must be an object!", propertyName);
        return available;
    }

    return NO;
}




@end
