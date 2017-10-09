//
//  PayView.h
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBButton;

@interface PayView : UIView
@property (nonatomic, strong) TBButton *selectAllBtn;//全选按钮
@property (nonatomic, strong) UILabel *totalPriceLabel;//总价标签
@property (nonatomic, strong) UIButton *payBtn;//结算按钮
@end
