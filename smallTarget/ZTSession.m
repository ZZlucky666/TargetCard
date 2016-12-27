//
//  ZTSession.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/1.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "ZTSession.h"

@implementation ZTSession

//+ (instancetype)sharedSession {
//    static ZTSession *_session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _session = [[self alloc] init];
//    });
//    
//    return _session;
//}

- (instancetype) init {
    if (self = [super init]) {
        //创建文件夹
        [self createFolder];
    }
    return self;
}

#pragma mark - Getter Function
//沙盒目录
-(NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
}

//沙盒目录下的存储目录，文件夹名可以随便取
- (NSString *)documentAchiverPath {
    return [self.documentPath stringByAppendingPathComponent:@"Achiver"];
}

#pragma mark - CreateFolder
- (void)createFolder {
    //拼接路径
    NSString * path = [self documentAchiverPath];
    
    BOOL isDirectory;
    
    //查找是否存在这个文件夹,isDirectory用来判断是文件夹还是文件，如果路径不存在，返回为undefined，表示不能确定
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        //存在这个文件夹
        return;//不做操作
    } else {
        //不存在创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
}

#pragma mark - 存储-获取单个数据
-(void)storgaeObject:(TargetModel * _Nonnull)messageObject {
    //拼接路径，格式随意
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObject.achiver"];
    
    //开始编码存数据
    [NSKeyedArchiver archiveRootObject:messageObject toFile:path];
}


-(TargetModel * _Nullable)readMessageObject {
    //拼接路径
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObject.achiver"];
    
    //开始解码获取
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)addModel:(TargetModel *)model {
    NSMutableArray *objects =  [NSMutableArray arrayWithArray:[self readMessageObjects]];
    [objects addObject:model];
    [self storgaeObjects:objects];
}


#pragma mark - 存储-获取数组数据
- (void)storgaeObjects:(NSMutableArray<TargetModel *> * _Nonnull)messageObjects {
    //拼接路径
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObjects.achiver"];
    
    //开始编码存数据
    [NSKeyedArchiver archiveRootObject:messageObjects toFile:path];
}

- (NSMutableArray<TargetModel *> * _Nullable)readMessageObjects {
    //拼接路径
    NSString * path = [[self documentAchiverPath] stringByAppendingPathComponent:@"messageObjects.achiver"];
    
    //开始解码获取
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (NSMutableArray *)getToDoModels {
    NSMutableArray *totalModels;
    if ([self readMessageObjects] && [self readMessageObjects].count > 0) {
        totalModels = [self readMessageObjects];
    } else {
        totalModels = [NSMutableArray arrayWithCapacity:0];
    }
    NSMutableArray *toDoModels = totalModels.copy;
    if (totalModels && totalModels.count > 0) {
        for (TargetModel *model in totalModels) {
            NSDate *now = [NSDate date];
            NSDate *deadlineDate = model.deadlineTime;
            NSTimeInterval timeBetween = [now timeIntervalSinceDate:deadlineDate];
            if (timeBetween > 0) {
                [toDoModels removeObject:model];
                continue;
            }
        }
        return toDoModels;
    } else {
        return [NSMutableArray arrayWithCapacity:0];
    }
}


@end
