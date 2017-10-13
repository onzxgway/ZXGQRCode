//
//  ViewController.m
//  ZXGQRCodeExample
//
//  Created by Coder_ZXG on 2017/9/22.
//  Copyright © 2017年 onzxgway. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRCodeController.h"
#import "GenerateQRCodeController.h"
#import "SVProgressHUD.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.navigationItem.title = @"ZXGQRCode";
}

//扫描
- (IBAction)scanQRCode:(id)sender {
    //判断 是模拟器 还是真机
#if TARGET_IPHONE_SIMULATOR //simulator
    [SVProgressHUD showErrorWithStatus:@"not support Simulator"];
    [SVProgressHUD dismissWithDelay:1.0f];
#elif TARGET_OS_IPHONE  //device
    [self.navigationController pushViewController:[[ScanQRCodeController alloc] init] animated:YES];
#endif
}

//生成
- (IBAction)generateQRCode:(id)sender {
    [self.navigationController pushViewController:[[GenerateQRCodeController alloc] init] animated:YES];
}

@end
