//
//  MainViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/9/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//


#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "AddViewController.h"
#import "TargetModel.h"
#import "JXMovableCellTableView.h"
#import "ZTDBManager.h"
#import "FristModel+CoreDataClass.h"
#import "SecondModel+CoreDataClass.h"
#import "TargetDetailViewController.h"

@interface MainViewController ()<JXMovableCellTableViewDataSource, JXMovableCellTableViewDelegate, UITableViewCellSlideDelegate>
@property (nonatomic, strong) JXMovableCellTableView *mainTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSMutableArray *toDoModels;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *recordDict;

/// 查询结果控制器
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"recordDict"]) {
        self.recordDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"recordDict"];
    } else {
        self.recordDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDataList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
    if (self.recordDict.count > 0) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:self.recordDict forKey:@"recordDict"];
        [userDef synchronize];
    }
}

-(void)dealloc {
    _mainTableView.delegate = nil;
    _mainTableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self stopTimer];
}

//-(void)setupNotification {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
//}

- (void)setUpUI {
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    [self.tabBarController.tabBar setClipsToBounds:YES];
    self.mainTableView = [[JXMovableCellTableView alloc] initWithFrame:CGRectMake(15,0,SCREEN_WIDTH - 30,SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.clipsToBounds = NO;
    self.mainTableView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.tableHeaderView = self.headView;
    self.mainTableView.tableHeaderView.frame = CGRectMake(0,0,SCREEN_WIDTH,117);
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRectMake(0,0,SCREEN_WIDTH,0.1))];
    self.mainTableView.tableFooterView.clipsToBounds = YES;
    self.mainTableView.showsVerticalScrollIndicator = NO;
//    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.mainTableView.gestureMinimumPressDuration = 0.8;
    self.mainTableView.drawMovalbeCellBlock = ^(UIView *movableCell){
        movableCell.layer.shadowColor = [UIColor grayColor].CGColor;
        movableCell.layer.masksToBounds = YES;
        movableCell.layer.cornerRadius = 7.5;
        movableCell.layer.shadowOffset = CGSizeMake(-5, 0);
        movableCell.layer.shadowOpacity = 0.4;
        movableCell.layer.shadowRadius = 5;
    };
}

- (UIView *)headView {
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,117)];
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 100, 20)];
        self.dateLabel.textColor = UIColorFromRGB(0x919191);
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        self.formatterDate.dateFormat = @"MM月dd日";
        self.dateLabel.text = [self.formatterDate stringFromDate:[NSDate date]];
        [_headView addSubview:self.dateLabel];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, 146, 50)];
        titleLabel.textColor = UIColorFromRGB(0x121B26);
        titleLabel.font = [UIFont systemFontOfSize:36];
        titleLabel.text = @"今日目标";
        [_headView addSubview:titleLabel];
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectMake(SCREEN_WIDTH - 51 - 15, 40, 36, 36);
        [self.addBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(didClickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:self.addBtn];
    }
    return _headView;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 117 - 64)];
        UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_all_none"]];
        backImageView.frame = CGRectMake(33, 42, SCREEN_WIDTH - 96, (SCREEN_WIDTH - 96) * 374/575);
        UILabel *backLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 42 + (SCREEN_WIDTH - 96) * 374/575 + 39, SCREEN_WIDTH - 30, 30)];
        backLable.text = @"今日没有计划，快去添加吧 ";
        backLable.font = [UIFont systemFontOfSize:21];
        backLable.textAlignment = NSTextAlignmentCenter;
        backLable.textColor = UIColorFromRGB(0xCBCBCCB);
        [_backView addSubview:backImageView];
        [_backView addSubview:backLable];
    }
    return _backView;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    
    /// 1. 查询请求 - 参数是实体名称，查询哪一个数据表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FristModel"];
    
    // 1> 指定排序
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort1];
//
    // 2> 设置查询的结果的条数
//    fetchRequest.fetchLimit = 10;
    
    /**
     1. 查询请求
     2. 上下文
     3. 分组名称
     4. 缓存名称
     */
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ZTDBManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}

