//
//  TargetDetailCell.h
//  smallTarget
//
//  Created by Jack Zeng on 16/11/19.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *finishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveUpCountLabel;

@end
