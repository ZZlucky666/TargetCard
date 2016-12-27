//
//  MainTabBarViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/9/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MainViewController.h"
#import "TimeLineViewController.h"
#import "UserProfileViewController.h"
#import "ZTNavigationController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self addChildVc:[[MainViewController alloc] init] title:@"首页" image:@"icon_home_grey" selectedImage:@"icon_home_black"];
    [self addChildVc:[[TimeLineViewController alloc] init] title:@"时间轴" image:@"icon_timeline_grey" selectedImage:@"icon_timeline_black"];
    [self addChildVc:[[UserProfileViewController alloc] init] title:@"设置" image:@"icon_about_grey" selectedImage:@"icon_about_black"];
    
//    ZTTabBar *tabBar = [[ZTTabBar alloc] init];
//    tabBar.delegate = self;
    // KVC：如果要修系统的某些属性，但被设为readOnly，就是用KVC，即setValue：forKey：。
//    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBColor(123, 123, 123)} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控制器
    ZTNavigationController *navigationVc = [[ZTNavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
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
