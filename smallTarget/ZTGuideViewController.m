//
//  ZTGuideViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 17/3/12.
//  Copyright © 2017年 Jack Zeng. All rights reserved.
//

#import "ZTGuideViewController.h"
#import "MainTabBarViewController.h"

@interface ZTGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL flag;

@end

@implementation ZTGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for (int i=0; i<3; i++) {
        UIImage *image;
        if (SCREEN_WIDTH == 320) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"1136-引导页-%d",i+1]];
        } else {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"1334-引导页-%d",i+1]];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = YES;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((NSInteger)scrollView.contentOffset.x > 2*SCREEN_WIDTH + 50) {
        self.flag = YES;
        NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
        // 保存用户数据
        [useDef setBool:self.flag forKey:@"notFirst"];
        [useDef synchronize];
        // 切换根视图控制器
        [UIView animateWithDuration:1 animations:^{
            self.view.alpha = 0.7;
        } completion:^(BOOL finished) {
            self.view.window.rootViewController = [[MainTabBarViewController alloc] init];
        }];
    }
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
