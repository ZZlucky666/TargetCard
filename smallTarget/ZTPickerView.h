//
//  ZTPickerView.h
//  smallTarget
//
//  Created by Jack Zeng on 16/10/31.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PickerViewStyle) {
    RetainTimeStyle,
    DeadlineStyle,
    AlertDeadlineStyle,
    AlertRetainStyle,
};

@protocol ZTPickerViewDelegate<NSObject>
@optional
- (void)clickSureBtnWithFristItem:(NSString *)fristItem secondItem:(NSString *)secondItem;
- (void)clickSureBtnWithDate:(NSDate *)deadline;
- (void)clickSureBtnWithAlertDeadlineDate:(NSDate *)alertDate;
- (void)clickSureBtnWithAlertRetainDate:(NSDate *)alertDate;
@end

@interface ZTPickerView : UIView

@property (assign, nonatomic) PickerViewStyle pickerStyle;
@property (nonatomic, weak) id<ZTPickerViewDelegate> delegate;

-(void)pullUp;
- (void)pullDown;

@end