- (void)refreshDataList {
    [self.fetchedResultsController performFetch:NULL];
    [self.dataArray removeAllObjects];
    NSDate *now = [NSDate date];
    for (FristModel *model in self.fetchedResultsController.fetchedObjects) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSDate *deadlineDate = model.deadlineTime;
        NSDate *startDate = model.startTime;
        int deadlineSecond;
        if (model.isFinished || model.isgiveup) {
            continue;
        } else {
            if ([model.deadlineTime timeIntervalSinceNow] <= 0) {
                NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",model.keyNumber];
                NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
                NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
                NSFetchRequest * request1 = [NSFetchRequest new];
                request1.entity = des1;
                request1.predicate = pre;
                
                NSArray * array = [context executeFetchRequest:request1 error:NULL];
                for (FristModel *model in array) {
                    model.isgiveup = YES;
                    [context updatedObjects];
                }
                
                SecondModel *secondModel = [NSEntityDescription insertNewObjectForEntityForName:@"SecondModel" inManagedObjectContext:[ZTDBManager sharedManager].managedObjectContext];
                secondModel.title = model.title;
                secondModel.keyNumber = model.keyNumber;
                secondModel.status = @"未完成";
                secondModel.currentDate = model.deadlineTime;
                [[ZTDBManager sharedManager] saveContext];
                [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%d", model.keyNumber]];
                continue;
            } else {
                if (model.isRetain) {
                    if (model.clickTime) {
                        int total =  (int)[now timeIntervalSinceDate:model.clickTime] + (int)[model.clickTime timeIntervalSinceDate:startDate] % (model.retainTime*24*60*60);
                        if (total < model.retainTime*24*60*60) {
                            continue;
                        }
                    }
                    
                    if ((int)[now timeIntervalSinceDate:startDate] > 0) {
                        deadlineSecond = (model.retainTime*24*60*60) - (int)[now timeIntervalSinceDate:startDate] % (model.retainTime*24*60*60);
                        if ((int)[deadlineDate timeIntervalSinceDate:now] < deadlineSecond) {
                            deadlineSecond = (int)[deadlineDate timeIntervalSinceDate:now];
                        }
                    } else {
                        deadlineSecond = (int)[startDate timeIntervalSinceDate:now] + model.retainTime*24*60*60;
                    }
                } else {
                    deadlineSecond = (int)[deadlineDate timeIntervalSinceDate:now];
                }
                [dict setObject:[NSString stringWithFormat:@"%d", deadlineSecond] forKey:@"deadlineSecond"];
                [dict setObject:model.title forKey:@"title"];
                [dict setObject:model forKey:@"model"];
                [dict setObject:[NSNumber numberWithInteger:self.dataArray.count] forKey:@"colorNum"];
                [self.dataArray addObject:dict];
            }
        }
    }
    if (self.dataArray.count > 0) {
        if (self.recordDict.count > 0) {
            for (int i = 0; i < self.recordDict.allKeys.count; i ++) {
                NSString *key = self.recordDict.allKeys[i];
                for (int j = 0; j < self.dataArray.count; j ++) {
                    NSDictionary *dict = self.dataArray[j];
                    FristModel *model = [dict objectForKey:@"model"];
                    if ([[NSString stringWithFormat:@"%d",model.keyNumber] isEqualToString:[NSString stringWithFormat:@"%d",key.intValue]]) {
                        NSString *num = [self.recordDict valueForKey:key];
                        if (num.integerValue < self.dataArray.count) {
                            [self.dataArray exchangeObjectAtIndex:j withObjectAtIndex:num.integerValue];
                        }
                    }
                }
            }
        }
        self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.mainTableView reloadData];
        [self startTimer];
    } else {
        [self.mainTableView reloadData];
        self.mainTableView.tableFooterView = self.backView;
    }
}

// 设置本地通知
- (void)registerLocalNotification:(NSDate *)alertDate repeat:(BOOL)repeat title:(NSString *)title andKey:(NSString *)key {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    notification.fireDate = alertDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 通知内容
    notification.alertBody =  [NSString stringWithFormat:@"您有一个目标需要完成:%@", title];
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:key forKey:@"key"];
    notification.userInfo = userDict;
    if (repeat) {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = [userInfo valueForKey:@"key"];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil && [info isEqualToString:key]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

- (void)startTimer {
    if (self.countDownTimer == nil) {
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:UITrackingRunLoopMode];
    }
}

