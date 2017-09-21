//
//  ZXGQRCodeScanView.h
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/22.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZXGScanResult)(NSString *);

@interface ZXGQRCodeScanView : UIView

/**
 透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;//透明的区域 的大小
@property (nonatomic, assign) CGFloat transparentAreaY;//透明的区域 的位置的Y值

/**
 扫描线条
 */
@property (copy,nonatomic)id image;//扫描线条图片，或者图片的名称，默认是@""
@property (nonatomic, assign) CGSize qrLineSize;// 默认宽度等于transparentArea宽度减去10，高度2
@property (strong,nonatomic)UIColor *qrLineColor;//扫描线条颜色，默认是clearColor

/**
 四个边角
 */
@property (nonatomic, assign) CGFloat cornerLineLength;// 边角线条长度，默认15
@property (nonatomic, assign) CGFloat cornerLineWidth;// 边角线条宽度，默认2
@property (strong,nonatomic)UIColor *cornerLineColor;// 边角线颜色，默认白色

/**
 底部说明文字
 */
@property (copy,nonatomic)NSString *instructText;//说明内容
@property (assign,nonatomic) CGFloat instructFont;//字体的大小，默认12

/**
 是否打开系统照明
 */
@property (assign,nonatomic)BOOL openSystemLight;

/**
 扫描结果回调
 */
@property (copy,nonatomic)ZXGScanResult qrCodeScanResult;

/**
 开始扫描
 */
- (void)startRunning;

/**
 停止扫描
 */
- (void)stopRunning;

/**
 创建对象1

 @param scanResult 扫描结果回调
 @return <#return value description#>
 */
+ (instancetype)qrCodeScanViewWithResultBlock:(ZXGScanResult)scanResult;

/** 回调对象 */
@property (weak, nonatomic) id resultTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL resultAction;
/** 扫描结果 */
@property (copy,nonatomic)NSString *scanResult; //只在调用类方法2时有值

/**
 创建对象类方法2

 @param target <#target description#>
 @param action <#action description#>
 @return <#return value description#>
 */
+ (instancetype)qrCodeScanViewWithTarget:(id)target resultAction:(SEL)action;

@end
