//
//  ZXGQRCodeLoadingView.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/24.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "ZXGQRCodeLoadingView.h"

int const kView_Size_W = 100;
int const kView_Size_H = 40;


@implementation ZXGQRCodeLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor blackColor];
    //
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_indicatorView startAnimating];
    [self addSubview:_indicatorView];
    
    //
    _titleLabel           = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font      = [UIFont systemFontOfSize:15.0f];
    _titleLabel.text      = @"正在加载...";
    [_titleLabel sizeToFit];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _indicatorView.center = CGPointMake(self.center.x, self.center.y - _indicatorView.frame.size.height - 5);
    
    _titleLabel.center    = CGPointMake(self.center.x, self.center.y + 5);
}

@end
