//
//  ViewController.m
//  ObjectPropertyTest
//
//  Created by ljw on 15/9/12.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"
#import "TestObjectSubClass.h"
#import "NSObject+AboutProperty.h"
#import "Sub_4_Class.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TestObject *testObject = [[TestObject alloc] init];
//    [testObject test];
    testObject.cgfloat = 12.f;
//    NSLog(@"%@", [testObject valueForKey:@"intProperty"]);
    
//    TestObjectSubClass *subObject = [[TestObjectSubClass alloc] init];
//    [subObject test];
//    
    Sub_4_Class *sub_4_Object = [[Sub_4_Class alloc] init];
//    [sub_4_Object test];
    
    testObject.sub_4 = sub_4_Object;
    
    NSLog(@"%@", sub_4_Object.keyValuesIncludeSuperClassAndWithOutNSObject);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
