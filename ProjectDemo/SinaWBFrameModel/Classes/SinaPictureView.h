//
//  SinaPictureView.h
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinaPictureView : UICollectionView

@property (strong,nonatomic)NSArray *picArr;

//计算配图的大小
+ (CGSize)picSize:(NSInteger)picCount;

//初始化类方法
+ (instancetype)sinaPictureView;

@end
