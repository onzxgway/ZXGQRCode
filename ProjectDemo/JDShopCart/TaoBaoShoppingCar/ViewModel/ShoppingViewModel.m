//
//  ShoppingViewModel.m
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "ShoppingViewModel.h"
#import "YYModel.h"
#import "ShoppingCarModel.h"
#import "SecHeaderModel.h"

@implementation ShoppingViewModel {
    RefreshTotalMoney _refreshTotalMoney;
}

#pragma mark - APIs
+ (void)getData:(Datas)datas  refresh:(RefreshTotalMoney)refreshTotalMoney {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *common = [dataDict objectForKey:@"common"];
    NSMutableArray *commonShoppingCarModels = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ShoppingCarModel class] json:common]];
    [commonShoppingCarModels enumerateObjectsUsingBlock:^(ShoppingCarModel * _Nonnull shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        shoppingCarModel.isSelected = YES;
        ShoppingViewModel *model = [[self alloc] init];
        [model setValue:refreshTotalMoney forKey:@"_refreshTotalMoney"];
        shoppingCarModel.shoppingViewModel = model;
    }];
    SecHeaderModel *secHeaderModel = [[SecHeaderModel alloc] init];//添加组头视图的模型
    secHeaderModel.title = @"家庭常备、居家生活";
    secHeaderModel.isSelected = YES;
    [commonShoppingCarModels insertObject:secHeaderModel atIndex:0];
    
    
    NSArray *kuajing = [dataDict objectForKey:@"kuajing"];
    NSMutableArray *kuajingShoppingCarModels = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ShoppingCarModel class] json:kuajing]];
    [kuajingShoppingCarModels enumerateObjectsUsingBlock:^(ShoppingCarModel * _Nonnull shoppingCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        shoppingCarModel.isSelected = YES;
        ShoppingViewModel *model = [[self alloc] init];
        [model setValue:refreshTotalMoney forKey:@"_refreshTotalMoney"];
        shoppingCarModel.shoppingViewModel = model;
    }];
    SecHeaderModel *secHeaderModelK = [[SecHeaderModel alloc] init];//添加组头视图的模型
    secHeaderModelK.title = @"原装进口全世界";
    secHeaderModelK.isSelected = YES;
    [kuajingShoppingCarModels insertObject:secHeaderModelK atIndex:0];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3.f];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (datas) {
                datas(@[commonShoppingCarModels,kuajingShoppingCarModels]);
            }
        });
        
    });
    
}

#pragma mark - private methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"isSelected" isEqualToString:keyPath] && _refreshTotalMoney) {
        _refreshTotalMoney();
    }
}

@end
