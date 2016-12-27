//
//  ZTPickerView.m
//  smallTarget
//
//  Created by Jack Zeng on 16/10/31.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "ZTPickerView.h"

@interface ZTPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSMutableDictionary *retainTimeDataDict;
@property (nonatomic,strong) NSMutableDictionary *deadlineDataDict;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *alertLabel;
@property (nonatomic,strong) UIView *upLine;
@property (nonatomic,strong) UIView *downLine;
@property (nonatomic,copy) NSString *firstItem;
@property (nonatomic,copy) NSString *secondItem;
@property (nonatomic,copy) NSString *thirdItem;
@property (nonatomic, strong) NSDate *deadlineDate;
@end

@implementation ZTPickerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.retainTimeDataDict = [NSMutableDictionary dictionaryWithDictionary:@{@"selectCount":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"], @"unit":@[@"天",@"周",@"月"]}];;
        NSArray *selectCountArray = [self.retainTimeDataDict objectForKey:@"selectCount"];
        self.firstItem = selectCountArray[0];
        NSArray *unitArray = [self.retainTimeDataDict objectForKey:@"unit"];
        self.secondItem = unitArray[0];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 48)];
        [self addSubview:headView];

        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake(self.bounds.size.width - 62, 0, 62, 48);
        [self.sureBtn setTitleColor:UIColorFromRGB(0x008CFF) forState:UIControlStateNormal];
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:self.sureBtn];
        
//        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 62, 48)];
//        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [self.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [headView addSubview:self.cancelBtn];
        
        UIView *toplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        toplineView.backgroundColor = RGBColor(223, 223, 223);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = RGBColor(223, 223, 223);
        [headView addSubview:toplineView];
        [headView addSubview:lineView];
        
        self.upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 138, self.bounds.size.width, 0.5)];
        self.upLine.backgroundColor = RGBColor(223, 223, 223);
        self.downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 173, self.bounds.size.width, 0.5)];
        self.downLine.backgroundColor = RGBColor(223, 223, 223);
        [self addSubview:self.upLine];
        [self addSubview:self.downLine];
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 138, (self.bounds.size.width - 135)/3, 35)];
        self.leftLabel.text = @"每";
        self.leftLabel.font = [UIFont systemFontOfSize:24];
        self.leftLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.leftLabel];
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - (self.bounds.size.width - 135)/3 * 2, 138, (self.bounds.size.width - 135)/3 * 2, 35)];
        self.rightLabel.text = @"执行一次";
        self.rightLabel.font = [UIFont systemFontOfSize:24];
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.rightLabel];
        self.pickerView.frame = CGRectMake((self.bounds.size.width - 135)/3, 48, 135, 216);
        self.datePicker.frame = CGRectMake(0, 48, self.bounds.size.width, 216);
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 138, 100, 35)];
        self.alertLabel.text = @"每天";
        self.alertLabel.font = [UIFont systemFontOfSize:24];
        self.alertLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.alertLabel];
        self.datePicker.hidden = YES;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.pickerView.hidden = YES;
        self.alertLabel.hidden = YES;
    }
    return self;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]init];
        [self addSubview:_datePicker];
    }
    return _datePicker;
}

- (void)setPickerStyle:(PickerViewStyle)pickerStyle {
    _pickerStyle = pickerStyle;
    if (pickerStyle == RetainTimeStyle) {
        self.datePicker.hidden = YES;
        self.leftLabel.hidden = NO;
        self.rightLabel.hidden = NO;
        self.pickerView.hidden = NO;
        self.upLine.hidden = NO;
        self.downLine.hidden = NO;
        self.alertLabel.hidden = YES;
        [self.pickerView reloadInputViews];
    } else if (pickerStyle == DeadlineStyle) {
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:63072000];
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.pickerView.hidden = YES;
        self.upLine.hidden = YES;
        self.downLine.hidden = YES;
        self.alertLabel.hidden = YES;
    } else if (pickerStyle == AlertDeadlineStyle) {
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = self.deadlineDate;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.pickerView.hidden = YES;
        self.upLine.hidden = YES;
        self.downLine.hidden = YES;
        self.alertLabel.hidden = YES;
    } else if (pickerStyle == AlertRetainStyle) {
        self.datePicker.hidden = NO;
        self.datePicker.minimumDate = nil;
        self.datePicker.maximumDate = nil;
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.pickerView.hidden = YES;
        self.upLine.hidden = YES;
        self.downLine.hidden = YES;
        self.alertLabel.hidden = NO;
    }
}

- (void)pullUp {
    [UIView animateWithDuration:0.35 animations:^{
        self.hidden = NO;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 264, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

- (void)pullDown {
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)cancelAction:(UIButton*)sender {
    [self pullDown];
}

- (void)sureAction:(UIButton*)sender {
    
    if (self.pickerStyle == RetainTimeStyle) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSureBtnWithFristItem:secondItem:)]) {
            [self.delegate clickSureBtnWithFristItem:self.firstItem secondItem:self.secondItem];
        }
    } else if (self.pickerStyle == DeadlineStyle) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSureBtnWithDate:)]) {
            self.deadlineDate = self.datePicker.date;
            [self.delegate clickSureBtnWithDate:self.datePicker.date];
        }
    } else if (self.pickerStyle == AlertDeadlineStyle) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSureBtnWithAlertDeadlineDate:)]) {
            [self.delegate clickSureBtnWithAlertDeadlineDate:self.datePicker.date];
        }
    } else if (self.pickerStyle == AlertRetainStyle) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickSureBtnWithAlertRetainDate:)]) {
            [self.delegate clickSureBtnWithAlertRetainDate:self.datePicker.date];
        }
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        NSArray *array = [self.retainTimeDataDict objectForKey:@"selectCount"];
        return array.count;
    } else {
        NSArray *array = [self.retainTimeDataDict objectForKey:@"unit"];
        return array.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSArray *array = [self.retainTimeDataDict objectForKey:@"selectCount"];
        return array[row];
    } else {
        NSArray *array = [self.retainTimeDataDict objectForKey:@"unit"];
        return array[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSArray *array = [self.retainTimeDataDict objectForKey:@"selectCount"];
        self.firstItem = array[row];
    } else {
        NSArray *array = [self.retainTimeDataDict objectForKey:@"unit"];
        self.secondItem = array[row];
    }
}

@end
