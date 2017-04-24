//
//  ScanQRCodeController.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/24.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "ScanQRCodeController.h"
#import "ZXGQRCode.h"

@interface ScanQRCodeController () {
    ZXGQRCodeScanView *_qrCodeScanView;
}

@end

@implementation ScanQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //第一种使用方式
    /*
        _qrCodeScanView = [[ZXGQRCodeScanView alloc] init];
        [_qrCodeScanView setQrCodeScanResult:^(NSString *result){
            NSLog(@"%@",result);
        }];
     */
    
    //第二种使用方式
    
        _qrCodeScanView = [ZXGQRCodeScanView qrCodeScanViewWithResultBlock:^(NSString *result) {
            NSLog(@"%@",result);
        }];
    
    
    //第三种使用方式
    /*
        _qrCodeScanView = [ZXGQRCodeScanView qrCodeScanViewWithTarget:self resultAction:@selector(result:)];
    */
    
    _qrCodeScanView.frame = self.view.bounds;
    _qrCodeScanView.image = [UIImage imageNamed:@"line.pdf"];
    [self.view addSubview:_qrCodeScanView];
    //设置项
//    [_qrCodeScanView setTransparentAreaY:80];
//    [_qrCodeScanView setTransparentArea:CGSizeMake(100, 200)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_qrCodeScanView startRunning];
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
