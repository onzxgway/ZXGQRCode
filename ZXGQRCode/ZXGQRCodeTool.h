//
//  ZXGQRCodeScanTool.h
//  ZXGQRCode
//
//  Created by san_xu on 2017/4/24.
//  Copyright © 2017年 com.zxg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGQRCodeTool : NSObject

/**
 相机是否授权

 @return YES 授权，NO 未授权
 */
+ (BOOL)authorizationStatusForCamera;


/**
 图册是否授权
 
 @return YES 授权，NO 未授权
 */
+ (BOOL)authorizationStatusForAlbum;


/**
 解析二维码图片

 @param qrCodeImage 待解析的二维码图片
 @return 解析结果
 */
+ (NSString *)parseQRCodeImage:(UIImage *)qrCodeImage;

/**
  生成黑白的二维码图片

 @param str 要生成二维码的数据
 @param imageSize 指定生成的二维码图片size
 @return 生成的二维码图片
 */
+ (UIImage *)generateQRCodeImageWithString:(NSString *)str
                                 imageSize:(CGSize)imageSize;

/**
 生成彩色的二维码图片

 @param str 要生成二维码的数据
 @param imageSize 生成的二维码图片size
 @param rgbColor 主题颜色
 @param backgroundColor 背景颜色
 @return 生成的二维码图片
 */
+ (UIImage *)generateColoursQRCodeImageWithString:(NSString *)str
                                        imageSize:(CGSize)imageSize
                                         rgbColor:(UIColor *)rgbColor
                                  backgroundColor:(UIColor *)backgroundColor;

/**
 生成指定颜色的二维码图片
 
 @param str 要生成二维码的数据
 @param imageSize 生成的二维码图片size
 @param red 红色（0~255）
 @param green 绿色（0~255）
 @param blue 蓝色（0~255）
 @return 生成的二维码图片
 */
+ (UIImage *)generateColoursQRCodeImageWithString:(NSString *)str
                                        imageSize:(CGSize)imageSize
                                              red:(CGFloat)red
                                            green:(CGFloat)green
                                             blue:(CGFloat)blue NS_DEPRECATED(1_0,1_0,1_0,1_0,"use generateColoursQRCodeImageWithString: imageSize:rgbColor:backgroundColor: instead");
/**
 生成黑白带logo的二维码图片

 @param string 要生成二维码的数据
 @param imageSize 生成的二维码图片size
 @param logoImageName logo图片
 @param logoImageSize logo图片的大小
 @return 生成的二维码图片
 */
+ (UIImage *)generateLogoQRCodeImageWithString:(NSString *)string
                                     imageSize:(CGSize)imageSize
                                 logoImageName:(NSString *)logoImageName
                                 logoImageSize:(CGSize)logoImageSize;


/**
 生成彩色带logo的二维码图片
 
 @param string 要生成二维码的数据
 @param imageSize 生成的二维码图片size
 @param rgbColor 主题颜色
 @param backgroundColor 背景颜色
 @param logoImageName logo图片
 @param logoImageSize logo图片的大小
 @return 生成的二维码图片
 */
+ (UIImage *)generateColoursLogoImageWithString:(NSString *)string
                                      imageSize:(CGSize)imageSize
                                       rgbColor:(UIColor *)rgbColor
                                backgroundColor:(UIColor *)backgroundColor
                                  logoImageName:(NSString *)logoImageName
                                  logoImageSize:(CGSize)logoImageSize;

@end

NS_ASSUME_NONNULL_END
