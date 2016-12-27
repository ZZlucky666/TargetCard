//
//  ZTDBManager.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/8.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "ZTDBManager.h"

/// 数据模型常量
static NSString *const modelName = @"FristTargetModel";
/// 数据库名称常量
static NSString *const dbName = @"new.db";

@implementation ZTDBManager

@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - 单例 & 构造函数
static id instance;

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSDateFormatter *)dataFormant {
    if (_dataFormant == nil) {
        _dataFormant = [[NSDateFormatter alloc] init];
    }
    return _dataFormant;
}

#pragma mark - Core Data 设置方法
- (NSManagedObjectContext *)managedObjectContext {
    
    // 返回已经绑定到`持久化存储调度器`的管理对象上下文
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // 数据模型的 URL
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    // 从 Bundle 加载对象模型
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    // 指定保存在磁盘的数据库文件 URL
    NSURL *applicationURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationURL URLByAppendingPathComponent:dbName];
    
    if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:NULL] == nil) {
        NSLog(@"创建数据库错误");
        return nil;
    }
    
    // 创建管理对象上下文，并且指定并发类型
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 设置管理上下文的存储调度器
    [_managedObjectContext setPersistentStoreCoordinator:psc];
    
    return _managedObjectContext;
}

#pragma mark - 保存上下文操作
/// 保存上下文
- (BOOL)saveContext {
    
    // 如果上下文没有创建直接返回
    if (self.managedObjectContext == nil) {
        NSLog(@"管理上下文为 nil");
        return NO;
    }
    
    // 判断是否有数据修改
    if (!self.managedObjectContext.hasChanges) {
        NSLog(@"没有数据需要修改");
        return YES;
    }
    
    NSError *error = nil;
    BOOL result = [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"数据操作错误 %@", error);
    }
    return result;
}

@end
