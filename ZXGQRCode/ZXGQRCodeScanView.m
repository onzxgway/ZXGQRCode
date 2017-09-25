//
//  ZXGQRCodeScanView.m
//  ZXGQRCode
//
//  Created by Coder_ZXG on 2017/4/22.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "ZXGQRCodeScanView.h"
#import "ZXGQRCodeConfig.h"
#import "ZXGQRCodeTool.h"
#import "ZXGConst.h"

@implementation ZXGQRCodeScanView {
    ZXGQRCodeConfig *_qrCodeConfig;//二维码处理器
    CADisplayLink *_link;//定时器
    
    UIImageView *_qrlineImageView;//水平扫描线条
    CGFloat _qrlineOffsetY;//水平扫描线条 每次垂直移动的距离
    CGFloat _qrlineScanMaxY;//水平扫描线条 扫描范围的最大Y值
    CGFloat _transparentAreaX;//透明区域位置的X值
}

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //边角线
        _cornerLineLength = 15;
        _cornerLineWidth = 2;
        _cornerLineColor = [UIColor whiteColor];
        
        //透明区域
        CGFloat transparentAreaW = ScreenWidth - ScreenWidth * 0.15 * 2;
        CGFloat transparentAreaH = transparentAreaW;
        _transparentAreaY = (ScreenHeight - transparentAreaH) * 0.5;//默认透明区域位置
        self.transparentAreaSize = CGSizeMake(transparentAreaW, transparentAreaH);//默认透明区域大小

        //扫描线条
        _image = @"ZXGQRCode.bundle/line@2x.png";//扫描线条图片名称
        _qrLineColor = [UIColor clearColor];
        
        //底部说明
        _instructText = @"将二维码/条码放入框内，即可自动扫描";
        _instructFont = 12.0f;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self getQRCodeLine];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//当前的绘图上下文
    //半透明的背景
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);//黑色 半透明
    CGContextAddRect(ctx, self.bounds);
    CGContextDrawPath(ctx, kCGPathFill);
    
    //透明区域
    CGRect transparentAreaRect = CGRectMake(_transparentAreaX, _transparentAreaY, _transparentAreaSize.width, _transparentAreaSize.height);
    CGContextClearRect(ctx, transparentAreaRect);
    
    //白色的边框
    CGContextAddRect(ctx, transparentAreaRect);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, 0.5);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //四个角线
    //左上
    CGContextMoveToPoint(ctx, transparentAreaRect.origin.x + kCornerLineOffset, transparentAreaRect.origin.y + _cornerLineLength);
    CGContextAddLineToPoint(ctx, transparentAreaRect.origin.x + kCornerLineOffset, transparentAreaRect.origin.y + kCornerLineOffset);
    CGContextAddLineToPoint(ctx, transparentAreaRect.origin.x + _cornerLineLength, transparentAreaRect.origin.y + kCornerLineOffset);
    CGContextSetLineWidth(ctx, _cornerLineWidth);
    
    //右上
    CGContextMoveToPoint(ctx, CGRectGetMaxX(transparentAreaRect) - kCornerLineOffset, transparentAreaRect.origin.y + _cornerLineLength);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(transparentAreaRect) - kCornerLineOffset, transparentAreaRect.origin.y + kCornerLineOffset);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(transparentAreaRect) - _cornerLineLength, transparentAreaRect.origin.y + kCornerLineOffset);
    CGContextSetLineWidth(ctx, _cornerLineWidth);
    
    //左下
    CGContextMoveToPoint(ctx, transparentAreaRect.origin.x + kCornerLineOffset, CGRectGetMaxY(transparentAreaRect) - _cornerLineLength);
    CGContextAddLineToPoint(ctx, transparentAreaRect.origin.x + kCornerLineOffset, CGRectGetMaxY(transparentAreaRect) - kCornerLineOffset);
    CGContextAddLineToPoint(ctx, transparentAreaRect.origin.x + _cornerLineLength, CGRectGetMaxY(transparentAreaRect) - kCornerLineOffset);
    CGContextSetLineWidth(ctx, _cornerLineWidth);
    
    //右下
    CGContextMoveToPoint(ctx, CGRectGetMaxX(transparentAreaRect) - kCornerLineOffset, CGRectGetMaxY(transparentAreaRect) - _cornerLineLength);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(transparentAreaRect) - kCornerLineOffset, CGRectGetMaxY(transparentAreaRect) - kCornerLineOffset);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(transparentAreaRect) - _cornerLineLength, CGRectGetMaxY(transparentAreaRect) - kCornerLineOffset);
    CGContextSetLineWidth(ctx, _cornerLineWidth);
    [_cornerLineColor setStroke];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //说明文字
    CGRect charRect = [_instructText boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:0 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_instructFont]} context:nil];
    [_instructText drawInRect:CGRectMake((ScreenWidth - charRect.size.width) * 0.5, _transparentAreaY + _transparentAreaSize.height + LableMargin, charRect.size.width, _instructFont + 4) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:_instructFont]}];
}

#pragma mark - APIs
+ (instancetype)qrCodeScanViewWithResultBlock:(ZXGScanResult)scanResult {
    ZXGQRCodeScanView *qrCodeScanView = [[self alloc] init];
    qrCodeScanView.qrCodeScanResult = scanResult;
    return qrCodeScanView;
}

