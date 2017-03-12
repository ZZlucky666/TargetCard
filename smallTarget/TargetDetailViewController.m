//
//  TargetDetailViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/19.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "TargetDetailViewController.h"
#import "TargetDetailCell.h"
#import "TargetDetailSecondCell.h"
#import "TargetDetailFlowLayout.h"
#import "ZTDBManager.h"
#import "MyAlertCenter.h"
#import "AddViewController.h"
#import "ShareCustomView.h"
#import <UMSocialCore/UMSocialCore.h>

@interface TargetDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) ShareCustomView *shareView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImage *catImage;

@end

@implementation TargetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBar];
    [self setupUI];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setNavigationBar {
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(15, 40, 36, 36);
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(SCREEN_WIDTH - 102, 40, 36, 36);
    [self.shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(didClickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(SCREEN_WIDTH - 51, 40, 36, 36);
    [self.moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(didClickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.moreBtn];
}

- (void)setupUI {
    CGFloat height = [self calculateHeight:self.fModel.title width:SCREEN_WIDTH - 55 fontSize:32];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 55, height)];
    self.titleLabel.center = CGPointMake(self.view.centerX, self.view.centerY - 34);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.fModel.title;
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    self.titleLabel.textColor = self.titleColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.pageControl];
    self.pageControl.hidden = YES;
    if (self.fModel.isRetain && self.fModel.isDeadline) {
        self.pageControl.hidden = NO;
    }
}

- (CGFloat)calculateHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    NSString *titleContent = text;
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize.height;
}

- (UICollectionView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 130, SCREEN_WIDTH, 130) collectionViewLayout:[[TargetDetailFlowLayout alloc] init]];
        UINib *nib = [UINib nibWithNibName:@"TargetDetailCell" bundle:nil];
        UINib *nib2 = [UINib nibWithNibName:@"TargetDetailSecondCell" bundle:nil];
        [_bottomView registerNib:nib forCellWithReuseIdentifier:@"targetDetailCell"];
        [_bottomView registerNib:nib2 forCellWithReuseIdentifier:@"secondTargetDetailCell"];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.delegate = self;
        _bottomView.dataSource = self;
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 130, SCREEN_WIDTH - 30, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    }
    return _lineView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 40, 5)];
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xCBCBCB);
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xE5E5E5);
        _pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 10);
    }
    return _pageControl;
}

