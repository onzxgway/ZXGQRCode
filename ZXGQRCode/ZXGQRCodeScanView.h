//
//  ZXGQRCodeScanView.h
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/22.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXGScanResult)(NSString *);

@interface ZXGQRCodeScanView : UIView

//透明区域
@property (nonatomic, assign) CGSize transparentAreaSize;  //大小
@property (nonatomic, assign) CGFloat transparentAreaY;    //位置的Y值

//扫描线条
@property (nonatomic, copy  ) id image;            //扫描线条图片，或者图片的名称，默认是@"ZXGQRCode.bundle/line@2x.png"
@property (nonatomic, assign) CGSize qrLineSize;   //默认宽度等于transparentArea宽度减去10，高度2
@property (nonatomic, strong) UIColor *qrLineColor;//扫描线条颜色，默认是clearColor

//四个边角线
@property (nonatomic, assign) CGFloat cornerLineLength;//长度，默认15
@property (nonatomic, assign) CGFloat cornerLineWidth; //宽度，默认2
@property (nonatomic, strong) UIColor *cornerLineColor;//颜色，默认白色


@property (nonatomic, copy  ) NSString *instructText;//底部说明文本
@property (nonatomic, assign) CGFloat instructFont;  //字体的大小，默认12

//是否打开系统照明
@property (nonatomic, assign) BOOL openSystemLight;

//扫描结果回调
@property (nonatomic, copy  ) ZXGScanResult qrCodeScanResult;

@property (nonatomic, weak  ) id resultTarget;      // 回调对象
@property (nonatomic, assign) SEL resultAction;     // 回调方法
@property (nonatomic, copy  ) NSString *scanResult; // 扫描结果 只在调用类方法二时才有值


/**
 开始扫描
 */
- (void)startRunning;

/**
 停止扫描
 */
- (void)stopRunning;

/**
 创建对象类方法一

 @param scanResult 扫描结果回调Block
 @return 实例化对象
 */
+ (instancetype)qrCodeScanViewWithResultBlock:(ZXGScanResult)scanResult;

/**
 创建对象类方法二

 @param target obj
 @param action SEL
 @return 实例化对象
 */
+ (instancetype)qrCodeScanViewWithTarget:(id)target resultAction:(SEL)action;

@end

NS_ASSUME_NONNULL_END
