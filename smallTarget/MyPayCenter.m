//
//  MyPayCenter.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/21.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "MyPayCenter.h"

@implementation MyPayCenter

+ (MyPayCenter *)defaultPayCenter {
    static MyPayCenter *_payCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payCenter = [[self alloc] init];
    });
    return _payCenter;
}

@end
