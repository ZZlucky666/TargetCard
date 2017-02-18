//
//  ShowTimeViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/21.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "ShowTimeViewController.h"

@interface ShowTimeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) UIButton *cancelTargetBtn;

@end

@implementation ShowTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    NSArray *array = [[NSArray alloc] initWithObjects:@"home-5",@"home-5 copy",nil];
    int r = arc4random() % 2;
    NSString *str = array[r];
    UIImage *image = [UIImage imageNamed:str];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.size.height / image.size.width * SCREEN_WIDTH)];
    self.imageView.image = image;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = CGSizeMake(0, image.size.height / image.size.width * SCREEN_WIDTH);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.cancelTargetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelTargetBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.cancelTargetBtn.frame = CGRectMake(15, 40, 36, 36);
    [self.cancelTargetBtn setImage:[UIImage imageNamed:@"icon_cancel-1"] forState:UIControlStateNormal];
    [self.cancelTargetBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelTargetBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didClickCancelBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
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