+ (instancetype)qrCodeScanViewWithTarget:(id)target resultAction:(SEL)action {
    ZXGQRCodeScanView *qrCodeScanView = [[self alloc] init];
    qrCodeScanView.resultAction = action;
    qrCodeScanView.resultTarget = target;
    return qrCodeScanView;
}

- (void)startRunning {
    
    //判断相机是否可用
    if (![ZXGQRCodeTool authorizationStatusForCamera]) {
#ifdef DEBUG
        NSLog(@"相机不可用，请检查相机状态");
#endif
        return;
    }
    
    _qrlineImageView.hidden = NO;
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(startLineAnimate)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    if (!_qrCodeConfig) {
        _qrCodeConfig = [[ZXGQRCodeConfig alloc] init];
        [_qrCodeConfig createScanSystem:self resultDelegate:self];
    }
    
    [_qrCodeConfig.captureSession startRunning];
}

- (void)stopRunning {
    
    [self qrScanLineHome];
    _qrlineImageView.hidden = YES;
    [self removeCADisplayLink];
    
    [_qrCodeConfig.captureSession stopRunning];
}

#pragma mark - lazy load
- (UIImageView *)getQRCodeLine {
    if (!_qrlineImageView) {
        _qrlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_transparentAreaX + QRCodeScanLineMargin, _transparentAreaY + QRCodeScanLineOffsetY, _qrLineSize.width, _qrLineSize.height)];
        _qrlineImageView.backgroundColor = _qrLineColor;
        _qrlineImageView.hidden = YES;
        
        if ([_image isKindOfClass:[NSString class]]) _qrlineImageView.image = [UIImage imageNamed:_image];
        if ([_image isKindOfClass:[UIImage class]]) _qrlineImageView.image = _image;
        [self addSubview:_qrlineImageView];
    }
    return _qrlineImageView;
}

#pragma mark - private
// 扫描线条 垂直移动
- (void)startLineAnimate {

    if (_qrlineImageView.frame.origin.y > _qrlineScanMaxY) {
        [self qrScanLineHome];
        return;
    }
    
    _qrlineOffsetY += 2;
    _qrlineImageView.transform = CGAffineTransformMakeTranslation(0, _qrlineOffsetY);
    
}

// 扫描线条 归位
- (void)qrScanLineHome {
    _qrlineImageView.transform = CGAffineTransformIdentity;
    _qrlineOffsetY = 0;
}

// 移除定时器
- (void)removeCADisplayLink {
    [_link invalidate];
    _link = nil;
}

#pragma mark - Properties
- (void)setOpenSystemLight:(BOOL)openSystemLight {
    _openSystemLight = openSystemLight;
    
    if (_qrCodeConfig != nil && _qrCodeConfig.captureDevice != nil && [_qrCodeConfig.captureDevice hasTorch]) {
        [_qrCodeConfig.captureDevice lockForConfiguration:nil];
        [_qrCodeConfig.captureDevice setTorchMode:openSystemLight ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [_qrCodeConfig.captureDevice unlockForConfiguration];
    }
    
}

- (void)setInstructText:(NSString *)instructText {
    _instructText = instructText;
    [self setNeedsDisplay];
}

- (void)setInstructFont:(CGFloat)instructFont {
    _instructFont = instructFont;
    [self setNeedsDisplay];
}

- (void)setCornerLineColor:(UIColor *)cornerLineColor {
    _cornerLineColor = cornerLineColor;
    [self setNeedsDisplay];
}

- (void)setCornerLineLength:(CGFloat)cornerLineLength {
    _cornerLineLength = cornerLineLength;
    [self setNeedsDisplay];
}

- (void)setCornerLineWidth:(CGFloat)cornerLineWidth {
    _cornerLineWidth = cornerLineWidth;
    [self setNeedsDisplay];
}

- (void)setTransparentAreaSize:(CGSize)transparentAreaSize {
    _transparentAreaSize = transparentAreaSize;
    
    _qrlineScanMaxY = _transparentAreaY + _transparentAreaSize.height - QRCodeScanLineOffsetY;
    _transparentAreaX = (ScreenWidth - transparentAreaSize.width) * 0.5;
    _qrLineSize = CGSizeMake(transparentAreaSize.width - QRCodeScanLineMargin * 2, 2);
    [self setNeedsDisplay];
}

- (void)setTransparentAreaY:(CGFloat)transparentAreaY {
    _transparentAreaY = transparentAreaY;
    
    _qrlineScanMaxY = _transparentAreaY + _transparentAreaSize.height - QRCodeScanLineOffsetY;
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *result = [metadataObjects firstObject];
        
        if (result.stringValue && ![result.stringValue isEqualToString:@""]) {
            if (self.qrCodeScanResult) {
                [self stopRunning];
                self.qrCodeScanResult(result.stringValue);
            }
            
            if (self.resultTarget && self.resultAction && [self.resultTarget respondsToSelector:self.resultAction]) {
                [self stopRunning];
                _scanResult = result.stringValue;
_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
                [self.resultTarget performSelector:self.resultAction withObject:self];
_Pragma("clang diagnostic pop")
            }
        }
        
    }
}

@end
