//
//  SinaFrameModel.h
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SinaStatusModel;

@interface SinaFrameModel : NSObject

//model对象
@property (strong,nonatomic)SinaStatusModel *statusModel;

//cell的高度
@property (assign,nonatomic)CGFloat cellHeight;

//以下都是cell上面子控件的frame
//第一部分
//原创微博整体的View
@property (nonatomic, assign) CGRect originalViewF;
//头像的frame
@property (nonatomic, assign) CGRect headImageF;
//昵称的frame
@property (nonatomic, assign) CGRect nameLabelF;
//时间
@property (nonatomic, assign) CGRect timeLabelF;
//来源
@property (nonatomic, assign) CGRect sourceLabelF;
//原创微博的内容
@property (nonatomic, assign) CGRect contentLabelF;
//配图的大小
@property (nonatomic, assign) CGRect originalImageF;


//第二部分
//转发微博整体的View
@property (nonatomic, assign) CGRect retweetViewF;

//转发微博内容
@property (nonatomic, assign) CGRect retweetContentLabelF;

//转发微博的配图
@property (nonatomic, assign) CGRect retweetImageF;


//第三部分
//工具条
@property (nonatomic, assign) CGRect toolBarF;

@end