- (void)stopTimer {
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

- (void)refreshLessTime {
    NSUInteger time;
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dict = [self.dataArray objectAtIndex:i];
        NSString *deadlineSecond = [dict objectForKey:@"deadlineSecond"];
        time = [deadlineSecond integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        MainTableViewCell *cell = (MainTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
        [cell.countDownView setTimeFromTimeInterval:--time];
        [dict setValue:[NSString stringWithFormat:@"%lu",time] forKey:@"deadlineSecond"];
        [self.dataArray replaceObjectAtIndex:i withObject:dict];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didClickAddBtn {
    AddViewController *addVC = [[AddViewController alloc]init];
    [self presentViewController:addVC animated:YES completion:nil];
}

- (CGFloat)calculateHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    NSString *titleContent = text;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize.height;
}

- (void)didClickGiveUpBtn:(UIControl *)btn {
    NSMutableDictionary *dict = self.dataArray[btn.tag];
    FristModel *model = (FristModel *)[dict objectForKey:@"model"];
    if (model.isRetain) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",model.keyNumber];
        NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
        NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
        NSFetchRequest * request1 = [NSFetchRequest new];
        request1.entity = des1;
        request1.predicate = pre;
        
        NSArray * array = [context executeFetchRequest:request1 error:NULL];
        for (FristModel *model in array) {
            model.giveupCount ++;
            model.clickTime = [NSDate date];
            [context updatedObjects];
        }
        
        [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%d", model.keyNumber]];
        NSDate *now = [NSDate date];
        if (model.alertTime) {
            NSInteger timeInterval = (model.retainTime*24*60*60) * ((int)[now timeIntervalSinceDate:model.startTime] / (model.retainTime*24*60*60) + 1);
            NSDate *alertDate = [model.startTime dateByAddingTimeInterval:timeInterval];
            if ([model.deadlineTime timeIntervalSinceDate:alertDate]) {
                self.formatterDate.dateFormat = @"yyyy.MM.dd";
                NSString *alertDatestr = [self.formatterDate stringFromDate:alertDate];
                self.formatterDate.dateFormat = @"HH:mm";
                NSString *str = [self.formatterDate stringFromDate:model.alertTime];
                NSString *alertStr = [NSString stringWithFormat:@"%@ %@:00", alertDatestr,str];
                self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                NSDate *newAlertDate = [self.formatterDate dateFromString:alertStr];
                [self registerLocalNotification:newAlertDate repeat:YES title:model.title andKey:[NSString stringWithFormat:@"%d",model.keyNumber]];
            }
        }
    } else {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",model.keyNumber];
        NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
        NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
        NSFetchRequest * request1 = [NSFetchRequest new];
        request1.entity = des1;
        request1.predicate = pre;
        
        NSArray * array = [context executeFetchRequest:request1 error:NULL];
        for (FristModel *model in array) {
            model.isgiveup = YES;
            [context updatedObjects];
        }
        
        SecondModel *secondModel = [NSEntityDescription insertNewObjectForEntityForName:@"SecondModel" inManagedObjectContext:[ZTDBManager sharedManager].managedObjectContext];
        secondModel.title = model.title;
        secondModel.keyNumber = model.keyNumber;
        secondModel.status = @"未完成";
        secondModel.currentDate = [NSDate date];
        [[ZTDBManager sharedManager] saveContext];
        [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%d", model.keyNumber]];
    }
    [self refreshDataList];
}

- (void)didClickFinishedBtn:(UIControl*)btn {
    NSMutableDictionary *dict = self.dataArray[btn.tag];
    FristModel *model = (FristModel *)[dict objectForKey:@"model"];
    if (model.isRetain) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",model.keyNumber];
        NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
        NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
        NSFetchRequest * request1 = [NSFetchRequest new];
        request1.entity = des1;
        request1.predicate = pre;
        
        int i = 0;
        NSArray * array = [context executeFetchRequest:request1 error:NULL];
        for (FristModel *model in array) {
            model.finishCount ++;
            i = model.finishCount;
            model.clickTime = [NSDate date];
            [context updatedObjects];
        }
        
        SecondModel *secondModel = [NSEntityDescription insertNewObjectForEntityForName:@"SecondModel" inManagedObjectContext:[ZTDBManager sharedManager].managedObjectContext];
        secondModel.title = model.title;
        secondModel.keyNumber = model.keyNumber;
        secondModel.finishTime = i;
        secondModel.status = @"进行中";
        secondModel.currentDate = [NSDate date];
        [[ZTDBManager sharedManager] saveContext];
        
        [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%d", model.keyNumber]];
        NSDate *now = [NSDate date];
        if (model.alertTime) {
            NSInteger timeInterval = (model.retainTime*24*60*60) * ((int)[now timeIntervalSinceDate:model.startTime] / (model.retainTime*24*60*60) + 1);
            NSDate *alertDate = [model.startTime dateByAddingTimeInterval:timeInterval];
            if ([model.deadlineTime timeIntervalSinceDate:alertDate]) {
                self.formatterDate.dateFormat = @"yyyy.MM.dd";
                NSString *alertDatestr = [self.formatterDate stringFromDate:alertDate];
                self.formatterDate.dateFormat = @"HH:mm";
                NSString *str = [self.formatterDate stringFromDate:model.alertTime];
                NSString *alertStr = [NSString stringWithFormat:@"%@ %@:00", alertDatestr,str];
                self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                NSDate *newAlertDate = [self.formatterDate dateFromString:alertStr];
                [self registerLocalNotification:newAlertDate repeat:YES title:model.title andKey:[NSString stringWithFormat:@"%d",model.keyNumber]];
            }
        }
        
    } else {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",model.keyNumber];
        NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
        NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
        NSFetchRequest * request1 = [NSFetchRequest new];
        request1.entity = des1;
        request1.predicate = pre;
        
        NSArray * array = [context executeFetchRequest:request1 error:NULL];
        for (FristModel *model in array) {
            model.isFinished = YES;
            [context updatedObjects];
        }
        
        SecondModel *secondModel = [NSEntityDescription insertNewObjectForEntityForName:@"SecondModel" inManagedObjectContext:[ZTDBManager sharedManager].managedObjectContext];
        secondModel.title = model.title;
        secondModel.keyNumber = model.keyNumber;
        secondModel.status = @"已完成";
        secondModel.currentDate = [NSDate date];
        [[ZTDBManager sharedManager] saveContext];
        [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%d", model.keyNumber]];
    }
    [self refreshDataList];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    MainTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (contentCell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        contentCell = (MainTableViewCell *)[nib objectAtIndex:0];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableDictionary *dict = self.dataArray[indexPath.section];
    NSNumber *num = [dict objectForKey:@"colorNum"];
    contentCell.backView.backgroundColor = COLLOR_ARRAY[num.integerValue % 7];
    [contentCell setTimeWithSeconds:[[dict objectForKey:@"deadlineSecond"] integerValue]];
    contentCell.contentLabel.text = [dict objectForKey:@"title"];
    contentCell.parent = tableView;
    contentCell.indexPath = indexPath;
    contentCell.finishedBtn.tag = indexPath.section;
    contentCell.giveUpBtn.tag = indexPath.section;
    [contentCell.finishedBtn addTarget:self action:@selector(didClickFinishedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentCell.giveUpBtn addTarget:self action:@selector(didClickGiveUpBtn:) forControlEvents:UIControlEventTouchUpInside];
    return contentCell;
}

- (NSArray *)dataSourceArrayInTableView:(JXMovableCellTableView *)tableView {
    return self.dataArray.copy;
}

- (void)tableView:(JXMovableCellTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray {
    self.dataArray = newDataSourceArray.mutableCopy;
    self.recordDict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSMutableDictionary *dict = self.dataArray[i];
        FristModel *model = (FristModel *)[dict objectForKey:@"model"];
        NSNumber *num = [NSNumber numberWithInteger:i];
        NSString *key = [NSString stringWithFormat:@"%d",model.keyNumber];
        [self.recordDict setObject:[NSString stringWithFormat:@"%@",num] forKey:key];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = (MainTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
    if (!cell.isRight && !cell.isLeft) {
        NSMutableDictionary *dict = self.dataArray[indexPath.section];
        TargetDetailViewController *targetVC = [[TargetDetailViewController alloc]init];
        NSNumber *num = [dict objectForKey:@"colorNum"];
        targetVC.titleColor = COLLOR_ARRAY[num.integerValue % 7];
        targetVC.fModel = (FristModel *)[dict objectForKey:@"model"];
        [self.navigationController pushViewController:targetVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = self.dataArray[indexPath.section];
    CGFloat height = [self calculateHeight:[dict objectForKey:@"title"] width:SCREEN_WIDTH - 30 fontSize:24];
    return 110 + height - 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

#pragma mark - UITableViewCellSlideDelegate
- (void)tableView:(UITableView *)tableView slideToRightWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"向右滑动");
}

- (void)tableView:(UITableView *)tableView slideToLeftWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"向左滑动");
}

@end
