//
//  AddViewController.m
//  smallTarget
//
//  Created by 万治民 on 16/10/30.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "AddViewController.h"
#import "TargetEditView.h"
#import "ZTPickerView.h"
#import "TargetModel.h"
#import "ZTSession.h"
#import "ZTDBManager.h"

#import "SecondModel+CoreDataClass.h"
#import "MyAlertCenter.h"

@interface AddViewController ()<UITableViewDelegate,UITableViewDataSource,ZTPickerViewDelegate,TargetEditViewDelegate>
@property (strong, nonatomic) UIButton *cancelTargetBtn;
@property (strong, nonatomic) UIButton *addTargetBtn;
@property (nonatomic, strong) UITableView *editTableView;
@property (nonatomic, strong) UISwitch *fristSwitchView;
@property (nonatomic, strong) UISwitch *secondSwitchview;
@property (nonatomic, strong) UISwitch *thirdSwitchview;
@property (nonatomic, strong) UILabel *dateRetainLabel;
@property (nonatomic, strong) UILabel *deadLineLabel;
@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, strong) TargetEditView *editView;
@property (nonatomic, strong) UILabel *placeHoldLabel;
@property (nonatomic, strong) UILabel *textCountLabel;

@property (nonatomic, assign) BOOL isRetain;
@property (nonatomic, assign) BOOL isDeadline;
@property (nonatomic, assign) BOOL isAlert;

@property (nonatomic, assign) NSInteger retainDay;
@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic, strong) NSDate *alertTime;
@property (nonatomic, copy) NSString *targetTitle;

