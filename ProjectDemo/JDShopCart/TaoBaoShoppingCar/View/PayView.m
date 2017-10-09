//
//  PayView.m
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "PayView.h"
#import "Const.h"
#import "TBButton.h"

static CGFloat const SelectedBtnW = 66;
static CGFloat const PayBtnW = 88;

@implementation PayView

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CellColor;
        [self setupSubviews:frame];
    }
    return self;
}

#pragma mark - private methods
- (void)setupSubviews:(CGRect)frame {
    //
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    topLine.backgroundColor = DivideLineColor;
    [self addSubview:topLine];
    //
    UIImage *selectedImg = [UIImage imageNamed:@"Selected"];
    _selectAllBtn = [TBButton buttonWithType:UIButtonTypeCustom];
    _selectAllBtn.frame = CGRectMake(0, 0, SelectedBtnW, frame.size.height);
    [self addSubview:_selectAllBtn];
    [_selectAllBtn setSelected:YES];
    [_selectAllBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [_selectAllBtn setImage:selectedImg forState:UIControlStateSelected];
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [_selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:SelectBtnSize];
    //
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(frame.size.width - PayBtnW, 0, PayBtnW, frame.size.height);
    [self addSubview:_payBtn];
    [_payBtn setBackgroundColor:[UIColor redColor]];
    [_payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:PayBtnSize];
    //
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.frame = CGRectMake(CGRectGetMaxX(_selectAllBtn.frame), 0, frame.size.width - CGRectGetWidth(_selectAllBtn.frame) - CGRectGetWidth(_payBtn.frame), frame.size.height);
    [self addSubview:_totalPriceLabel];
    _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
    _totalPriceLabel.text = @" 合计:￥7778.00";
    _totalPriceLabel.font = [UIFont systemFontOfSize:TotalPriceLabelSize];
}

@end
