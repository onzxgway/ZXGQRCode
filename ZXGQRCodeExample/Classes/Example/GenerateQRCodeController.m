//
//  GenerateQRCodeController.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/24.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "GenerateQRCodeController.h"
#import "ZXGQRCode.h"

@interface GenerateQRCodeController () {
    NSMutableArray *_imgs;
}

@end

@implementation GenerateQRCodeController


- (void)viewDidLoad {
    [super viewDidLoad];
    _imgs = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    NSString *url = @"https://github.com/onzxgway/ZXGQRCode";
    CGSize size = CGSizeMake(150, 150);
    CGSize logoImageSize = CGSizeMake(30, 30);
    UIImage *one = [ZXGQRCodeTool generateQRCodeImageWithString:url imageSize:size];
    [_imgs addObject:one];
    
    UIImage *two = [ZXGQRCodeTool generateColoursQRCodeImageWithString:url imageSize:size rgbColor:[UIColor greenColor] backgroundColor:[UIColor blueColor]];
    [_imgs addObject:two];
    
    UIImage *three = [ZXGQRCodeTool generateLogoQRCodeImageWithString:url imageSize:size logoImageName:@"help" logoImageSize:logoImageSize];
    [_imgs addObject:three];
    
    UIImage *four = [ZXGQRCodeTool generateColoursLogoImageWithString:url imageSize:size rgbColor:[UIColor orangeColor] backgroundColor:[UIColor grayColor] logoImageName:@"help" logoImageSize:logoImageSize];
    [_imgs addObject:four];
    
    [self addImageView];
}

- (void)addImageView {
    
    CGFloat kSpacing = 20;
    NSInteger line = 2;
    CGFloat imgViewW = ([UIScreen mainScreen].bounds.size.width - (line + 1) * kSpacing) / line;
    
    for (int i = 0; i < 4; ++i) {
        CGFloat x = kSpacing + (kSpacing + imgViewW) * (i % line);
        CGFloat y = kSpacing + (kSpacing + imgViewW) * (i / line);
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.view addSubview:imgView];
        imgView.frame = CGRectMake(x, y, imgViewW, imgViewW);
        imgView.image = _imgs[i];
    }
    
}

@end
