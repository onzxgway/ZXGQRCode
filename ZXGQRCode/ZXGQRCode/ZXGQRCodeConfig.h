//
//  ZXGQRCodeConfig.h
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/22.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class ZXGQRCodeScanView;

NS_ASSUME_NONNULL_BEGIN

@interface ZXGQRCodeConfig : NSObject

@property (strong,nonatomic)AVCaptureDevice            *captureDevice;//采集图像的设备（摄像头）

@property (strong,nonatomic)AVCaptureDeviceInput       *captureDeviceInput;//输入设备

@property (strong,nonatomic)AVCaptureMetadataOutput    *captureMetadataOutput;//输出设备

@property (strong,nonatomic)AVCaptureSession           *captureSession;//会话

@property (strong,nonatomic)AVCaptureVideoPreviewLayer *previewLayer;//预览图层

/**
 创建一个默认的config

 @param view 扫描界面View
 @param delegate 代理对象，可获取扫描结果
 */
- (void)createScanSystem:(ZXGQRCodeScanView *)view resultDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
