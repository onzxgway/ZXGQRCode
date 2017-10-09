//
//  NumberView.m
//  淘宝购物车
//
//  Created by 朱献国 on 21/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "NumberView.h"
#import "Const.h"
#import "ShoppingCarModel.h"

@implementation NumberView

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = BorderColor.CGColor;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        [self addSubviews:frame];
    }
    return self;
}

#pragma mark - private
- (void)addSubviews:(CGRect)frame {
    //减
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subBtn.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
    [_subBtn setImage:[UIImage imageNamed:@"sub_normal"] forState:UIControlStateNormal];
    [_subBtn setImage:[UIImage imageNamed:@"sub_no"] forState:UIControlStateDisabled];
    [_subBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _subBtn.tag = BtnOperaTypeSub;
    [self addSubview:_subBtn];
    //加
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(frame.size.width - frame.size.height, 0, frame.size.height, frame.size.height);
    [self addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.tag = BtnOperaTypeAdd;
    [_addBtn setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"add_no"] forState:UIControlStateDisabled];
    //数量
    _numTextField = [[UITextField alloc] init];
    _numTextField.frame = CGRectMake(CGRectGetMaxX(_subBtn.frame), 0, frame.size.width - frame.size.height * 2, CGRectGetHeight(_subBtn.frame));
    [self addSubview:_numTextField];
    _numTextField.textAlignment = NSTextAlignmentCenter;
    _numTextField.font = [UIFont systemFontOfSize:NumSize];
}

#pragma mark - setter
- (void)setShoppingCarModel:(ShoppingCarModel *)shoppingCarModel {
    _numTextField.text = shoppingCarModel.count;
    NSInteger count = [shoppingCarModel.count integerValue];
    NSInteger stock_quantity = [shoppingCarModel.item_info.stock_quantity integerValue];
    _subBtn.enabled = (count == 1) ? NO: YES;
    _addBtn.enabled = (count >= stock_quantity) ? NO: YES;
}

#pragma mark - click
- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberView:opeaType:)]) {
        [self.delegate numberView:self opeaType:btn.tag];
    }
}

@end
