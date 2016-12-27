//
//  AddViewController.h
//  smallTarget
//
//  Created by 万治民 on 16/10/30.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#import "STBaseViewController.h"
#import "FristModel+CoreDataClass.h"

@interface AddViewController : STBaseViewController

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) FristModel *fModel;

@property (nonatomic, copy) void (^didupdatedCallBack)(NSString *title);

@end
