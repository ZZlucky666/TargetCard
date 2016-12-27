//
//  TimeLineViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/9/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "TimeLineViewController.h"
#import "TimeLineTableViewCell.h"
#import "AddViewController.h"
#import "TargetModel.h"
#import "ZTDBManager.h"
#import "SecondModel+CoreDataClass.h"
#import "FristModel+CoreDataClass.h"
#import "TargetDetailViewController.h"
@import GoogleMobileAds;

#define googleADId @"ca-app-pub-3311606292245331~7002851000"
#define testGoogleADId @"ca-app-pub-3940256099942544/2934735716"

@interface TimeLineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *timelineTableView;
@property (nonatomic, strong) NSArray *timeLineDataArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSTimeZone *timeZone;
/// 查询结果控制器
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) GADBannerView *bannerView;
@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.timeLineDataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadListView];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    
    /// 1. 查询请求 - 参数是实体名称，查询哪一个数据表
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SecondModel"];
    
    // 1> 指定排序
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"currentDate" ascending:NO];
    
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

- (void)setUpUI {
    self.timelineTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.timelineTableView];
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.timelineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.timelineTableView.tableHeaderView = self.headView;
    self.timelineTableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRectMake(0,0,0,0.1))];
    self.timelineTableView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.timelineTableView.contentInset = UIEdgeInsetsMake( 0, 0, 50, 0);
    self.bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 99, SCREEN_WIDTH, 50)];
    [self.view addSubview:self.bannerView];
    self.bannerView.adUnitID = googleADId;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"clearAd"]) {
        self.bannerView.hidden = YES;
    }
}

- (void)reloadListView {
    [self.fetchedResultsController performFetch:NULL];
    self.timeLineDataArray = self.fetchedResultsController.fetchedObjects;
    if (self.timeLineDataArray.count > 0) {
        self.timelineTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.timelineTableView reloadData];
    } else {
        self.timelineTableView.tableFooterView = self.backView;
    }
}

- (UIView *)headView {
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,117)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 32, 190, 50)];
        titleLabel.textColor = UIColorFromRGB(0x121B26);
        titleLabel.font = [UIFont systemFontOfSize:36];
        titleLabel.text = @"我的时间轴";
        [_headView addSubview:titleLabel];
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectMake(SCREEN_WIDTH - 51, 40, 36, 36);
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
        backImageView.frame = CGRectMake(48, 42, SCREEN_WIDTH - 96, (SCREEN_WIDTH - 96) * 374/575);
        UILabel *backLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 42 + (SCREEN_WIDTH - 96) * 374/575 + 39, SCREEN_WIDTH, 30)];
        backLable.text = @"你还没有计划，快去添加吧 ";
        backLable.font = [UIFont systemFontOfSize:21];
        backLable.textAlignment = NSTextAlignmentCenter;
        backLable.textColor = UIColorFromRGB(0xCBCBCCB);
        [_backView addSubview:backImageView];
        [_backView addSubview:backLable];
    }
    return _backView;
}

- (void)didClickAddBtn {
    AddViewController *addVC = [[AddViewController alloc]init];
    [self presentViewController:addVC animated:YES completion:nil];
}

- (NSCalendar *)calendar {
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (NSTimeZone *)timeZone {
    if (_timeZone == nil) {
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    }
    return _timeZone;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    [self.calendar setTimeZone: self.timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [self.calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeLineDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"timeLineCellID";
    TimeLineTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (contentCell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TimeLineTableViewCell" owner:self options:nil];
        contentCell = (TimeLineTableViewCell *)[nib objectAtIndex:0];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    contentCell.backgroundColor = UIColorFromRGB(0xFAFAFA);
    contentCell.contentView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    contentCell.backView.backgroundColor = COLLOR_ARRAY[indexPath.row%7];
    contentCell.squareView.backgroundColor = COLLOR_ARRAY[indexPath.row%7];
    contentCell.lineView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_color_bar_%ld",indexPath.row%7+1]];
    contentCell.tagImageView.image = [UIImage imageNamed:@"icon_clock"];
    if (indexPath.row == self.timeLineDataArray.count - 1) {
        contentCell.lineView.hidden = YES;
    }
    contentCell.backView.clipsToBounds = NO;
    contentCell.backView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    contentCell.backView.layer.shadowOffset = CGSizeMake(0,5);
    contentCell.backView.layer.shadowOpacity = 0.18;
    contentCell.backView.layer.shadowRadius = 6;
    SecondModel *model = self.timeLineDataArray[indexPath.row];
    contentCell.weekLabel.text = [self weekdayStringFromDate:model.currentDate];
    self.formatterDate.dateFormat = @"MM-dd";
    contentCell.dateLabel.text = [self.formatterDate stringFromDate:model.currentDate];
    contentCell.titleLabel.text = model.title;
    contentCell.tagStatusLabel.text = model.status;
    if ([model.status isEqualToString:@"进行中"]) {
        contentCell.countLabel.hidden = NO;
        contentCell.countLabel.text = [NSString stringWithFormat:@"完成%d次", model.finishTime];
        contentCell.tagImageView.image = [UIImage imageNamed:@"icon_clock"];
    } else if ([model.status isEqualToString:@"已完成"]) {
        contentCell.countLabel.hidden = YES;
        contentCell.tagImageView.image = [UIImage imageNamed:@"icon_done"];
    } else if ([model.status isEqualToString:@"未完成"]) {
        contentCell.countLabel.hidden = YES;
        contentCell.tagImageView.image = [UIImage imageNamed:@"icon_unfinished"];
    } else {
        contentCell.countLabel.hidden = YES;
        contentCell.tagImageView.image = [UIImage imageNamed:@"icon_clock"];
    }
    return contentCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SecondModel *model = self.timeLineDataArray[indexPath.row];
    
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",model.keyNumber];
    NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
    NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
    NSFetchRequest * request1 = [NSFetchRequest new];
    request1.entity = des1;
    request1.predicate = pre;
    
    NSArray * array = [context executeFetchRequest:request1 error:NULL];
    FristModel *fmodel = array[0];
    if (fmodel) {
        TargetDetailViewController *targetVC = [[TargetDetailViewController alloc]init];
        targetVC.fModel = fmodel;
        targetVC.titleColor = COLLOR_ARRAY[indexPath.section%7];
        [self.navigationController pushViewController:targetVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SecondModel *model = self.timeLineDataArray[indexPath.row];
    CGFloat height = [self calculateHeight:model.title width:SCREEN_WIDTH - 110 fontSize:24];
    return 130 + height - 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)calculateHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    NSString *titleContent = text;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize.height;
}

@end
