//
//  MainTableViewCell.m
//  smallTarget
//
//  Created by 万治民 on 16/10/29.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#import "MainTableViewCell.h"
#import "UIView+CornerRadius.h"

@interface MainTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) CGAffineTransform viewTransform;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xF9F9F9);
    self.contentView.cornerRadius = 7.5;
    self.backView.cornerRadius = 7.5;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerHandler:)];
    self.panGestureRecognizer.delegate = self;
    [self.backView addGestureRecognizer:self.panGestureRecognizer];
    self.clipsToBounds = NO;
    self.backView.clipsToBounds = NO;
    self.backView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,5);
    self.backView.layer.shadowOpacity = 0.18;
    self.backView.layer.shadowRadius = 6;
    self.transform = CGAffineTransformIdentity;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTimeWithSeconds:(NSInteger)seconds {
    if (self.countDownView == nil) {
        self.countDownView = [[CountDownView alloc]initWithFrame:CGRectMake(0, 0, 179, 26) andRemainSeconds:seconds];
    }
    [self.timeView addSubview:self.countDownView];
}

static const CGFloat kSlideWidth = 80;
static const CGFloat kSlideWidthDelta = 0.08;

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.panGestureRecognizer == gestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self.backView];
        return fabs(point.x) > fabs(point.y);
    } else {
        return NO;
    }
}

#pragma mark - Event Handler
- (void)panGestureRecognizerHandler:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint movePoint = [gestureRecognizer translationInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.backView.frame.origin.x - self.frame.origin.x < 0) {
                self.isLeft = YES;
                self.isRight = NO;
            } else if (self.backView.frame.origin.x - self.frame.origin.x > 0) {
                self.isRight = YES;
                self.isLeft = NO;
            } else {
                self.isLeft = NO;
                self.isRight = NO;
            }
        }
        case UIGestureRecognizerStateChanged: {
            if (self.isLeft) {
                self.viewTransform = CGAffineTransformMakeTranslation(- kSlideWidth * 0.25 - 30, 0);
            } else if (self.isRight) {
                self.viewTransform = CGAffineTransformMakeTranslation(kSlideWidth * 0.25 + 30, 0);
            } else {
                self.viewTransform = CGAffineTransformMakeTranslation(0, 0);
            }
            self.viewTransform = CGAffineTransformTranslate(self.viewTransform, movePoint.x, 0);
            self.backView.transform = self.viewTransform;
//            CGPoint point = [gestureRecognizer translationInView:self];
//            CGFloat offset = point.x;
//            if (offset >= kSlideWidth) {
//                offset = kSlideWidth + (offset - kSlideWidth) * kSlideWidthDelta;
//                if (_parent.delegate && [_parent.delegate respondsToSelector:@selector(tableView:slideToRightWithIndexPath:)]) {
//                    id<UITableViewCellSlideDelegate> delegate = (id<UITableViewCellSlideDelegate>)_parent.delegate;
//                    [delegate tableView:_parent slideToRightWithIndexPath:_indexPath];
//                }
//            } else if (offset <= -kSlideWidth) {
//                offset = -kSlideWidth + (offset + kSlideWidth) * kSlideWidthDelta;
//                if (_parent.delegate && [_parent.delegate respondsToSelector:@selector(tableView:slideToLeftWithIndexPath:)]) {
//                    id<UITableViewCellSlideDelegate> delegate = (id<UITableViewCellSlideDelegate>)_parent.delegate;
//                    [delegate tableView:_parent slideToLeftWithIndexPath:_indexPath];
//                }
//            }
            break;
        }
        default:{
            if (fabs(movePoint.x) > kScreenWidth*0.25) {
                CGFloat offsetX = movePoint.x>0 ? kScreenWidth : -kScreenWidth;
                if (self.isRight || self.isLeft) {
                    self.isLeft = NO;
                    self.isRight = NO;
                    offsetX = 0;
                } else if (offsetX > 0) {
                    self.isRight = YES;
                } else if (offsetX < 0) {
                    self.isLeft = YES;
                }
                [UIView animateWithDuration:0.4 animations:^{
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    transform = CGAffineTransformTranslate(transform, offsetX * 0.25, 0);
                    [self.backView setTransform:transform];
                } completion:^(BOOL finished) {
                }];
            }else{
                self.isLeft = NO;
                self.isRight = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    CGAffineTransform transform = CGAffineTransformIdentity;
                    transform = CGAffineTransformTranslate(transform, 0, 0);
                    [self.backView setTransform:transform];
                } completion:^(BOOL finished) {
                   
                }];
            }
        }
            break;
    }
}

@end
