//
//  ScanQRCodeController.m
//  ZXGQRCode
//
//  Created by Coder_ZXG on 2017/4/24.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "ScanQRCodeController.h"
#import "ZXGQRCode.h"
#import "ZXGQRCodeLoadingView.h"

@interface ScanQRCodeController () {
    ZXGQRCodeScanView *_qrCodeScanView;
    ZXGQRCodeLoadingView *_loadingView;
}

@end

@implementation ScanQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    
    [self addScanView];
    
    _loadingView = [[ZXGQRCodeLoadingView alloc] init];
    [self.view addSubview:_loadingView];
    _loadingView.frame = self.view.bounds;
    
}

- (void)addScanView {
    //第一种使用方式
    /*
     _qrCodeScanView = [[ZXGQRCodeScanView alloc] init];
     [_qrCodeScanView setQrCodeScanResult:^(NSString *result){
     NSLog(@"%@",result);
     }];
     */
    
    //第二种使用方式
    
//    _qrCodeScanView = [ZXGQRCodeScanView qrCodeScanViewWithResultBlock:^(NSString *result) {
//        NSLog(@"%@",result);
//    }];
    
    
    //第三种使用方式
    
     _qrCodeScanView = [ZXGQRCodeScanView qrCodeScanViewWithTarget:self resultAction:@selector(result:)];
    
    _qrCodeScanView.frame = self.view.bounds;
//    _qrCodeScanView.image = [UIImage imageNamed:@"line.pdf"];
    [self.view addSubview:_qrCodeScanView];
    //设置项
    //    [_qrCodeScanView setTransparentAreaY:80];
    //    [_qrCodeScanView setTransparentArea:CGSizeMake(100, 200)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startScan];
}

- (void)startScan {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_loadingView removeFromSuperview];
        [_qrCodeScanView startRunning];
    });
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_qrCodeScanView stopRunning];
}

- (void)result:(ZXGQRCodeScanView *)scanView {
    NSLog(@"%@",scanView.scanResult);
}

- (void)dealloc {
    NSLog(@"ScanQRCodeController dealloc");
}


@end
