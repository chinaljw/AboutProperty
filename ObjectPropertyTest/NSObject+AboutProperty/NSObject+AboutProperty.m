//
//  NSObject+AboutProperty.m
//  ObjectPropertyTest
//
//  Created by ljw on 15/9/12.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "NSObject+AboutProperty.h"
#import <objc/runtime.h>

#pragma mark - Categroy
@implementation NSObject (AboutProperty)

#pragma mark - MethodSwizzling
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSEL = @selector(valueForUndefinedKey:);
        SEL newSEL = @selector(ljw_AboutProperty_valueForUndefinedKey:);
        
        Method originMethod = class_getInstanceMethod(self.class, originSEL);
        Method newMethod = class_getInstanceMethod(self.class, newSEL);
        
        //
        if (class_addMethod(self.class, originSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self.class, newSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
        else
        {
            method_exchangeImplementations(originMethod, newMethod);
        }
        
    });
}

- (id)ljw_AboutProperty_valueForUndefinedKey:(NSString *)key
{
#ifdef LOG_UNDEFINE_VALUE
    NSLog(@"undefine key : %@", key);
    NSError *error = [NSError errorWithDomain:@"无法获取该属性的值!" code:8008208820 userInfo:@{@"你问我该怎么办":@"我也不知道"}];
    NSLog(@"%@", error);
#endif
    return nil;
}

#pragma mark - Usefull
- (NSArray *)superClassChain
{
    return [self getClassSuperClassChain:self.class];
}

- (NSArray *)superClassChainWithoutNSObjcet
{
    NSArray *fullChain = [self superClassChain];
    
    return [fullChain objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, fullChain.count - 1)]];
}

- (NSArray *)selfPropertyList
{
    return [self getClassPropertyInfos:self.class];
}

- (NSArray *)propertyListIncludeSuperClassAndWithOutNSObject
{
    NSMutableArray *propertyList = [[NSMutableArray alloc] initWithArray:[self selfPropertyList]];
    
    NSArray *superClassChain = [self superClassChainWithoutNSObjcet];
    
    for (Class class in superClassChain) {
        [propertyList addObjectsFromArray:[self getClassPropertyInfos:class]];
    }
    
    return propertyList;
}

- (NSDictionary *)selfKeyValues
{
    return [self keyValuesWithPropertyList:[self selfPropertyList] shouldAddNilProperty:YES];
}

- (NSDictionary *)selfKeyValues_removeNilObject
{
    return [self keyValuesWithPropertyList:[self selfPropertyList] shouldAddNilProperty:NO];
}

- (NSDictionary *)keyValuesIncludeSuperClassAndWithOutNSObject
{
    return [self keyValuesWithPropertyList:[self propertyListIncludeSuperClassAndWithOutNSObject] shouldAddNilProperty:YES];
    
}

- (NSDictionary *)keyValuesIncludeSuperClassAndWithOutNSObject_removeNilObject
{
    return [self keyValuesWithPropertyList:[self propertyListIncludeSuperClassAndWithOutNSObject] shouldAddNilProperty:NO];
}

#pragma mark - Helper
- (NSArray *)getClassSuperClassChain:(Class)class
{
    Class superClass = class_getSuperclass(class);
    if (!superClass) {
        return nil;
    }
    else
    {
        NSMutableArray *list = [[NSMutableArray alloc] initWithArray:[self getClassSuperClassChain:superClass]];
        [list addObject:superClass];
        
        return list;
    }
}

- (NSArray *)getClassPropertyInfos:(Class)class
{
    
    unsigned int outCount = 0;

    objc_property_t *propertyList = class_copyPropertyList(class, &outCount);
    
    if (propertyList) {
        
        NSMutableArray *propertyInfoArray = [[NSMutableArray alloc] init];
        
        for (long i = 0; i < outCount; i ++) {
            
            ObjectPropertyInfo *info = [[ObjectPropertyInfo alloc] init];
            
            objc_property_t property = propertyList[i];
            
            info.propertyName = [NSString stringWithUTF8String:property_getName(property)];

            info.propertyType_Full = [NSString stringWithUTF8String:property_getAttributes(property)];
            
            info.propertyType = [self getShortPropertyTypeFromFullPropertyType:info.propertyType_Full];
            
            [propertyInfoArray addObject:info];

        }
        
        free(propertyList);
        
        return propertyInfoArray;
        
    }
    else
    {
        return nil;
    }
}

- (NSString *)getShortPropertyTypeFromFullPropertyType:(NSString *)fullPropertyType
{

    if ([fullPropertyType rangeOfString:@"T@"].location != NSNotFound) {
        NSArray *component = [fullPropertyType componentsSeparatedByString:@"\""];
        if (component.count == 1) {
            return @"id";
        }
        return component[1];
    }
    else
    {
        //基本数据类型键值对可以自己添加,不过感觉也差不多了。。。
        static NSDictionary *baseDataTypeKeyValues = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            baseDataTypeKeyValues = @{
                                      @"q":@"NSInteger",
                                      @"i":@"int",
                                      @"d":@"double",
                                      @"b":@"bool",
                                      @"B":@"BOOL",
                                      @"s":@"short",
                                      @"c":@"char",
                                      @"f":@"float",
                                      };

        });
        
        NSString *originTypeString = [fullPropertyType componentsSeparatedByString:@","].firstObject;
        
        NSString *typeKey = [NSString stringWithFormat:@"%c", [originTypeString characterAtIndex:originTypeString.length - 1]];
        
        NSString *typeValue = baseDataTypeKeyValues[typeKey];
        
        if (!typeValue) {
            return originTypeString;
        }
        
        if (originTypeString.length == 2) {
            return typeValue;
        }
        else if (originTypeString.length > 2)
        {
            NSString *pointerString = [originTypeString substringWithRange:NSMakeRange(1, originTypeString.length - 2)];
            pointerString = [pointerString stringByReplacingOccurrencesOfString:@"^" withString:@"*"];
            return [pointerString stringByAppendingString:typeValue];
        }
        else
        {
            return originTypeString;
        }
    }
}

- (NSMutableDictionary *)keyValuesWithPropertyList:(NSArray *)propertyList shouldAddNilProperty:(BOOL)should
{
    NSMutableDictionary *keyValues = [[NSMutableDictionary alloc] init];
    
    for (ObjectPropertyInfo *info in propertyList) {
        NSString *key = info.propertyName;
        id value = [self valueForKeyPath:key];
        value = value ? value : should ? [NSNull null] : nil;
        [keyValues setValue:value forKey:key];
    }
    
    return keyValues;
}

@end


#pragma mark - ObjectPropertyInfo
@implementation ObjectPropertyInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectPropertyInfoDescription : name = %@, type = %@ fullType = %@", self.propertyName, self.propertyType, self.propertyType_Full];
}

@end

