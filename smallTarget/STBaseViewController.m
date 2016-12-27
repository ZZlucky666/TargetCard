//
//  STBaseViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/9/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "STBaseViewController.h"

@interface STBaseViewController ()

@end

@implementation STBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)formatterDate {
    if (_formatterDate == nil) {
        _formatterDate = [[NSDateFormatter alloc]init];
    }
    return _formatterDate;
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
