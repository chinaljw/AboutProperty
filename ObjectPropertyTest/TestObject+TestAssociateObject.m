//
//  TestObject+(TestAssociateObject).m
//  ObjectPropertyTest
//
//  Created by ljw on 15/9/13.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "TestObject+TestAssociateObject.h"

@implementation TestObject (TestAssociateObject)

- (void)setTestAssociateObject:(NSString *)testAssociateObject
{
    objc_setAssociatedObject(self, @selector(testAssociateObject), testAssociateObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)testAssociateObject
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
