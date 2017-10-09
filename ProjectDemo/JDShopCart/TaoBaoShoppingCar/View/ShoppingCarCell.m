//
//  ShoppingCarCell.m
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "ShoppingCarCell.h"
#import "Const.h"
#import "TBButton.h"
#import "NumberView.h"
#import "UIImageView+WebCache.h"
#import "ShoppingCarModel.h"
#import "CommodityModel.h"

static NSString *const reuseID = @"ShoppingCarCell";

@implementation ShoppingCarCell {
    UIImageView *_littleImg;//图片
    UILabel *_titleLabel;   //标题
    UILabel *_sizeLabel;    //尺寸
    UILabel *_priceLabel;   //价格
}

#pragma mark - APIs
- (nullable instancetype)initWithStyle:(UITableViewCellStyle)style tableView:(nonnull UITableView *)tableView {
    ShoppingCarCell *shoppingCarCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!shoppingCarCell) {
        shoppingCarCell = [[ShoppingCarCell alloc] initWithStyle:style reuseIdentifier:reuseID];
    }
    
    return shoppingCarCell;
}

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = CellColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

#pragma mark - private methods
- (void)addSubviews {
    //按钮
    UIImage *unselectedImg = [UIImage imageNamed:@"Unselected"];
    _selectBtn = [TBButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = (CGRect){{0,0},{unselectedImg.size.width + 20,CellH}};
    [self.contentView addSubview:_selectBtn];
    [_selectBtn setImage:unselectedImg forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //图片
    _littleImg = [[UIImageView alloc] init];
    _littleImg.frame = (CGRect){{CGRectGetMaxX(_selectBtn.frame), 10},{CellH - 20,CellH - 20}};
    [self.contentView addSubview:_littleImg];
    _littleImg.layer.borderWidth = 0.5;
    _littleImg.layer.borderColor = BorderColor.CGColor;
    _littleImg.layer.cornerRadius = 2;
    _littleImg.layer.masksToBounds = YES;

    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = (CGRect){{CGRectGetMaxX(_littleImg.frame) + 10, CGRectGetMinY(_littleImg.frame)},{ScreenW - CGRectGetMaxX(_littleImg.frame) - 10 - 10, NameSize + 4}};
    [self.contentView addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:NameSize];
    _titleLabel.backgroundColor = CellColor;
    //尺寸
    _sizeLabel = [[UILabel alloc] init];
    _sizeLabel.frame = (CGRect){{CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)},{CGRectGetWidth(_titleLabel.frame),CGRectGetHeight(_titleLabel.frame)}};
    [self.contentView addSubview:_sizeLabel];
    _sizeLabel.textAlignment = NSTextAlignmentLeft;
    _sizeLabel.font = [UIFont systemFontOfSize:NameSize];
    _sizeLabel.backgroundColor = CellColor;
    //加减数量
    UIImage *img = [UIImage imageNamed:@"sub_normal"];
    CGFloat _numberViewH = img.size.height - 4;
    CGFloat _numberViewW = _numberViewH * 3.5;
    _numberView = [[NumberView alloc] initWithFrame:(CGRect){{ScreenW - _numberViewW - 10, CGRectGetMaxY(_littleImg.frame) - _numberViewH},{_numberViewW, _numberViewH}}];
    [self.contentView addSubview:_numberView];
    _numberView.backgroundColor = CellColor;
    //价格
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.frame = (CGRect){{CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_littleImg.frame) - 22 -(CGRectGetHeight(_numberView.frame) - 22) * 0.5},{ScreenW - CGRectGetMinX(_titleLabel.frame) - CGRectGetWidth(_numberView.frame) - 10 - 10, 22}};
    [self.contentView addSubview:_priceLabel];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.font = [UIFont systemFontOfSize:PriceSize];
    _priceLabel.backgroundColor = CellColor;
    _priceLabel.textColor = [UIColor redColor];

}

#pragma mark - view click
- (void)selectBtnClick:(UIButton *)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShoppingCarCell:)]) {
        [self.delegate ShoppingCarCell:self];
    }
}



#pragma mark - setter
- (void)setShoppingCarModel:(ShoppingCarModel *)shoppingCarModel {
    _shoppingCarModel = shoppingCarModel;
    CommodityModel *commodityModel = shoppingCarModel.item_info;
    
    //选择按钮
    _selectBtn.selected = shoppingCarModel.isSelected;
    //图片
    [_littleImg sd_setImageWithURL:[NSURL URLWithString:commodityModel.icon] placeholderImage:[UIImage imageNamed:@"placehold"]];
    //标题
    _titleLabel.text = commodityModel.name;
    //尺寸
    _sizeLabel.text = commodityModel.full_name;
    //价格
    NSString *price = [NSString stringWithFormat:@"￥%@",commodityModel.sale_price];
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:price attributes:nil];
    [priceStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PriceSize + 4]} range:NSMakeRange(1, priceStr.length - 4)];
    _priceLabel.attributedText = priceStr;
    //
    _numberView.shoppingCarModel = shoppingCarModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
