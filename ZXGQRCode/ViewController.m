//
//  ViewController.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/21.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRCodeController.h"
#import "GenerateQRCodeController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.navigationItem.title = @"ZXGQRCode";
}

//扫描
- (IBAction)scanQRCode:(id)sender {
    [self.navigationController pushViewController:[[ScanQRCodeController alloc] init] animated:YES];
}

//生成
- (IBAction)generateQRCode:(id)sender {
    [self.navigationController pushViewController:[[GenerateQRCodeController alloc] init] animated:YES];
}

@end
