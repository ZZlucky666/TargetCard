//
//  ClearAdViewController.m
//  smallTarget
//
//  Created by Jack Zeng on 16/11/20.
//  Copyright © 2016年 Jack Zeng. All rights reserved.
//

#define kProductID @"MuBiaoKaPian"
#import "ClearAdViewController.h"
#import <StoreKit/StoreKit.h>
#import "MyAlertCenter.h"

@interface ClearAdViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (strong, nonatomic) UIButton *backBtn;
@property (nonatomic, strong) NSArray *validProducts;
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) SKProduct *validProduct;
@end

@implementation ClearAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fetchAvailableProducts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(15, 40, 36, 36);
    [self.backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 204)/2, 118, 204, 203)];
    imageView.image = [UIImage imageNamed:@"icon_money"];
    [self.view addSubview:imageView];
    
    CGFloat pointY;
    if (SCREEN_WIDTH > 320) {
        pointY = 380;
    } else {
        pointY = SCREEN_HEIGHT - 50;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, pointY, SCREEN_WIDTH, 30)];
    label.text = @"仅需1元，去除App内置广告";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 180, 44);
    btn.backgroundColor = UIColorFromRGB(0x1E95FF);
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [btn setTitle:@"去除广告" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (SCREEN_WIDTH > 320) {
        btn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 170);
    } else {
        btn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 80);
    }
    [btn addTarget:self action:@selector(didClickClearBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resumeBtn.frame = CGRectMake(0, 0, 70, 20);
    resumeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [resumeBtn setTitleColor:UIColorFromRGB(0x121B26) forState:UIControlStateNormal];
    [resumeBtn setTitle:@"已购买？" forState:UIControlStateNormal];
    if (SCREEN_WIDTH > 320) {
        resumeBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 170 + 50);
    } else {
        resumeBtn.center = CGPointMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 80);
    }
    [resumeBtn addTarget:self action:@selector(didClickResumeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeBtn];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didClickCancelBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickClearBtn {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"去除广告" message:@"支付一元，清除“时间轴”及“设置”页底部广告，确认支付？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didClickResumeBtn {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"已购买？" message:@"已购买过清除广告的服务，现在恢复？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            if (self.validProduct) {
                [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
            }
        }
    } else {
        if (buttonIndex == 1) {
            if (self.validProduct) {
                //小票 创建一个交易
                SKPayment *payment = [SKPayment paymentWithProduct:self.validProduct];
                //5.创建交易对象并添加到交易队列
                [[SKPaymentQueue defaultQueue]addPayment:payment];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchAvailableProducts {
    NSSet *productIdentifiers = [NSSet setWithObjects:kProductID, nil];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
    //创建监听对象 来监听交易队列中的交易对象的交易状态
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}

- (void)dealloc {
    //移除监听对象
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}


#pragma mark - SKProductsRequestDelegate
/**
 *  返回可销售的商品列表
 *
 *  @param request  请求对象
 *  @param response 返回数据
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.validProducts = response.products;
    for (SKProduct *product in response.products) {
        if ([product.productIdentifier isEqualToString:kProductID]) {
            self.validProduct = product;
        }
    }
}

#pragma mark -SKPaymentTransactionObserver
/**
 *  监听到交易队列中交易状态改变的时候就会调用
 *  @param queue        队列
 *  @param transactions 在队列交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    //非消耗品  才能被恢复购买
    /*
     SKPaymentTransactionStatePurchasing,    交易正在被添加到交易队列
     SKPaymentTransactionStatePurchased,     //交易已经在队列,用户已经付钱,客户端需要完成交易
     SKPaymentTransactionStateFailed,        //还没添加到队列中就取消或者失败了
     SKPaymentTransactionStateRestored,      // 交易被恢复购买,客户端需要完成交易
     SKPaymentTransactionStateDeferred NS_ENUM_AVAILABLE_IOS(8_0),   交易在队列中,交易状态不确定依赖别的参数参与
     */
    
    //7.如果交易状态购买成功  提供特殊服务
    for (SKPaymentTransaction *t in transactions) {
        if (t.transactionState == SKPaymentTransactionStatePurchased) {//交易完成
            [[MyAlertCenter defaultCenter]postAlertWithMessage:@"感谢您对支持，已清除广告"];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setBool:YES forKey:[NSString stringWithFormat:@"clearAd"]];
            [userDef synchronize];
            //结束交易完成
            [[SKPaymentQueue defaultQueue]finishTransaction:t];
            break;
        } else if (t.transactionState == SKPaymentTransactionStateRestored) {//已经购买过该商品
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setBool:YES forKey:[NSString stringWithFormat:@"clearAd"]];
            [userDef synchronize];
            [[MyAlertCenter defaultCenter]postAlertWithMessage:@"已为您清除广告"];
            //结束交易完成
            [[SKPaymentQueue defaultQueue]finishTransaction:t];
            break;
        }
    }
}

@end
