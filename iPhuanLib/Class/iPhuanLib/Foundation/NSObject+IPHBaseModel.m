//
//  NSObject+IPHBaseModel.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/13.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "NSObject+IPHBaseModel.h"
#import <objc/message.h>


@implementation NSObject (IPHBaseModel)

#pragma mark - init

+ (instancetype)iph_objectWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithIphDictionary:dictionary];
}

- (instancetype)initWithIphDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        [self p_setAttributes:dictionary];
        if ([self respondsToSelector:@selector(setup)]) {
            [(id)self setup];
        }
    }
    return self;
}

- (void)p_setAttributes:(NSDictionary*)dictionary {
    if (dictionary.count == 0) {
        return;
    }
    
    BOOL conformsToProtocol = [self conformsToProtocol:@protocol(IPHBaseModelProtocal)];
    NSAssert(conformsToProtocol, @"'%@' must follow the 'IPHBaseModelProtocal' protocol", NSStringFromClass([self class]));
    if (!conformsToProtocol) {
        return;
    }
    
    BOOL canInit = [self respondsToSelector:@selector(attributeMapDictionary)];
    NSAssert(canInit, @"'%@' must implement the 'attributeMapDictionary' protocol method", NSStringFromClass([self class]));
    if (!canInit) {
        return;
    }
    
    NSDictionary *attrMapDic = [(id)self attributeMapDictionary];
    NSAssert(attrMapDic.count, @"'%@' must return a available dictionary in 'attributeMapDictionary' protocol method", NSStringFromClass([self class]));

    if (attrMapDic.count == 0) {
        return;
    }
    
    NSDictionary *defaultValueDic = nil;
    if ([self respondsToSelector:@selector(attributeDefaultValueMapDictionary)]) {
        defaultValueDic = [(id)self attributeDefaultValueMapDictionary];
    }
    BOOL needSetDefaultValue = defaultValueDic?YES:NO;
    
    [attrMapDic enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *dataDicKey, BOOL *stop) {
        if ([self p_validatePropertyNamed:propertyName]) {
            id value = dictionary[dataDicKey];
            if ([value isKindOfClass:[NSNull class]]) {
                value = nil;
            }else if ([value isKindOfClass:[NSNumber class]]) {
                value = ((NSNumber *)value).stringValue;
            }else if ([value isKindOfClass:[NSString class]]) {
                NSArray *filterStrings = [self p_defaulFilterStrings];
                if ([self respondsToSelector:@selector(filterStrings)]) {
                    filterStrings = [(id)self filterStrings];
                }
                
                if ([filterStrings containsObject:value]) {
                    value = nil;
                }
            }
            
            // 设置默认值
            if (needSetDefaultValue && value == nil) {
                value = defaultValueDic[propertyName];
            }
            
            SEL setSel = [self p_setterSelectorWithPropertyName:propertyName];
            //使用objc_msgSend而不使用setValue是为了保证可以通过重写Set的方法自行给给数组和IPHBaseModelProtocal协议对象处理数据。
            ((void (*)(id, SEL, id))objc_msgSend)(self, setSel, value);
        }
    }];
    
    // 对对象和数组属性单独做数据转化处理
    [self p_setArrayAndObjectAttributes];
}


- (NSArray *)p_defaulFilterStrings{
    // 当值为以下字符串时直接设为nil
    return @[@"NIL", @"Nil", @"nil", @"NULL", @"Null", @"null", @"(NULL)", @"(Null)", @"(null)", @"<NULL>", @"<Null>", @"<null>"];
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
    NSDictionary *typesDic = nil;
    if ([self respondsToSelector:@selector(attributeTypesMapDictionary)]) {
        typesDic = [(id)self attributeTypesMapDictionary];
    }

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
        
        // 检查对象是否遵循IPHBaseModelProtocal协议
        Class propertyClass = NSClassFromString(propertyType);
        BOOL isConforms = [propertyClass conformsToProtocol:@protocol(IPHBaseModelProtocal)];
        NSAssert(isConforms, @"'%@' is not a class that follows the 'IPHBaseModelProtocal' protocol, check you return dictionary in 'attributeTypesMapDictionary'.", propertyType);
        if (!isConforms) {
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
                    id model = [[propertyClass alloc] initWithIphDictionary:dic];
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
            transformedValue = [[propertyClass alloc] initWithIphDictionary:originalValue];
            transformedValue = [self p_handleAttributeValue:transformedValue forAttributeName:propertyName];

        }
        
        if (transformedValue) {
            [self setValue:transformedValue forKey:propertyName];
        }
    }];
    
}

