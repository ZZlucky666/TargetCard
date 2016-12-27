//
//  TargetDetailFlowLayout.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/19.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "TargetDetailFlowLayout.h"

@implementation TargetDetailFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(SCREEN_WIDTH, 130);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
}

@end
