//
//  UserProfileViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/9/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ClearAdViewController.h"
#import "AboutUsViewController.h"
#import "ShareCustomView.h"
#import <UMSocialCore/UMSocialCore.h>
@import GoogleMobileAds;

#define googleADId @"ca-app-pub-3311606292245331~7002851000"
#define testGoogleADId @"ca-app-pub-3940256099942544/2934735716"
#define shareText @"你曾想为父母做顿饭，却一拖再拖；你曾想给她买一束花，但忘了又忘。一个个能为生活增添美好的小目标，却常常被埋没在徒增疲惫的世俗琐事里。这里刚好有个不错的应用，提醒你什么更重要。\n下载点击itunes.apple.com/app/id1179254763"

@interface UserProfileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *userProfileTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) ShareCustomView *shareView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [self setUpUI];
}

- (void)setUpUI {
    self.userProfileTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.userProfileTableView];
    self.userProfileTableView.delegate = self;
    self.userProfileTableView.dataSource = self;
    self.userProfileTableView.tableHeaderView = self.headView;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15,0,SCREEN_WIDTH - 30,0.7)];
    lineView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    self.userProfileTableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRectMake(0,0,SCREEN_WIDTH,1))];
    [self.userProfileTableView.tableFooterView addSubview:lineView];
    self.userProfileTableView.tableFooterView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.userProfileTableView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    if ([self.userProfileTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.userProfileTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    [self.userProfileTableView setSeparatorColor:UIColorFromRGB(0xE5E5E5)];
    self.userProfileTableView.contentInset = UIEdgeInsetsMake( 0, 0, 50, 0);
    self.bannerView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 99, SCREEN_WIDTH, 50)];
    [self.view addSubview:self.bannerView];
    self.bannerView.adUnitID = googleADId;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"clearAd"]) {
        self.bannerView.hidden = YES;
    }
}

- (UIView *)headView {
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,117)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 32, 190, 50)];
        titleLabel.textColor = UIColorFromRGB(0x121B26);
        titleLabel.font = [UIFont systemFontOfSize:36];
        titleLabel.text = @"设置";
        [_headView addSubview:titleLabel];
    }
    return _headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didClickShareBtn {
    
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
//    UMShareImageObject *object = [[UMShareImageObject alloc]init];
//    object.shareImage = [UIImage imageNamed:@"home-5 copy"];
//    messageObject.shareObject = object;
    messageObject.text = shareText;
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
//    UMShareImageObject *object = [[UMShareImageObject alloc]init];
//    object.shareImage = [UIImage imageNamed:@"home-5 copy"];
//    messageObject.shareObject = object;
    messageObject.text = shareText;
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
//    UMShareImageObject *object = [[UMShareImageObject alloc]init];
//    object.shareImage = [UIImage imageNamed:@"home-5 copy"];
//    messageObject.shareObject = object;
    messageObject.text = shareText;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TimeLineTableViewThirdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.backgroundColor = UIColorFromRGB(0xFAFAFA);
    cell.contentView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"去除广告";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"分享好友";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"评价APP";
    } else {
        cell.textLabel.text = @"关于我们";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:21];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ClearAdViewController *vc = [[ClearAdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        [self didClickShareBtn];
    } else if (indexPath.row == 3) {
        AboutUsViewController *vc = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        static NSString * const reviewURL = @"itms-apps://itunes.apple.com/app/1018221712";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
@end
