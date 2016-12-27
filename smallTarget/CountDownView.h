//
//  CountDownView.h
//  smallTarget
//
//  Created by 万治民 on 16/10/29.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

- (instancetype)initWithFrame:(CGRect)frame andRemainSeconds:(NSInteger)seconds;

- (void)setTimeFromTimeInterval:(NSInteger)timeInterval;

@end
