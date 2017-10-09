//
//  Const.h
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>
//宏的结尾 不要加冒号 
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

UIKIT_EXTERN CGFloat const PayViewH;//下部结账view的高度
UIKIT_EXTERN CGFloat const CellH;   //cell的高度

//***********CELL**************//
UIKIT_EXTERN CGFloat const NameSize; //名称字体的大小
UIKIT_EXTERN CGFloat const PriceSize;//价格字体的大小
UIKIT_EXTERN CGFloat const NumSize;  //数量字体的大小
UIKIT_EXTERN CGFloat const TipSize;  //尺寸字体的大小

//***********PayView**************//
UIKIT_EXTERN CGFloat const SelectBtnSize;       //全选按钮字体的大小
UIKIT_EXTERN CGFloat const PayBtnSize;          //结算按钮字体的大小
UIKIT_EXTERN CGFloat const TotalPriceLabelSize; //总价字体的大小

#define spTableViewH (ScreenH - self.navigationController.navigationBar.bounds.size.height - 20 - PayViewH)//上部商品view的高度

#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.f]

#define CellColor [UIColor whiteColor]
#define SecHeaderColor [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.f]
#define TableBGColor [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.f]

#define BorderColor [UIColor colorWithRed:199 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1.f]
#define DivideLineColor [UIColor colorWithRed:199 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1.f]