@property (nonatomic, strong) ZTPickerView *pickerView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    self.editTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20) style:UITableViewStylePlain];
    [self.view addSubview:self.editTableView];
    self.editTableView.delegate = self;
    self.editTableView.dataSource = self;
    if ([self.editTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.editTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    [self.editTableView setSeparatorColor:UIColorFromRGB(0xE5E5E5)];
    self.formatterDate.dateFormat=@"yyyy.MM.dd";
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - lazy load
- (UISwitch *)fristSwitchView {
    if (_fristSwitchView == nil) {
        _fristSwitchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_fristSwitchView addTarget:self action:@selector(fristSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _fristSwitchView;
}

- (UISwitch *)secondSwitchview {
    if (_secondSwitchview == nil) {
        _secondSwitchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_secondSwitchview addTarget:self action:@selector(secondSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _secondSwitchview;
}

- (UISwitch *)thirdSwitchview {
    if (_thirdSwitchview == nil) {
        _thirdSwitchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_thirdSwitchview addTarget:self action:@selector(thirdSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _thirdSwitchview;
}

- (UILabel *)dateRetainLabel {
    if (_dateRetainLabel == nil) {
        _dateRetainLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 21, 95, 30)];
        _dateRetainLabel.text = @"请选择";
        _dateRetainLabel.font = [UIFont systemFontOfSize:21];
        _dateRetainLabel.textAlignment = NSTextAlignmentRight;
        _dateRetainLabel.textColor = UIColorFromRGB(0xCBCBCB);
    }
    return _dateRetainLabel;
}

- (UILabel *)deadLineLabel {
    if (_deadLineLabel == nil) {
        _deadLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 21, 195, 30)];
        _deadLineLabel.text = @"请选择";
        _deadLineLabel.font = [UIFont systemFontOfSize:21];
        _deadLineLabel.textAlignment = NSTextAlignmentRight;
        _deadLineLabel.textColor = UIColorFromRGB(0xCBCBCB);
    }
    return _deadLineLabel;
}

- (UILabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 21, 195, 30)];
        _alertLabel.text = @"请选择";
        _alertLabel.font = [UIFont systemFontOfSize:21];
        _alertLabel.textAlignment = NSTextAlignmentRight;
        _alertLabel.textColor = UIColorFromRGB(0xCBCBCB);
    }
    return _alertLabel;
}

- (UILabel *)placeHoldLabel {
    if (_placeHoldLabel == nil) {
        _placeHoldLabel = [[UILabel alloc]init];
        _placeHoldLabel.text = @"点击输入你的计划";
        _placeHoldLabel.font = [UIFont systemFontOfSize:24];
        _placeHoldLabel.textColor = UIColorFromRGB(0xCBCBCB);
        _placeHoldLabel.numberOfLines = 0;
        _placeHoldLabel.frame = CGRectMake(14, 115, SCREEN_WIDTH - 20, 50);
    }
    return _placeHoldLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup UI
- (void)setupUI {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255)];
    
    self.cancelTargetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelTargetBtn.frame = CGRectMake(15, 20, 36, 36);
    [self.cancelTargetBtn setImage:[UIImage imageNamed:@"icon_cancel-1"] forState:UIControlStateNormal];
    [self.cancelTargetBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.addTargetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addTargetBtn.frame = CGRectMake(SCREEN_WIDTH - 51, 20, 36, 36);
    [self.addTargetBtn setImage:[UIImage imageNamed:@"icon_done-1"] forState:UIControlStateNormal];
    [self.addTargetBtn addTarget:self action:@selector(didClickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.editView = [[TargetEditView alloc]initWithtext:@"" andMaxLength:30];
    self.editView.frame = CGRectMake(0, 115, SCREEN_WIDTH, 140);
    self.editView.font = [UIFont systemFontOfSize:24];
    self.editView.textColor = UIColorFromRGB(0x4A4A4A);
    self.editView.textContainerInset = UIEdgeInsetsMake(10, 10, 30, 10);
    self.editView.textViewDelegate = self;
    
    self.textCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 225, SCREEN_WIDTH - 10, 30)];
    self.textCountLabel.textAlignment = NSTextAlignmentRight;
    self.textCountLabel.font = [UIFont systemFontOfSize:14];
    self.textCountLabel.textColor = UIColorFromRGB(0xCBCBCB);
    self.textCountLabel.hidden = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 254.3, SCREEN_WIDTH - 30, 0.7)];
    lineView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    
    [headView addSubview:self.cancelTargetBtn];
    [headView addSubview:self.addTargetBtn];
    [headView addSubview:self.editView];
    [headView addSubview:self.placeHoldLabel];
    [headView addSubview:self.textCountLabel];
    [headView addSubview:lineView];
    headView.clipsToBounds = YES;
    self.editTableView.tableHeaderView = headView;
    self.editTableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255);
    self.editTableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRectMake(0,0,SCREEN_WIDTH,0.1))];
    
    self.pickerView = [[ZTPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 264)];
    self.pickerView.delegate = self;
    
    if (self.isEdit) {
        self.editView.text = self.fModel.title;
        self.placeHoldLabel.hidden = YES;
        self.targetTitle = self.fModel.title;
        if (self.fModel.alertTime) {
            self.alertTime = self.fModel.alertTime;
            _isAlert = YES;
        }
    }
}

#pragma mark - 监听方法
- (void)fristSwitchChanged:(id)sender {
    [self.view endEditing:YES];
    _isRetain = !_isRetain;
    if (!_isRetain) {
        self.dateRetainLabel.text = @"请选择";
        self.dateRetainLabel.textColor = UIColorFromRGB(0xCBCBCB);
        self.retainDay = 0;
    }
    [self.editTableView reloadData];
}

- (void)secondSwitchChanged:(id)sender {
    [self.view endEditing:YES];
    _isDeadline = !_isDeadline;
    if (!_isDeadline) {
        self.deadLineLabel.text = @"请选择";
        self.deadLineLabel.textColor = UIColorFromRGB(0xCBCBCB);
        self.deadline = nil;
    }
    [self.editTableView reloadData];
}

- (void)thirdSwitchChanged:(UISwitch *)sender {
    [self.view endEditing:YES];
    if (self.isEdit) {
        _isAlert = !_isAlert;
        if (!_isAlert) {
            self.alertLabel.text = @"请选择";
            self.alertLabel.textColor = UIColorFromRGB(0xCBCBCB);
            self.alertTime = nil;
        }
        [self.editTableView reloadData];
    } else {
        if (self.deadline || self.retainDay) {
            _isAlert = !_isAlert;
            if (!_isAlert) {
                self.alertLabel.text = @"请选择";
                self.alertTime = nil;
            }
            [self.editTableView reloadData];
        } else {
            [sender setOn:NO animated:YES];
            [[MyAlertCenter defaultCenter]postAlertWithMessage:@"请添加循环周期或截止时间"];
        }
    }
}

