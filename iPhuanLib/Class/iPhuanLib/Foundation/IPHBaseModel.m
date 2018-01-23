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
    return nil;
}


- (NSDictionary *)attributeDefaultValueMapDictionary {
    return nil;
}

- (NSArray *)filterStrings{
    // 当值为以下字符串时直接设为nil
    return @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
}

- (NSDictionary *)attributeTypesMapDictionary {
    return nil;
}

- (__kindof IPHBaseModel *)handleAttributeValue:(__kindof IPHBaseModel *)object forAttributeName:(NSString *)attributeName {
    
    // 父类不做任何处理，只返回原始值
    return object;
}

- (void)setup {
    // 父类不做任何处理
}


#pragma mark - init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        [self p_setAttributes:dictionary];
        [self setup];
    }
    return self;
}

- (void)p_setAttributes:(NSDictionary*)dataDictionary {
    if (dataDictionary.count == 0) {
        return;
    }
    
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    NSAssert(attrMapDic.count, @"'%@' must return a available dictionary in 'attributeMapDictionary' protocol method", NSStringFromClass([self class]));

    if (attrMapDic.count == 0) {
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
            
            SEL setSel = [self p_setterSelectorWithPropertyName:propertyName];
            //使用objc_msgSend而不使用setValue是为了保证可以通过重写Set的方法自行给给数组和IPHBaseModel对象处理数据。
            ((void (*)(id, SEL, id))objc_msgSend)(self, setSel, value);
        }
    }];
    
    // 对对象和数组属性单独做数据转化处理
    [self p_setArrayAndObjectAttributes];
}

// 验证映射是否正确
- (BOOL)p_validatePropertyNamed:(NSString *)propertyName {
    SEL getSel = NSSelectorFromString(propertyName);
    NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
    NSAssert(signature, @"'%@' is not a property, check you return dictionary in 'attributeMapDictionary'.", propertyName);
    
    if (signature) {
        BOOL available = (strcmp(signature.methodReturnType, @encode(id)) == 0);
        NSAssert(available, @"'%@' must be an object!", propertyName);
        return available;
    }
    
    return NO;
}

- (void)p_setArrayAndObjectAttributes {
    // 对对象和数组属性单独处理
    NSDictionary *typesDic = [self attributeTypesMapDictionary];
    if (typesDic.count == 0) {
        return;
    }
    
    [typesDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *propertyType, BOOL *stop) {
        // 检查属性名是否正确
        SEL getSel = NSSelectorFromString(propertyName);
        BOOL canResponds = [self respondsToSelector:getSel];
        NSAssert(canResponds, @"'%@' is not a property, check you return dictionary in 'attributeTypesMapDictionary'.", propertyName);
        if (!canResponds) {
            return;
        }
        
        // 检查对象是否为IPHBaseModel的子类
        Class propertyClass = NSClassFromString(propertyType);
        BOOL isSubclass = [propertyClass isSubclassOfClass:[IPHBaseModel class]];
        NSAssert(isSubclass, @"'%@' is not a 'IPHBaseModel' Class, check you return dictionary in 'attributeTypesMapDictionary'.", propertyType);
        if (!isSubclass) {
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
                if (![dic isKindOfClass:[NSDictionary class]]) {
                    *stop = YES;
                }
                
                @autoreleasepool {
                    id model = [[propertyClass alloc] initWithDictionary:dic];
                    model = [self p_handleAttributeValue:model forAttributeName:propertyName];
                    if (model) {
                        [models addObject:model];
                    }
                }
            }];
            
            if (models.count > 0) {
                transformedValue = [models copy];
            }
            
        }else if ([originalValue isKindOfClass:[NSDictionary class]]) {
            transformedValue = [[propertyClass alloc] initWithDictionary:originalValue];
            transformedValue = [self p_handleAttributeValue:transformedValue forAttributeName:propertyName];
        }
        
        if (transformedValue) {
            [self setValue:transformedValue forKey:propertyName];
        }
    }];

}

- (__kindof IPHBaseModel *)p_handleAttributeValue:(__kindof IPHBaseModel *)object forAttributeName:(NSString *)attributeName {
    id returnValue = object;
    id model = [self handleAttributeValue:object forAttributeName:attributeName];
    NSAssert(model, @"The return value of method 'handleAttributeValue:forAttributeName:' cannot be nil");
    
    if (model) {
        returnValue = model;
    }

    return returnValue;
}

#pragma mark - Override

