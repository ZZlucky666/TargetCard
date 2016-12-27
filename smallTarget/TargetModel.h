//
//  TargetModel.h
//  smallTarget
//
//  Created by Jack Zeng on 16/11/1.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isRetain;
@property (nonatomic, assign) NSInteger retainTime;
@property (nonatomic, assign) BOOL isDeadline;
@property (nonatomic, strong) NSDate *deadlineTime;
@property (nonatomic, strong) NSDate *startTime;

@end
