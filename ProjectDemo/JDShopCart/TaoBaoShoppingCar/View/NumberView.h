//
//  NumberView.h
//  淘宝购物车
//
//  Created by 朱献国 on 21/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingCarModel;
@protocol NumberViewDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BtnOperaType) {
    BtnOperaTypeAdd,
    BtnOperaTypeSub
};

@interface NumberView : UIView

@property (nonatomic, strong, nonnull) ShoppingCarModel *shoppingCarModel;

@property (nonatomic, weak) id<NumberViewDelegate> delegate;

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UITextField *numTextField;

@end

@protocol NumberViewDelegate <NSObject>

- (void)numberView:(NumberView *)numberView opeaType:(BtnOperaType)btnOperaType;

@end

NS_ASSUME_NONNULL_END
