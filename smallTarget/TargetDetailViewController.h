//
//  TargetDetailViewController.h
//  smallTarget
//
//  Created by Jack Zeng on 16/11/19.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FristModel+CoreDataClass.h"
#import "SecondModel+CoreDataClass.h"

@interface TargetDetailViewController : UIViewController

@property (nonatomic, strong) FristModel *fModel;
@property (nonatomic, copy) UIColor *titleColor;

@end
