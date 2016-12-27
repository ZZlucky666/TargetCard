//
//  UIView+CornerRadius.h
//  
//
//  Created by Jack Zeng on 16/4/19.
//
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

@end
