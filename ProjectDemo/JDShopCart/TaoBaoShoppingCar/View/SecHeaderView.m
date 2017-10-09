//
//  SecHeaderView.m
//  淘宝购物车
//
//  Created by 朱献国 on 23/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "SecHeaderView.h"
#import "Masonry.h"
#import "TBButton.h"
#import "Const.h"
#import "SecHeaderModel.h"

@interface SecHeaderView ()
@property (nonatomic, strong) UIButton *titleBtn;//组标题按钮
@end

static NSString *const reuseID = @"SecHeaderView";

@implementation SecHeaderView

#pragma mark - APIs
- (instancetype)initWithTableView:(UITableView *)tableView {
    SecHeaderView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if (!headerFooterView) {
        headerFooterView = [[SecHeaderView alloc] initWithReuseIdentifier:reuseID];
    }
    return headerFooterView;
}

#pragma mark - override
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = SecHeaderColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIImage *selectedImg = [UIImage imageNamed:@"Selected"];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.width.mas_equalTo(selectedImg.size.width + 20);
    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.selectBtn.mas_right);
    }];
}

#pragma mark - lazy load
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [TBButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [self addSubview:_selectBtn];
    }
    return _selectBtn;
}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setTitle:@"" forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:NameSize];
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self addSubview:_titleBtn];
    }
    return _titleBtn;
}

#pragma mark - setter
- (void)setSecHeaderModel:(SecHeaderModel *)secHeaderModel {
    _secHeaderModel = secHeaderModel;
    self.selectBtn.selected = secHeaderModel.isSelected;
    [self.titleBtn setTitle:secHeaderModel.title forState:UIControlStateNormal];
}

@end
