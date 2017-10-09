//
//  ShoppingCarModel.h
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "CommodityModel.h"
@class ShoppingViewModel;

@interface ShoppingCarModel : BaseModel<NSCopying>

@property (nonatomic, copy) NSString *count; //商品选中数量
@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, strong) CommodityModel *item_info;
@property (nonatomic, copy) NSString *item_size;

@property (nonatomic, strong) ShoppingViewModel *shoppingViewModel;

@end
