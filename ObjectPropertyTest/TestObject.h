//
//  TestObject.h
//  ObjectPropertyTest
//
//  Created by ljw on 15/9/12.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Sub_4_Class;
@interface TestObject : NSObject

@property (nonatomic, strong) NSString *string;

@property (nonatomic, strong) NSNumber *number;

@property (nonatomic, strong) NSValue *vlaue;

@property (nonatomic, strong) NSMutableArray *mArray;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong) NSMutableDictionary *mDictionary;

@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) NSMutableData *mData;

@property (nonatomic, strong) NSObject *object;

//
@property (nonatomic, assign) CGFloat cgfloat;

@property (nonatomic, assign) NSInteger nsinteger2;

@property (nonatomic, assign) int **intProperty;

@property (nonatomic, assign) float floatProperty;

@property (nonatomic, assign) long long llll;

@property (nonatomic, assign) long l;

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) short shortProperty;

@property (nonatomic, assign) char charProperty;

//
@property (nonatomic, strong) Sub_4_Class *sub_4;

@property (nonatomic, weak) id delegate;

@end