- (void)didClickCancelBtn {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickAddBtn {
    [self.view endEditing:YES];
    if (self.isEdit) {
        if (self.targetTitle && self.targetTitle.length > 0) {
            if (![self.targetTitle isEqualToString:self.fModel.title] || ![self.fModel.alertTime isEqual:self.alertTime]) {
                NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",self.fModel.keyNumber];
                NSManagedObjectContext * context = [ZTDBManager sharedManager].managedObjectContext;
                NSEntityDescription * des1 = [NSEntityDescription entityForName:@"FristModel" inManagedObjectContext:context];
                NSFetchRequest * request1 = [NSFetchRequest new];
                request1.entity = des1;
                request1.predicate = pre;
                
                NSInteger keyNum = 0;
                NSArray * array = [context executeFetchRequest:request1 error:NULL];
                for (FristModel *model in array) {
                    model.title = self.targetTitle;
                    model.alertTime = self.alertTime;
                    keyNum = model.keyNumber;
                    [context updatedObjects];
                }
                
                NSEntityDescription * des2 = [NSEntityDescription entityForName:@"SecondModel" inManagedObjectContext:context];
                NSFetchRequest * request2 = [NSFetchRequest new];
                request2.entity = des2;
                request2.predicate = pre;
                NSArray * array2 = [context executeFetchRequest:request2 error:NULL];
                for (SecondModel *model in array2) {
                    model.title = self.targetTitle;
                    [context updatedObjects];
                }
                [[ZTDBManager sharedManager] saveContext];
                if (self.didupdatedCallBack) {
                    self.didupdatedCallBack(self.targetTitle);
                }
                
                self.formatterDate.dateFormat = @"yyyy.MM.dd";
                NSString *todayStr = [self.formatterDate stringFromDate:[NSDate date]];
                if (self.alertTime) {
                    if (self.fModel.retainTime > 0) {
                        self.formatterDate.dateFormat = @"HH:mm";
                        NSString *str = [self.formatterDate stringFromDate:self.alertTime];
                        NSString *alertStr = [NSString stringWithFormat:@"%@ %@:00", todayStr,str];
                        self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                        NSDate *alertDate = [self.formatterDate dateFromString:alertStr];
                        [self registerLocalNotification:alertDate repeat:YES title:self.targetTitle andKey:[NSString stringWithFormat:@"%ld",keyNum]];
                    } else {
                        self.formatterDate.dateFormat = @"yyyy.MM.dd";
                        NSString *str = [self.formatterDate stringFromDate:self.alertTime];
                        NSString *alertStr = [NSString stringWithFormat:@"%@ 10:00:00", str];
                        self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                        NSDate *alertDate = [self.formatterDate dateFromString:alertStr];
                        [self registerLocalNotification:alertDate repeat:NO title:self.targetTitle andKey:[NSString stringWithFormat:@"%ld",keyNum]];
                    }
                } else {
                    [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%ld",keyNum]];
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [[MyAlertCenter defaultCenter]postAlertWithMessage:@"未做修改"];
            }
        } else {
            [[MyAlertCenter defaultCenter]postAlertWithMessage:@"请添加目标名称"];
        }
    } else {
        if (self.targetTitle && self.targetTitle.length > 0 && (self.deadline || self.retainDay)) {
            FristModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"FristModel" inManagedObjectContext:[ZTDBManager sharedManager].managedObjectContext];
            model.title = self.targetTitle;
            model.keyNumber = arc4random_uniform(100000);
            if (self.retainDay > 0) {
                model.isRetain = YES;
                model.retainTime = self.retainDay;
            } else {
                model.isRetain = NO;
            }
            if (self.deadline) {
                model.isDeadline = YES;
                model.deadlineTime = self.deadline;
            } else {
                NSString *deadStr = [NSString stringWithFormat:@"2030.01.01 23:59:59"];
                self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                model.isDeadline = NO;
                model.deadlineTime = [self.formatterDate dateFromString:deadStr];
            }
            
            //今晚24点作为目标开始
            self.formatterDate.dateFormat = @"yyyy.MM.dd";
            NSString *todayStr = [self.formatterDate stringFromDate:[NSDate date]];
            NSString *deadStr1 = [NSString stringWithFormat:@"%@ 00:00:00", todayStr];
            NSString *deadStr2 = [NSString stringWithFormat:@"%@ 23:59:59", todayStr];
            
            self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
            NSString *eightClock = [NSString stringWithFormat:@"%@ 20:00:00", todayStr];
            NSDate *eightDate = [self.formatterDate dateFromString:eightClock];
            
            if([eightDate timeIntervalSinceDate:[NSDate date]] > 0) {
                model.startTime = [self.formatterDate dateFromString:deadStr1];
            } else if (model.isRetain && model.isDeadline && [model.deadlineTime timeIntervalSinceNow] < 86000)  {
                model.startTime = [self.formatterDate dateFromString:deadStr1];
            } else {
                model.startTime = [self.formatterDate dateFromString:deadStr2];
            }
            if (self.alertTime) {
                model.alertTime = self.alertTime;
            }
            SecondModel *secondModel = [NSEntityDescription insertNewObjectForEntityForName:@"SecondModel" inManagedObjectContext:[ZTDBManager sharedManager].managedObjectContext];
            secondModel.title = self.targetTitle;
            secondModel.keyNumber = model.keyNumber;
            secondModel.status = @"开始目标";
            secondModel.currentDate = [NSDate date];
            [[ZTDBManager sharedManager] saveContext];
            
            if (self.alertTime) {
                if (self.retainDay > 0) {
                    self.formatterDate.dateFormat = @"HH:mm";
                    NSString *str = [self.formatterDate stringFromDate:self.alertTime];
                    NSString *alertStr = [NSString stringWithFormat:@"%@ %@:00", todayStr,str];
                    self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                    NSDate *alertDate = [self.formatterDate dateFromString:alertStr];
                    [self registerLocalNotification:alertDate repeat:YES title:self.targetTitle andKey:[NSString stringWithFormat:@"%d",model.keyNumber]];
                } else {
                    self.formatterDate.dateFormat = @"yyyy.MM.dd";
                    NSString *str = [self.formatterDate stringFromDate:self.alertTime];
                    NSString *alertStr = [NSString stringWithFormat:@"%@ 10:00:00", str];
                    self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
                    NSDate *alertDate = [self.formatterDate dateFromString:alertStr];
                    [self registerLocalNotification:alertDate repeat:NO title:self.targetTitle andKey:[NSString stringWithFormat:@"%d",model.keyNumber]];
                }
            }
           
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            if (self.targetTitle && self.targetTitle.length > 0) {
                [[MyAlertCenter defaultCenter]postAlertWithMessage:@"请添加循环周期或截止时间"];
            } else {
                [[MyAlertCenter defaultCenter]postAlertWithMessage:@"请添加目标名称"];
            }
        }
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

- (void)keyboardWillChanged:(NSNotification *)notification {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:21];
    cell.textLabel.textColor = UIColorFromRGB(0x121B26);
    if (indexPath.row == 0) {
        cell.textLabel.text = @"循环执行";
        cell.accessoryView = self.fristSwitchView;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"设定循环执行";
        cell.accessoryView = self.dateRetainLabel;
        if (self.isEdit && self.fModel.isRetain) {
            self.dateRetainLabel.text = [NSString stringWithFormat:@"%d天", self.fModel.retainTime];
            cell.textLabel.textColor = UIColorFromRGB(0xCBCBCB);
        }
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"截止日期";
        cell.accessoryView = self.secondSwitchview;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"设定截止日期";
        cell.accessoryView = self.deadLineLabel;
        if (self.isEdit && self.fModel.isDeadline) {
            cell.textLabel.textColor = UIColorFromRGB(0xCBCBCB);
            self.formatterDate.dateFormat = @"yyyy.MM.dd";
            self.deadLineLabel.text = [self.formatterDate stringFromDate:self.fModel.deadlineTime];
        }
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"提醒";
        cell.accessoryView = self.thirdSwitchview;
        if (self.isEdit && self.alertTime) {
            [self.thirdSwitchview setOn:YES];
            _isAlert = YES;
        }
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"设置提醒时间";
        cell.accessoryView = self.alertLabel;
        if (self.isEdit) {
            if (self.alertTime) {
                if (self.fModel.retainTime > 0) {
                    self.formatterDate.dateFormat = @"HH:mm";
                    self.alertLabel.text = [NSString stringWithFormat:@"每天%@", [self.formatterDate stringFromDate:self.alertTime]];
                } else {
                    self.formatterDate.dateFormat = @"yyyy.MM.dd";
                    self.alertLabel.text = [self.formatterDate stringFromDate:self.alertTime];
                }
            } else {
                self.alertLabel.text = @"请选择";
            }
        }
    }
    cell.clipsToBounds = YES;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (self.isEdit == 0) {
        if (indexPath.row == 1) {
            UIView *backView = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureToBackView)];
            [backView addGestureRecognizer:tapGesture];
            backView.alpha = 0;
            self.backView = backView;
            [UIView animateWithDuration:0.35f animations:^{
                backView.alpha = 0.5;
            } completion:^(BOOL finished) {
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.pickerView];
            self.pickerView.pickerStyle = RetainTimeStyle;
            [self.pickerView pullUp];
        } else if (indexPath.row == 3) {
            UIView *backView = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureToBackView)];
            [backView addGestureRecognizer:tapGesture];
            backView.alpha = 0;
            self.backView = backView;
            [UIView animateWithDuration:0.35f animations:^{
                backView.alpha = 0.5;
            } completion:^(BOOL finished) {
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.pickerView];
            self.pickerView.pickerStyle = DeadlineStyle;
            [self.pickerView pullUp];
        } else if (indexPath.row == 5) {
            UIView *backView = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureToBackView)];
            [backView addGestureRecognizer:tapGesture];
            backView.alpha = 0;
            self.backView = backView;
            [UIView animateWithDuration:0.35f animations:^{
                backView.alpha = 0.5;
            } completion:^(BOOL finished) {
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.pickerView];
            if (self.retainDay) {
                self.pickerView.pickerStyle = AlertRetainStyle;
                [self.pickerView pullUp];
            } else {
                self.pickerView.pickerStyle = AlertDeadlineStyle;
                [self.pickerView pullUp];
            }
        }
    } else {
        if (indexPath.row == 5) {
            UIView *backView = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureToBackView)];
            [backView addGestureRecognizer:tapGesture];
            backView.alpha = 0;
            self.backView = backView;
            [UIView animateWithDuration:0.35f animations:^{
                backView.alpha = 0.5;
            } completion:^(BOOL finished) {
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.pickerView];
            if (self.fModel.retainTime > 0) {
                self.pickerView.pickerStyle = AlertRetainStyle;
                [self.pickerView pullUp];
            } else {
                self.pickerView.pickerStyle = AlertDeadlineStyle;
                [self.pickerView pullUp];
            }
        }
    }
}

