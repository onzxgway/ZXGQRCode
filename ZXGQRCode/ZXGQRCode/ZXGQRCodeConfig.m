//
//  ZXGQRCodeConfig.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/22.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "ZXGQRCodeConfig.h"
#import "ZXGQRCodeScanView.h"

@implementation ZXGQRCodeConfig

#pragma mark - APIs
- (void)createScanSystem:(ZXGQRCodeScanView *)view resultDelegate:(id)delegate {
    //1,采集图像的设备（摄像头）
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2,输入设备
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:NULL];
    
    //3,输出设备
    _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureMetadataOutput setMetadataObjectsDelegate:delegate queue:dispatch_get_main_queue()];
    
    //4,会话
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    if ([_captureSession canAddOutput:_captureMetadataOutput]) {
        [_captureSession addOutput:_captureMetadataOutput];
    }
    
    //5,设置扫码支持的编码格式
    [_captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    //6,实例化预览图层
    _previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _previewLayer.frame = view.frame;
    _previewLayer.videoGravity = AVLayerVideoGravityResize;//显示的区域等于设置的frame值，不要缩放
    
    view.backgroundColor = [UIColor clearColor];
    [view.superview.layer insertSublayer:_previewLayer atIndex:0];
    
    //7.设置扫描区域
    CGFloat viewW = CGRectGetWidth(view.frame);
    CGFloat viewH = CGRectGetHeight(view.frame);
    CGFloat res = [[view valueForKey:@"_transparentAreaX"] floatValue];
    CGRect rect = (CGRect){{res,view.transparentAreaY},view.transparentAreaSize};
    [_captureMetadataOutput setRectOfInterest:CGRectMake(rect.origin.y / viewH,
                                                         rect.origin.x / viewW,
                                                         rect.size.height / viewH,
                                                         rect.size.width / viewW)];
}

@end
