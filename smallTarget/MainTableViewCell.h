//
//  MainTableViewCell.h
//  smallTarget
//
//  Created by 万治民 on 16/10/29.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDownView.h"

@protocol UITableViewCellSlideDelegate <UITableViewDelegate>

@optional
- (void)tableView:(UITableView *)tableView slideToRightWithIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView slideToLeftWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (nonatomic, strong) CountDownView *countDownView;

@property (nonatomic, strong) UITableView *parent;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
@property (weak, nonatomic) IBOutlet UIButton *giveUpBtn;

@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) BOOL isRight;

- (void)setTimeWithSeconds:(NSInteger)seconds;
@end
