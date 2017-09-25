//
//  ZXGConst.h
//  ZXGQRCode
//
//  Created by Coder_ZXG on 2017/9/22.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

UIKIT_EXTERN CGFloat const LableMargin;           //说明文本 与 透明区域底部 的间距
UIKIT_EXTERN CGFloat const QRCodeScanLineMargin;  //水平扫描线条 与透明区域边框的水平间距
UIKIT_EXTERN CGFloat const QRCodeScanLineOffsetY; //水平扫描线条 扫描范围最大Y值相对于透明区域下边框的偏移量

#define kCornerLineOffset (_cornerLineWidth * 0.5)//边角线 与 透明区域边框 的偏移量
