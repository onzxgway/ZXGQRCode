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

@interface ZXGQRCodeConfig : NSObject

/**
 采集图像的设备（摄像头）
 */
@property (strong,nonatomic)AVCaptureDevice *captureDevice;

/**
 输入设备
 */
@property (strong,nonatomic)AVCaptureDeviceInput *captureDeviceInput;

/**
 输出设备
 */
@property (strong,nonatomic)AVCaptureMetadataOutput *captureMetadataOutput;

/**
 会话
 */
@property (strong,nonatomic)AVCaptureSession *captureSession;

/**
 <#Description#>
 */
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

/**
 创建一个默认的config

 @param view <#view description#>
 @param delegate 代理对象，可获取扫描结果
 */
- (void)createScanSystem:(ZXGQRCodeScanView *)view resultDelegate:(id)delegate;

@end
