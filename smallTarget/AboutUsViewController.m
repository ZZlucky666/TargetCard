//
//  AboutUsViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/20.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ShowTimeViewController.h"
#import "MyAlertCenter.h"

@interface AboutUsViewController ()

@property (strong, nonatomic) UIButton *backBtn;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
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
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(15, 40, 36, 36);
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 231)/2 + 10, 118, 231, 216)];
    imageView.image = [UIImage imageNamed:@"icon_us"];
    [self.view addSubview:imageView];
    
    CGFloat pointY;
    if (SCREEN_WIDTH > 320) {
        pointY = 118 + 204 + 60;
    } else {
        pointY = 118 + 216;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, pointY, SCREEN_WIDTH - 60, 60)];
    label.text = @"有个改变世界的点子, 就差个程序员？请点击\"联系我们\"";
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = UIColorFromRGB(0x121B26);
    [self.view addSubview:label];
    
    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connectBtn.frame = CGRectMake(0, 0, 180, 44);
    connectBtn.backgroundColor = UIColorFromRGB(0x1E95FF);
    connectBtn.layer.cornerRadius = 5;
    connectBtn.clipsToBounds = YES;
    [connectBtn setTitle:@"联系我们" forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (SCREEN_WIDTH > 320) {
        connectBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 150);
    } else {
        connectBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 70);
    }
    [connectBtn addTarget:self action:@selector(didClickConnectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    UIButton *moreInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreInfoBtn.frame = CGRectMake(0, 0, 80, 25);
    [moreInfoBtn setTitle:@"更多信息" forState:UIControlStateNormal];
    [moreInfoBtn setTitleColor:UIColorFromRGB(0x1E95FF) forState:UIControlStateNormal];
    moreInfoBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 35);
    [moreInfoBtn addTarget:self action:@selector(didClickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreInfoBtn];
}

- (void)didClickMoreBtn {
    ShowTimeViewController *vc = [[ShowTimeViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didClickCancelBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickConnectBtn {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"zengtianshiyue";
    [[MyAlertCenter defaultCenter]postAlertWithMessage:@"已复制微信号"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
