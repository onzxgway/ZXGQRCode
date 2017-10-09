//
//  ShoppingCarCell.h
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCarModel;
@class TBButton;
@class NumberView;
@protocol ShoppingCarCellDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCarCell : UITableViewCell

@property (nonatomic, strong, nonnull) ShoppingCarModel *shoppingCarModel;
@property (nonatomic, weak) id<ShoppingCarCellDelegate> delegate;
@property (nonatomic, strong) TBButton *selectBtn;//按钮;
@property (nonatomic, strong) NumberView *numberView;//加减数量

- (nullable instancetype)initWithStyle:(UITableViewCellStyle)style tableView:(nonnull UITableView *)tableView;

@end


@protocol ShoppingCarCellDelegate <NSObject>

- (void)ShoppingCarCell:(ShoppingCarCell *)shoppingCarCell;

@end

NS_ASSUME_NONNULL_END