-(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)didClickShareBtn {
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 107)/2, 20, 110, 27)];
    img.image = [UIImage imageNamed:@"shuiying"];
    [self.view addSubview:img];
    self.catImage = [self captureView:self.view];
    [view removeFromSuperview];
    [img removeFromSuperview];
    UIView *backView = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureToBackView)];
    [backView addGestureRecognizer:tapGesture];
    self.backView = backView;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareCustomView" owner:self options:nil];
    ShareCustomView *shareView = [nib objectAtIndex:0];
    shareView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 200);
    [[[UIApplication sharedApplication] keyWindow] addSubview:shareView];
    self.shareView = shareView;
    
    backView.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{
        shareView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        backView.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
    
    [shareView.wechatBtn addTarget:self action:@selector(didClickWechatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.timeLineBtn addTarget:self action:@selector(didClickTimeLineBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.qqBtn addTarget:self action:@selector(didClickQQBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)tapGestureToBackView {
    [UIView animateWithDuration:0.35f animations:^{
        self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 200);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shareView removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

- (void)didClickWechatBtn:(UIButton*)sender {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *object = [[UMShareImageObject alloc]init];
    object.shareImage = self.catImage;
    messageObject.shareObject = object;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
- (void)didClickTimeLineBtn:(UIButton*)sender {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *object = [[UMShareImageObject alloc]init];
    object.shareImage = self.catImage;
    messageObject.shareObject = object;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
- (void)didClickQQBtn:(UIButton*)sender {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *object = [[UMShareImageObject alloc]init];
    object.shareImage = self.catImage;
    messageObject.shareObject = object;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


#pragma mark - 数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.fModel.isRetain && self.fModel.isDeadline) ? 2 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"targetDetailCell";
    static NSString *secondCellIdentifier = @"secondTargetDetailCell";
    if (self.fModel.isRetain && self.fModel.isDeadline) {
        if (indexPath.row == 0) {
            TargetDetailCell *cell = (TargetDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.finishedLabel.text = [NSString stringWithFormat:@"%2d", self.fModel.finishCount];
            cell.giveUpLabel.text = [NSString stringWithFormat:@"%2d", self.fModel.giveupCount];
            return cell;
        } else {
            TargetDetailSecondCell *cell = (TargetDetailSecondCell *)[collectionView dequeueReusableCellWithReuseIdentifier:secondCellIdentifier forIndexPath:indexPath];
            NSDateFormatter *dataFormant = [ZTDBManager sharedManager].dataFormant;
            [dataFormant setDateFormat: @"yyyy.MM.dd"];
            NSString *dateStr = [dataFormant stringFromDate:self.fModel.deadlineTime];
            cell.deadlineTime.text = dateStr;
            return cell;
        }
    } else if (self.fModel.isRetain) {
        TargetDetailCell *cell = (TargetDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.finishedLabel.text = [NSString stringWithFormat:@"%2d", self.fModel.finishCount];
        cell.giveUpLabel.text = [NSString stringWithFormat:@"%2d", self.fModel.giveupCount];
        return cell;
    } else {
        TargetDetailSecondCell *cell = (TargetDetailSecondCell *)[collectionView dequeueReusableCellWithReuseIdentifier:secondCellIdentifier forIndexPath:indexPath];
        NSDateFormatter *dataFormant = [ZTDBManager sharedManager].dataFormant;
        [dataFormant setDateFormat: @"yyyy.MM.dd"];
        NSString *dateStr = [dataFormant stringFromDate:self.fModel.deadlineTime];
        cell.deadlineTime.text = dateStr;
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = self.bottomView.contentOffset.x;
    offsetX = offsetX + self.bottomView.frame.size.width/2;
    int page = offsetX/self.bottomView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickMoreBtn {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    [actionSheet addButtonWithTitle:@"修改目标"];
    [actionSheet addButtonWithTitle:@"放弃目标"];
    actionSheet.destructiveButtonIndex = 2;
    [actionSheet showInView:actionSheet];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDate *deadlineDate = self.fModel.deadlineTime;
    NSDate *now = [NSDate date];
    if ((int)[deadlineDate timeIntervalSinceDate:now] > 0 && !self.fModel.isgiveup) {
        if (buttonIndex == 1) {
            AddViewController *addVC = [[AddViewController alloc]init];
            addVC.isEdit = YES;
            addVC.fModel = self.fModel;
            __weak typeof(self) weakself = self;
            addVC.didupdatedCallBack = ^(NSString * title) {
                weakself.titleLabel.text = title;
                CGFloat height = [weakself calculateHeight:title width:SCREEN_WIDTH - 55 fontSize:32];
                weakself.titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 55, height);
                weakself.titleLabel.center = CGPointMake(weakself.view.centerX, self.view.centerY - 34);
            };

            [self presentViewController:addVC animated:YES completion:nil];
        } else if (buttonIndex == 2) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确认放弃该目标？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } else {
        if (buttonIndex == 1 || buttonIndex == 2) {
            [[MyAlertCenter defaultCenter]postAlertWithMessage:@"目标已结束，无法编辑"];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[MyAlertCenter defaultCenter]postAlertWithMessage:@"目标已放弃"];
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"keyNumber = %d",self.fModel.keyNumber];
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
        
        NSEntityDescription * des2 = [NSEntityDescription entityForName:@"SecondModel" inManagedObjectContext:context];
        NSFetchRequest * request2 = [NSFetchRequest new];
        request2.entity = des2;
        request2.predicate = pre;
        NSArray * array2 = [context executeFetchRequest:request2 error:NULL];
        for (SecondModel *model in array2) {
            model.status = @"未完成";
            [context updatedObjects];
        }
        [[ZTDBManager sharedManager] saveContext];
        
        [self cancelLocalNotificationWithKey:[NSString stringWithFormat:@"%d", self.fModel.keyNumber]];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
