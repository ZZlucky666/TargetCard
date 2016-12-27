//
//  ZTDBManager.h
//  smallTarget
//
//  Created by Jack Zeng on 16/11/8.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ZTDBManager : NSObject

/// 单例 - 全局访问点
+ (instancetype)sharedManager;

/// 管理对象的上下文
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/// 保存上下文
///
/// @return 是否成功
- (BOOL)saveContext;

@property (nonatomic, strong) NSDateFormatter *dataFormant;

@end