- (void)tapGestureToBackView {
    [self.pickerView pullDown];
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:0.35f animations:^{
        weakself.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself.backView removeFromSuperview];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit) {
        if (indexPath.row == 4) {
            return 73;
        }
        if (indexPath.row == 1) {
            if (self.fModel.isRetain) {
                return 73;
            } else {
                return 0.01;
            }
        }
        if (indexPath.row == 3) {
            if (self.fModel.isDeadline) {
                return 73;
            } else {
                return 0.01;
            }
        }
        if (indexPath.row == 5) {
            if (_isAlert) {
                return 73;
            } else {
                return 0.01;
            }
        }
        return 0.01;
    } else {
        if (indexPath.row == 1) {
            if (_isRetain) {
                return 73;
            }
            return 0.01;
        } else if (indexPath.row == 3) {
            if (_isDeadline) {
                return 73;
            }
            return 0.01;
        } else if (indexPath.row == 5) {
            if (_isAlert) {
                return 73;
            }
            return 0.01;
        }
        return 73;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - ZTPickerViewDelegate

- (void)clickSureBtnWithFristItem:(NSString *)fristItem secondItem:(NSString *)secondItem {
    [self.pickerView pullDown];
    self.dateRetainLabel.text = [NSString stringWithFormat:@"%@%@", fristItem, secondItem];
    self.dateRetainLabel.textColor = UIColorFromRGB(0x121B26);
    if ([secondItem isEqualToString:@"月"]) {
        self.retainDay = fristItem.intValue * 30;
    } else if ([secondItem isEqualToString:@"周"]) {
        self.retainDay = fristItem.intValue * 7;
    } else {
        self.retainDay = fristItem.intValue;
    }
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:0.35f animations:^{
        weakself.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself.backView removeFromSuperview];
        if (weakself.thirdSwitchview.on) {
            [weakself.thirdSwitchview setOn:NO animated:YES];
            weakself.alertTime = nil;
            weakself.isAlert = NO;
            weakself.alertLabel.text = @"请选择";
            [weakself.editTableView reloadData];
        }
    }];
}

