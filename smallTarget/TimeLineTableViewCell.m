//
//  TimeLineTableViewCell.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/7.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "UIView+CornerRadius.h"

@implementation TimeLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.backView.cornerRadius = 7.5;
    self.squareView.cornerRadius = 7.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
