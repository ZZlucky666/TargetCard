//
//  TimeLineTableViewCell.h
//  smallTarget
//
//  Created by Jack Zeng on 16/11/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *squareView;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
