//
//  CommodityModel.h
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityModel : NSObject

@property (nonatomic, strong) NSNumber *auth_level;
@property (nonatomic, copy) NSString *biz_wholesale_price;
@property (nonatomic, copy) NSString *full_name;
@property (nonatomic, copy) NSString *is_spu;
@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, copy) NSString *item_size;
@property (nonatomic, copy) NSString *item_state;
@property (nonatomic, copy) NSString *market_price;
@property (nonatomic, copy) NSString *name_add;
@property (nonatomic, copy) NSString *sale_price;
@property (nonatomic, copy) NSString *sale_state;
@property (nonatomic, copy) NSString *stock_quantity;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

@end
