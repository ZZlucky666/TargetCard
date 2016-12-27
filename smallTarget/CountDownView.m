//
//  CountDownView.m
//  smallTarget
//
//  Created by 万治民 on 16/10/29.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "CountDownView.h"
#import "UIView+CornerRadius.h"

@interface CountDownView()

@property (nonatomic,strong) UILabel *dayLabel ; // 显示天数的Label
@property (nonatomic,strong) UILabel *colonAfterDayLabel ; // 跟在天数后的冒号
@property (nonatomic,strong) UILabel *hourLabel ; // 显示小时的Label
@property (nonatomic,strong) UILabel *colonAfterHourLabel ; // 跟在小时后的冒号
@property (nonatomic,strong) UILabel *minuteLabel ; // 显示分钟的Label
@property (nonatomic,strong) UILabel *colonAfterMinuteLabel ; // 跟在分钟后的label
@property (nonatomic,strong) UILabel *secondLabel ; // 显示秒数的Label
@property (nonatomic,assign) CGFloat leftMargin;

@property (nonatomic,assign) CGFloat offWidth;

@end

@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame andRemainSeconds:(NSInteger)seconds {
    if (self = [super initWithFrame:frame]) {
        if (seconds > 86400) {
            if (seconds > 8640000) {
                self.offWidth = 12;
            } else {
                self.offWidth = 0;
            }
            self.leftMargin = 0;
            [self addSubview:self.dayLabel];
            [self addSubview:self.colonAfterDayLabel];
        } else {
            self.leftMargin = 60;
        }
        [self addSubview:self.hourLabel];
        [self addSubview:self.colonAfterHourLabel];
        [self addSubview:self.minuteLabel];
        [self addSubview:self.colonAfterMinuteLabel];
        [self addSubview:self.secondLabel];
        [self setTimeFromTimeInterval:seconds];
    }
    return self;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28 + self.offWidth, 26)] ;
        _dayLabel.textAlignment = NSTextAlignmentCenter ;
        _dayLabel.font = [UIFont systemFontOfSize:18];
        _dayLabel.cornerRadius = 2.5;
        _dayLabel.backgroundColor = [UIColor whiteColor];
        _dayLabel.textColor = UIColorFromRGB(0x121B26);
    }
    return _dayLabel ;
}

- (UILabel *)colonAfterDayLabel {
    if (!_colonAfterDayLabel) {
        _colonAfterDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(28 + self.offWidth, 0, 32, 26)] ;
        _colonAfterDayLabel.text = @"天" ;
        _colonAfterDayLabel.textAlignment = NSTextAlignmentCenter ;
        _colonAfterDayLabel.font = [UIFont systemFontOfSize:16];
        _colonAfterDayLabel.textColor = [UIColor whiteColor];
    }
    return _colonAfterDayLabel ;
}

- (UILabel *)hourLabel {
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 - self.leftMargin + self.offWidth, 0, 28, 26)] ;
        _hourLabel.textAlignment = NSTextAlignmentCenter ;
        _hourLabel.font = [UIFont systemFontOfSize:18];
        _hourLabel.textColor = UIColorFromRGB(0x121B26);
        _hourLabel.backgroundColor = [UIColor whiteColor];
        _hourLabel.cornerRadius = 2.5;
    }
    return _hourLabel ;
}

- (UILabel *)colonAfterHourLabel {
    if (!_colonAfterHourLabel) {
        _colonAfterHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(88 - self.leftMargin + self.offWidth, 0, 17, 24)] ;
        _colonAfterHourLabel.text = @":" ;
        _colonAfterHourLabel.textAlignment = NSTextAlignmentCenter;
        _colonAfterHourLabel.font = [UIFont systemFontOfSize:16];
        _colonAfterHourLabel.textColor = [UIColor whiteColor];
    }
    return _colonAfterHourLabel ;
}

- (UILabel *)minuteLabel {
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(105 - self.leftMargin + self.offWidth, 0, 28, 26)] ;
        _minuteLabel.textAlignment = NSTextAlignmentCenter ;
        _minuteLabel.font = [UIFont systemFontOfSize:18];
        _minuteLabel.textColor = UIColorFromRGB(0x121B26);
        _minuteLabel.backgroundColor = [UIColor whiteColor];
        _minuteLabel.cornerRadius = 2.5;
    }
    return _minuteLabel ;
}

- (UILabel *)colonAfterMinuteLabel {
    if (!_colonAfterMinuteLabel) {
        _colonAfterMinuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(133 - self.leftMargin + self.offWidth, 0, 17, 24)] ;
        _colonAfterMinuteLabel.text = @":" ;
        _colonAfterMinuteLabel.textAlignment = NSTextAlignmentCenter ;
        _colonAfterMinuteLabel.font = [UIFont systemFontOfSize:16];
        _colonAfterMinuteLabel.textColor = [UIColor whiteColor];
        
    }
    return _colonAfterMinuteLabel ;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 - self.leftMargin + self.offWidth, 0, 28, 26)] ;
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.font = [UIFont systemFontOfSize:18];
        _secondLabel.textColor = UIColorFromRGB(0x121B26);
        _secondLabel.backgroundColor = [UIColor whiteColor];
        _secondLabel.cornerRadius = 2.5;
    }
    return _secondLabel;
}

- (void)setTimeFromTimeInterval:(NSInteger)timeInterval {
    // 通过时间间隔获取天数 小时数 分钟数 秒数
    NSInteger ms = timeInterval;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    self.dayLabel.text = [NSString stringWithFormat:@"%02zd",day];
    self.hourLabel.text = [NSString stringWithFormat:@"%02zd",hour];
    self.minuteLabel.text = [NSString stringWithFormat:@"%02zd",minute];
    self.secondLabel.text = [NSString stringWithFormat:@"%02zd",second];
}

@end