- (void)clickSureBtnWithDate:(NSDate *)deadline {
    [self.pickerView pullDown];
    self.formatterDate.dateFormat = @"yyyy.MM.dd";
    self.deadLineLabel.text = [self.formatterDate stringFromDate:deadline];
    self.deadLineLabel.textColor = UIColorFromRGB(0x121B26);
    NSString *str = [self.formatterDate stringFromDate:deadline];
    NSString *deadStr = [NSString stringWithFormat:@"%@ 23:59:59", str];
    self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.deadline = [self.formatterDate dateFromString:deadStr];
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:0.35f animations:^{
        weakself.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself.backView removeFromSuperview];
        if (weakself.thirdSwitchview.on) {
            [weakself.thirdSwitchview setOn:NO animated:YES];
            weakself.alertTime = nil;
            weakself.isAlert = NO;
            weakself.alertLabel.text = @"请选择";
            [weakself.editTableView reloadData];
        }
    }];
}

- (void)clickSureBtnWithAlertDeadlineDate:(NSDate *)alertDate {
    [self.pickerView pullDown];
    self.formatterDate.dateFormat = @"yyyy.MM.dd";
    self.alertLabel.text = [self.formatterDate stringFromDate:alertDate];
    self.alertLabel.textColor = UIColorFromRGB(0x121B26);
    NSString *str = [self.formatterDate stringFromDate:alertDate];
    NSString *deadStr = [NSString stringWithFormat:@"%@ 08:00:00", str];
    self.formatterDate.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.alertTime = [self.formatterDate dateFromString:deadStr];
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:0.35f animations:^{
        weakself.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself.backView removeFromSuperview];
    }];
}

- (void)clickSureBtnWithAlertRetainDate:(NSDate *)alertDate {
    [self.pickerView pullDown];
    self.formatterDate.dateFormat = @"HH:mm";
    self.alertLabel.text = [NSString stringWithFormat:@"每天%@", [self.formatterDate stringFromDate:alertDate]];
    self.alertLabel.textColor = UIColorFromRGB(0x121B26);
    self.alertTime = alertDate;
    __weak typeof(self)weakself = self;
    [UIView animateWithDuration:0.35f animations:^{
        weakself.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself.backView removeFromSuperview];
    }];
}

#pragma mark - TargetEditViewDelegate
- (void)textViewEndEditing:(TargetEditView *)targetEditView andCountRes:(NSInteger)res {
    if (res < 10) {
        if (res < 0) {
            res = 0;
        }
        self.textCountLabel.hidden = NO;
        self.textCountLabel.text = [NSString stringWithFormat:@"还可以输入%ld个字", res];
    } else {
        self.textCountLabel.hidden = YES;
    }
    
    if (res < 30) {
        self.placeHoldLabel.hidden = YES;
    } else {
        self.placeHoldLabel.hidden = NO;
    }
    self.targetTitle = targetEditView.text;
}

@end
