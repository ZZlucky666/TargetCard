//
//  TargetModel.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/1.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "TargetModel.h"

@implementation TargetModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeBool:self.isRetain forKey:@"isRetain"];
    [aCoder encodeInteger:self.retainTime forKey:@"retainTime"];
    [aCoder encodeBool:self.isDeadline forKey:@"isDeadline"];
    [aCoder encodeObject:self.deadlineTime forKey:@"deadlineTime"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.isRetain = [aDecoder decodeBoolForKey:@"isRetain"];
        self.retainTime = [aDecoder decodeIntegerForKey:@"retainTime"];
        self.isDeadline = [aDecoder decodeBoolForKey:@"isDeadline"];
        self.deadlineTime = [aDecoder decodeObjectForKey:@"deadlineTime"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"title = %@,isRetain = %d,retainTime = %ld,isDeadline = %d,deadlineTime = %@,startTime = %@",self.title,self.isRetain,self.retainTime,self.isDeadline,self.deadlineTime,self.startTime];
}

@end

