//
//  ShoppingCarModel.m
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "ShoppingCarModel.h"
#import "ShoppingViewModel.h"

@implementation ShoppingCarModel

/**
 谁添加了观察者，谁一定要移除。
 （如果没有添加观察者，移除的时候，程序会carsh）
 */
#pragma mark - override
- (void)setShoppingViewModel:(ShoppingViewModel *)shoppingViewModel {
    _shoppingViewModel = shoppingViewModel;
    [self addObserver:_shoppingViewModel forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    ShoppingCarModel *shoppingCarModel = [[[self class] allocWithZone:zone] init];
//    shoppingCarModel.isSelected = self.isSelected;
    [shoppingCarModel setValue:@(self.isSelected) forKey:@"isSelected"];
    return shoppingCarModel;
}

- (void)dealloc {
    if (_shoppingViewModel) {
        [self removeObserver:_shoppingViewModel forKeyPath:@"isSelected"];
    }
}

@end
