//
//  ZXGQRCodeScanView.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/22.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "ZXGQRCodeScanView.h"
#import "ZXGQRCodeConfig.h"
#import "ZXGQRCodeTool.h"

#define kCornerLineOffset (_cornerLineWidth * 0.5)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

float const kMargin = 30.f;
float const kQRCodeScanLineSpace = 5.f;
float const kQRCodeScanLineOffsetY = 4.f;

@implementation ZXGQRCodeScanView {
    ZXGQRCodeConfig *_qrCodeConfig;
    CADisplayLink *_link;
    
    UIImageView *_qrlineImageView;
    CGFloat _qrlineOffsetY;
    CGFloat _qrlineScanMaxBorder;
    
    CGFloat _transparentAreaX;
}

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _cornerLineLength = 15;
        _cornerLineWidth = 2;
        _cornerLineColor = [UIColor whiteColor];
        
        CGFloat transparentAreaW = kScreenWidth - kScreenWidth * 0.15 * 2;
        _transparentAreaY = (kScreenHeight - transparentAreaW) / 2;//默认透明区域位置
        self.transparentArea = CGSizeMake(transparentAreaW, transparentAreaW);//默认透明区域大小

        _image = @"";//扫描线条图片名称
        _qrLineColor = [UIColor clearColor];
        
        _instructText = @"将二维码/条码放入框内，即可自动扫描";
        _instructFont = 12.0f;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self qrCodeLineInit];
}

- (void)drawRect:(CGRect)rect {
    //半透明的背景
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);
    CGContextAddRect(ctx, self.bounds);
    CGContextDrawPath(ctx, kCGPathFill);
    
    //透明区域
    CGRect transparentAreaRect = CGRectMake(_transparentAreaX, _transparentAreaY, _transparentArea.width, _transparentArea.height);
    CGContextClearRect(ctx, transparentAreaRect);
    
    //白色的边框
    CGContextAddRect(ctx, transparentAreaRect);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, 0.5);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //四个角的线
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
    CGRect charRect = [_instructText boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:0 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_instructFont]} context:nil];
    [_instructText drawInRect:CGRectMake((kScreenWidth - charRect.size.width) / 2, _transparentAreaY + _transparentArea.height + kMargin, charRect.size.width, 36) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:_instructFont]}];
}

#pragma mark - API
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

#pragma mark - init
- (UIImageView *)qrCodeLineInit {
    if (!_qrlineImageView) {
        _qrlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_transparentAreaX + kQRCodeScanLineSpace, _transparentAreaY + kQRCodeScanLineOffsetY, _qrLineSize.width, _qrLineSize.height)];
        _qrlineImageView.backgroundColor = _qrLineColor;
//        _qrlineImageView.hidden = YES;
        if ([_image isKindOfClass:[NSString class]]) {
            _qrlineImageView.image = [UIImage imageNamed:_image];
        }
        if ([_image isKindOfClass:[UIImage class]]) {
            _qrlineImageView.image = _image;
        }
        [self addSubview:_qrlineImageView];
    }
    return _qrlineImageView;
}

#pragma mark - private
- (void)startLineAnimate {

    if (_qrlineImageView.frame.origin.y > _qrlineScanMaxBorder) {
        [self qrScanLineHome];
        return;
    }
    
    _qrlineOffsetY += 1;
    _qrlineImageView.transform = CGAffineTransformMakeTranslation(0, _qrlineOffsetY);
    
}

// 扫描线条归位
- (void)qrScanLineHome {
    _qrlineImageView.transform = CGAffineTransformIdentity;
    _qrlineOffsetY = 0;
}

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

- (void)setTransparentArea:(CGSize)transparentArea {
    _transparentArea = transparentArea;
    
    _qrlineScanMaxBorder = _transparentAreaY + _transparentArea.height - kQRCodeScanLineOffsetY;
    _transparentAreaX = (kScreenWidth - transparentArea.width) / 2;
    _qrLineSize = CGSizeMake(transparentArea.width - kQRCodeScanLineSpace * 2, 2);
    [self setNeedsDisplay];
}

- (void)setTransparentAreaY:(CGFloat)transparentAreaY {
    _transparentAreaY = transparentAreaY;
    
    _qrlineScanMaxBorder = _transparentAreaY + _transparentArea.height - kQRCodeScanLineOffsetY;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *result = [metadataObjects objectAtIndex:0];
        
        if (result.stringValue != nil && ![result.stringValue isEqualToString:@""]) {
            if (self.qrCodeScanResult) {
                [self stopRunning];
                self.qrCodeScanResult(result.stringValue);
            }
            
            if ([self.resultTarget respondsToSelector:self.resultAction]) {
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
