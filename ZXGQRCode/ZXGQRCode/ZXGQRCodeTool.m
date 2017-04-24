//
//  ZXGQRCodeScanTool.m
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/24.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import "ZXGQRCodeTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation ZXGQRCodeTool

#pragma mark - API
//相机是否授权
+ (BOOL)authorizationStatusForCamera {
    //1
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) return NO;  //未检测到摄像头
    //2
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            return YES;
            break;
        case AVAuthorizationStatusDenied:
            return NO;
            break;
        case AVAuthorizationStatusRestricted:
            return NO;
            break;
        case AVAuthorizationStatusNotDetermined: {
            __block BOOL result;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    // 第一次询问用户允许当前应用访问相机
                    result = YES;
                } else {
                    // 第一次询问用户不允许当前应用访问相机
                    result = NO;
                }
            }];
            return result;
        }
            break;
        default:
            break;
    }
    
    return NO;
}

//图册是否授权
+ (BOOL)authorizationStatusForAlbum {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    switch (status) {
        case PHAuthorizationStatusAuthorized:
            return YES;
            break;
        case PHAuthorizationStatusDenied:
            return NO;
            break;
        case PHAuthorizationStatusRestricted:
            return NO;
            break;
        case PHAuthorizationStatusNotDetermined: {
            __block BOOL result;
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    result = YES;
                } else {
                    result = NO;
                }
            }];
            return result;
        }
            break;
        default:
            break;
    }
    
    return NO;
}

//解析二维码图片
+ (NSString *)parseQRCodeImage:(UIImage *)qrCodeImage {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:qrCodeImage.CIImage];
    if (features == nil || features.count <= 0) return @"";
    
    CIQRCodeFeature *feature = [features objectAtIndex:0];
    return feature.messageString;
}

//生成黑白的二维码图片
+ (UIImage *)generateQRCodeImageWithString:(NSString *)str
                                 imageSize:(CGSize)imageSize {
    return [self generateLogoQRCodeImageWithString:str imageSize:imageSize logoImageName:nil logoImageSize:CGSizeZero];
}

//生成彩色的二维码图片
+ (UIImage *)generateColoursQRCodeImageWithString:(NSString *)str
                                        imageSize:(CGSize)imageSize
                                         rgbColor:(UIColor *)rgbColor
                                  backgroundColor:(UIColor *)backgroundColor {
    
    return [self generateColoursLogoImageWithString:str imageSize:imageSize rgbColor:rgbColor backgroundColor:backgroundColor logoImageName:nil logoImageSize:CGSizeZero];
}

//生成黑白带logo的二维码图片
+ (UIImage *)generateLogoQRCodeImageWithString:(NSString *)string
                                     imageSize:(CGSize)imageSize
                                 logoImageName:(NSString *)logoImageName
                                 logoImageSize:(CGSize)logoImageSize {
    
    UIImage *resultImg = [self generateUIImageFormCIImage:[self generateQRCodeImageWithString:string] imageSize:imageSize];
    return [self generateLogoImageWithImage:resultImg imageSize:imageSize logoImageName:logoImageName logoImageSize:logoImageSize];
    
}

//生成彩色带logo的二维码图片
+ (UIImage *)generateColoursLogoImageWithString:(NSString *)string
                                      imageSize:(CGSize)imageSize
                                       rgbColor:(UIColor *)rgbColor
                                backgroundColor:(UIColor *)backgroundColor
                                  logoImageName:(NSString *)logoImageName
                                  logoImageSize:(CGSize)logoImageSize {
    CIImage *ciImage = [self generateColoursImageWithString:string rgbColor:rgbColor backgroundColor:backgroundColor];
    UIImage *img = [self generateUIImageFormCIImage:ciImage imageSize:imageSize];
    //[UIImage imageWithCIImage:ciImage]
    return [self generateLogoImageWithImage:img imageSize:imageSize logoImageName:logoImageName logoImageSize:logoImageSize];
}

#pragma mark - private
//生成普通的CIImage
+ (CIImage *)generateQRCodeImageWithString:(NSString *)str {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[str dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"]; // 通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];// 设置二维码的纠错水平，纠错水平越高，可以污损的范围越大
    return [filter outputImage];
}

//生成彩色的CIImage
+ (CIImage *)generateColoursImageWithString:(NSString *)string
                               rgbColor:(UIColor *)rgbColor
                        backgroundColor:(UIColor *)backgroundColor {
    CIImage *ciImage = [self generateQRCodeImageWithString:string];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];// 创建颜色滤镜
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"]; // 通过kvo方式给一个字符串，生成二维码
    
    [filter setValue:[CIColor colorWithCGColor:rgbColor.CGColor] forKey:@"inputColor0"];// 替换颜色
    [filter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];// 替换背景颜色
    return [filter outputImage];
}


//根据CIImage生成指定大小的UIImage
+ (UIImage *)generateUIImageFormCIImage:(CIImage *)image imageSize:(CGSize)imageSize {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imageSize.width / CGRectGetWidth(extent), imageSize.height / CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width  = CGRectGetWidth(extent)  * scale;
    size_t height = CGRectGetHeight(extent) * scale;

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image
                                           fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    // 3.生成原图
    return [UIImage imageWithCGImage:scaledImage];
}

//给UIImage中间添加水印图片  注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
+ (UIImage *)generateLogoImageWithImage:(UIImage *)originImage
                              imageSize:(CGSize)imageSize
                          logoImageName:(NSString *)logoImageName
                          logoImageSize:(CGSize)logoImageSize {
    if (CGSizeEqualToSize(logoImageSize, CGSizeZero) || logoImageName == nil || [logoImageName isEqualToString:@""]) return originImage;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [originImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    [[UIImage imageNamed:logoImageName] drawInRect:CGRectMake((imageSize.width - logoImageSize.width) / 2.0, (imageSize.height - logoImageSize.height) / 2.0, logoImageSize.width, logoImageSize.height)];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

@end