- (NSString *)description {
    NSDictionary *dic = [self p_toDictionaryForDescription:YES];
    if (dic == nil) {
        return [NSString stringWithFormat:@"{%@}", self];
    }
    
    NSString *desc = [dic description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

- (id)copyWithZone:(NSZone *)zone {
    id object = [[self class] allocWithZone:zone];
    if (object == nil) {
        return object;
    }
    
    NSArray *propertyNames = [self p_propertyNames];
    if (propertyNames.count == 0) {
        return object;
    }
    
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger index, BOOL *stop) {
        if ([self p_hasSetterSelectorForPropertyNamed:propertyName]) {
            id value = [self valueForKey:propertyName];
            [object setValue:value forKey:propertyName];
        }
    }];
    
    return object;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        NSArray *propertyNames = [self p_propertyNames];
        if (propertyNames.count == 0) {
            return self;
        }
        
        [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger index, BOOL *stop) {
            if ([self p_hasSetterSelectorForPropertyNamed:propertyName]) {
                id value = [decoder decodeObjectForKey:propertyName];
                [self setValue:value forKey:propertyName];
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSArray *propertyNames = [self p_propertyNames];
    if (propertyNames.count == 0) {
        return;
    }
    
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger index, BOOL *stop) {
        if ([self p_hasSetterSelectorForPropertyNamed:propertyName]) {
            id value = [self valueForKey:propertyName];
            [encoder encodeObject:value forKey:propertyName];
        }
    }];
}

#pragma mark - Public
- (NSDictionary *)toDictionary {
    return [self p_toDictionaryForDescription:NO];
}

- (NSDictionary *)p_toDictionaryForDescription:(BOOL)yesOrNo {
    NSArray *propertyNames = [self p_propertyNames];
    if (propertyNames.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:propertyNames.count];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger index, BOOL *stop) {
        id value = [self valueForKey:propertyName];
        if (value == nil) {
            if (yesOrNo) {
                value = @"nil";
            } else {
                return;
            }
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arrayData = (NSArray *)value;
            NSMutableArray *dataDics = [[NSMutableArray alloc] initWithCapacity:arrayData.count];
            [arrayData enumerateObjectsUsingBlock:^(IPHBaseModel *model, NSUInteger index, BOOL *stop) {
                // 如果数组里面的元素不是IPHBaseModel对象，则停止处理
                if (![model isKindOfClass:[IPHBaseModel class]]) {
                    *stop = YES;
                }
                
                @autoreleasepool {
                    NSDictionary *dataDic = [model toDictionary];
                    if (dataDic) {
                        [dataDics addObject:dataDic];
                    }
                }
            }];
            
            if (dataDics.count > 0) {
                value = [dataDics copy];
            }
            
        }else if ([value isKindOfClass:[IPHBaseModel class]]) {
            value = [value toDictionary];
        }
        
        dictionary[propertyName] = value;

    }];
    
    return dictionary;
}

- (NSDictionary *)toDataDictionary {
    NSDictionary *attributeMapDictionary = [self attributeMapDictionary];
    NSArray *propertyNames = attributeMapDictionary.allKeys;
    if (propertyNames.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:propertyNames.count];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger index, BOOL *stop) {
        id value = [self valueForKey:propertyName];
        if (value == nil) {
            return;
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arrayData = (NSArray *)value;
            NSMutableArray *dataDics = [[NSMutableArray alloc] initWithCapacity:arrayData.count];
            [arrayData enumerateObjectsUsingBlock:^(IPHBaseModel *model, NSUInteger index, BOOL *stop) {
                // 如果数组里面的元素不是IPHBaseModel对象，则停止处理
                if (![model isKindOfClass:[IPHBaseModel class]]) {
                    *stop = YES;
                }
                
                @autoreleasepool {
                    NSDictionary *dataDic = [model toDataDictionary];
                    if (dataDic) {
                        [dataDics addObject:dataDic];
                    }
                }
            }];
            
            if (dataDics.count > 0) {
                value = [dataDics copy];
            }
            
        }else if ([value isKindOfClass:[IPHBaseModel class]]) {
            value = [value toDataDictionary];
        }
        
        NSString *key = attributeMapDictionary[propertyName];
        dictionary[key] = value;
        
    }];
    
    return dictionary;
}



- (NSData *)archivedData{
    if (self) {
        return [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    return nil;
}


#pragma mark - Private

- (NSArray *)p_propertyNames {
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    Class class = self.class;
    while (class != [NSObject class]) {
        [propertyNames addObjectsFromArray:[self p_propertyNamesForClass:class]];
        class = [class superclass];
    }
    
    return [propertyNames copy];
    
}

- (NSArray *)p_propertyNamesForClass:(Class)class {
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        
        const char * attributes = property_getAttributes(property);
        NSString *propertyAttributes = [NSString stringWithUTF8String:attributes];
        
        // weak类型属性不进行解析，防止死循环的出现
        if (![propertyAttributes containsString:@"W"]) {
            [propertyNames addObject:propertyName];
        }
    }
    free(properties);
    return propertyNames;
}


- (BOOL)p_hasSetterSelectorForPropertyNamed:(NSString*)propertyName {
    SEL sel = [self p_setterSelectorWithPropertyName:propertyName];
    return [self respondsToSelector:sel];
}

- (SEL)p_setterSelectorWithPropertyName:(NSString*)propertyName {
    NSString *capital = [[propertyName substringToIndex:1] uppercaseString];
    NSString *setSel = [NSString stringWithFormat:@"set%@%@:", capital, [propertyName substringFromIndex:1]];
    return NSSelectorFromString(setSel);
}

@end
