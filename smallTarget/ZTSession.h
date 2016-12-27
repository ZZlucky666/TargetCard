//
//  ZTSession.h
//  smallTarget
//
//  Created by Jack Zeng on 16/11/1.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TargetModel.h"

@interface ZTSession : NSObject

//+ (instancetype)sharedSession;

- (void)addModel:(TargetModel *)model;
- (NSMutableArray *)getToDoModels;

/*
 *  存数据
 */
- (void)storgaeObject:(TargetModel * _Nonnull)messageObject;
- (void)storgaeObjects:(NSMutableArray <TargetModel *> * _Nonnull)messageObjects;

/*
 *  获取数据
 */
- (TargetModel * _Nullable )readMessageObject;
- (NSMutableArray<TargetModel *> * _Nullable )readMessageObjects;

@end
