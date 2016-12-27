//
//  TargetEditView.m
//  smallTarget
//
//  Created by 万治民 on 16/10/30.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "TargetEditView.h"

@interface TargetEditView()
// 最多输入字数
@property (nonatomic, assign)NSInteger maxLength;
// 差值
@property (nonatomic, assign)NSInteger res;

@end

@implementation TargetEditView

- (instancetype)initWithtext:(NSString *)text andMaxLength:(NSInteger)maxLength {
    
    if (self = [super init]) {
        self.text = text;
        self.font = [UIFont systemFontOfSize:14];
        self.maxLength = maxLength;
        self.res = self.maxLength;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// MARK: -通知监听方法
-(void)textViewEditChanged:(NSNotification *)notify{
    
    UITextView *textView = notify.object;
    NSString *toBeString = textView.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxLength) {
                textView.text = [toBeString substringToIndex:self.maxLength];
            }
            self.res = self.maxLength - textView.text.length;
            
            if (self.textViewDelegate) {
                [self.textViewDelegate textViewEndEditing:self andCountRes:self.res];
            }
        } else {
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            self.res = self.maxLength - textView.text.length - 1;
            if (self.textViewDelegate) {
                [self.textViewDelegate textViewEndEditing:self andCountRes:self.res];
            }
        }
        
    } else {
        
        if (toBeString.length > self.maxLength) {
            textView.text = [toBeString substringToIndex:self.maxLength];
        }
        self.res = self.maxLength-textView.text.length;
        
        if (self.textViewDelegate) {
            [self.textViewDelegate textViewEndEditing:self andCountRes:self.res];
        }
    }
    
}

@end
