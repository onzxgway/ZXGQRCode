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