- (id <IPHBaseModelProtocal>)p_handleAttributeValue:(id <IPHBaseModelProtocal>)object forAttributeName:(nonnull NSString *)attributeName {
    id returnValue = object;
    BOOL canHandleAttributeValue = [self respondsToSelector:@selector(handleAttributeValue:forAttributeName:)];
    if (canHandleAttributeValue) {
        id model = [(id)self handleAttributeValue:returnValue forAttributeName:attributeName];
        NSAssert(model, @"The return value of protocal method 'handleAttributeValue:forAttributeName:' cannot be nil");

        if (model) {
            returnValue = model;
        }
    }
    
    return returnValue;
}


#pragma mark - Public

- (NSDictionary *)iph_toDictionary {
    return [self p_toDictionaryForDescription:NO];
}

- (NSDictionary *)p_toDictionaryForDescription:(BOOL)yesOrNo {
    // 如果对象不遵循IPHBaseModelProtocal协议，则不转化
    if (![self conformsToProtocol:@protocol(IPHBaseModelProtocal)]) {
        return nil;
    }
    
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
            [arrayData enumerateObjectsUsingBlock:^(id model, NSUInteger index, BOOL *stop) {
                // 如果数组里面的对象不遵循IPHBaseModelProtocal协议，则停止处理
                if (![model conformsToProtocol:@protocol(IPHBaseModelProtocal)]) {
                    *stop = YES;
                }
                
                @autoreleasepool {
                    NSDictionary *dataDic = [model iph_toDictionary];
                    if (dataDic) {
                        [dataDics addObject:dataDic];
                    }
                }
            }];
            
            if (dataDics.count > 0) {
                value = [dataDics copy];
            }
            
        }else if ([value conformsToProtocol:@protocol(IPHBaseModelProtocal)]) {
            value = [value iph_toDictionary];
        }
        
        dictionary[propertyName] = value;
        
    }];
    
    return dictionary;
}

- (NSDictionary *)iph_toDataDictionary {
    // 如果对象不遵循HHTBaseModelProtocal协议，则不转化
    if (![self conformsToProtocol:@protocol(IPHBaseModelProtocal)]) {
        return nil;
    }
    
    NSDictionary *attributeMapDictionary = [(id)self attributeMapDictionary];
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
            [arrayData enumerateObjectsUsingBlock:^(id model, NSUInteger index, BOOL *stop) {
                // 如果数组里面的对象不遵循HHTBaseModelProtocal协议，则停止处理
                if (![model conformsToProtocol:@protocol(IPHBaseModelProtocal)]) {
                    *stop = YES;
                }
                
                @autoreleasepool {
                    NSDictionary *dataDic = [model iph_toDataDictionary];
                    if (dataDic) {
                        [dataDics addObject:dataDic];
                    }
                }
            }];
            
            if (dataDics.count > 0) {
                value = [dataDics copy];
            }
            
        }else if ([value conformsToProtocol:@protocol(IPHBaseModelProtocal)]) {
            value = [value iph_toDataDictionary];
        }
        
        NSString *key = attributeMapDictionary[propertyName];
        dictionary[key] = value;
        
    }];
    
    return dictionary;
}


- (NSString *)iph_description {
    NSDictionary *dic = [self p_toDictionaryForDescription:YES];
    if (dic == nil) {
        return [NSString stringWithFormat:@"{%@}", self];
    }
    
    NSString *desc = [dic description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

- (NSData *)iph_archivedData {
    if (self) {
        return [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    return nil;
}

- (id)iph_copyWithZone:(NSZone *)zone {
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
- (void)iph_decodeWithCoder:(NSCoder *)decoder {
    NSArray *propertyNames = [self p_propertyNames];
    if (propertyNames.count == 0) {
        return;
    }
    
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger index, BOOL *stop) {
        if ([self p_hasSetterSelectorForPropertyNamed:propertyName]) {
            id value = [decoder decodeObjectForKey:propertyName];
            [self setValue:value forKey:propertyName];
        }
    }];
}
- (void)iph_encodeWithCoder:(NSCoder *)encoder {
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
        
        // 因为对象遵循IPHBaseModelProtocal协议即遵循了NSObject协议，所以会自动添加几个NSObject协议的属性；weak类型属性不进行解析，防止死循环的出现
        if (![[self p_NSObjectPropertyNames] containsObject:propertyName] && ![propertyAttributes containsString:@"W"]) {
            [propertyNames addObject:propertyName];
        }
        
    }
    free(properties);
    return propertyNames;
}



- (NSArray *)p_NSObjectPropertyNames {
    static NSArray *NSObjectPropertyNames = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
        unsigned int propertyCount = 0;
        objc_property_t *properties = protocol_copyPropertyList(@protocol(NSObject), &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char * name = property_getName(property);
            [propertyNames addObject:[NSString stringWithUTF8String:name]];
        }
        free(properties);
        NSObjectPropertyNames =  [propertyNames copy];
    });
    
    return NSObjectPropertyNames;
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
