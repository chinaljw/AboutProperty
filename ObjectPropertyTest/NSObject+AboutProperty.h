//
//  NSObject+AboutProperty.h
//  ObjectPropertyTest
//
//  Created by ljw on 15/9/12.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define LOG_UNDEFINE_VALUE

@class ObjectPropertyInfo;
@interface NSObject (AboutProperty)

- (NSArray *)superClassChain;

- (NSArray *)superClassChainWithoutNSObjcet;

- (NSArray *)selfPropertyList;

- (NSArray *)propertyListIncludeSuperClassAndWithOutNSObject;

- (NSDictionary *)selfKeyValues;

- (NSDictionary *)selfKeyValues_removeNilObject;

- (NSDictionary *)keyValuesIncludeSuperClassAndWithOutNSObject;

- (NSDictionary *)keyValuesIncludeSuperClassAndWithOutNSObject_removeNilObject;

@end

@interface ObjectPropertyInfo : NSObject

@property (nonatomic, copy) NSString *propertyName;

@property (nonatomic, copy) NSString *propertyType;

@property (nonatomic, copy) NSString *propertyType_Full;

@end
