//
//  TargetEditView.h
//  smallTarget
//
//  Created by 万治民 on 16/10/30.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TargetEditView;
@protocol TargetEditViewDelegate <NSObject, UITextViewDelegate>
@optional
- (void)textViewEndEditing:(TargetEditView *)targetEditView andCountRes:(NSInteger)res;
@end

@interface TargetEditView : UITextView
@property(nonatomic, weak) id<TargetEditViewDelegate> textViewDelegate;

- (instancetype)initWithtext:(NSString *)text andMaxLength:(NSInteger)maxLength;

@end
