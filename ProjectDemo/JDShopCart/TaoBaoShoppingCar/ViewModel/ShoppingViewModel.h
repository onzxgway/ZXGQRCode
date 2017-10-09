//
//  ShoppingViewModel.h
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Datas)(NSArray *);
typedef void(^RefreshTotalMoney)();

@interface ShoppingViewModel : NSObject

+ (void)getData:(Datas)datas refresh:(RefreshTotalMoney)refreshTotalMoney;

@end
