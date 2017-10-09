//
//  SinaFrameModel.m
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "SinaFrameModel.h"
#import "SinaStatusModel.h"
#import "SinaUserModel.h"
#import "SinaPictureView.h"

@implementation SinaFrameModel

//重写
- (void)setStatusModel:(SinaStatusModel *)statusModel {
    
    _statusModel = statusModel;
    
    //以下部分是计算子控件的frame
    //原创微博整体的View
    CGFloat originalViewX = 0;
    CGFloat originalViewY = MARGIN;
    
    //头像
    CGFloat headImageX = MARGIN;
    CGFloat headImageY = MARGIN;
    CGSize headImageSize = CGSizeMake(HeadImageWH, HeadImageWH);
    self.headImageF = (CGRect){{headImageX,headImageY},headImageSize};
    
    //计算昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.headImageF) + MARGIN;
    CGFloat nameLabelY = headImageY;
    CGSize nameLabelSize = [statusModel.user.screen_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:BFONT_SIZE]} context:nil].size;
    self.nameLabelF = (CGRect){{nameLabelX,nameLabelY},nameLabelSize};
    
    //计算时间
    CGFloat timeLabelX = nameLabelX;
    CGSize timeLabelSize = [statusModel.created_at boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SFONT_SIZE]} context:nil].size;
    CGFloat timeLabelY = CGRectGetMaxY(self.headImageF) - timeLabelSize.height;
    self.timeLabelF = (CGRect){{timeLabelX,timeLabelY},timeLabelSize};
    
    //计算来源
    CGFloat soruceLabelX = CGRectGetMaxX(self.timeLabelF) + MARGIN;
    CGFloat soruceLabelY = timeLabelY;
    CGSize soruceLabelSize = [statusModel.source boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SFONT_SIZE]} context:nil].size;
    self.sourceLabelF = (CGRect){{soruceLabelX,soruceLabelY},soruceLabelSize};
    
    //计算内容
    CGFloat contentLabelX = headImageX;
    CGFloat contentLabelY = CGRectGetMaxY(self.headImageF) + MARGIN;
    CGSize contentLabelSize = [statusModel.text boundingRectWithSize:CGSizeMake(SCREENW - 2 * MARGIN, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:BFONT_SIZE]} context:nil].size;
    self.contentLabelF = (CGRect){{contentLabelX,contentLabelY},contentLabelSize};
    
    //计算原创配图
    CGSize originalViewSize = CGSizeZero;//原创微博View的Size
    if (statusModel.pic_urls.count > 0) {//有配图
        CGFloat origialImgX = headImageX;
        CGFloat origialImgY = CGRectGetMaxY(self.contentLabelF) + MARGIN;
        CGSize origialImgSize = [SinaPictureView picSize:statusModel.pic_urls.count];
        self.originalImageF = (CGRect){{origialImgX,origialImgY},origialImgSize};
        
        CGFloat originalViewHeight = 4 * MARGIN + headImageSize.height + contentLabelSize.height + origialImgSize.height;
        originalViewSize = CGSizeMake(SCREENW, originalViewHeight);
    } else {//无配图
        CGFloat originalViewHeight = 3 * MARGIN + headImageSize.height + contentLabelSize.height;
        originalViewSize = CGSizeMake(SCREENW, originalViewHeight);
    }
    
    //原创微博整体的View
    self.originalViewF = (CGRect){{originalViewX,originalViewY},originalViewSize};
    
    //
    //计算转发微博
    CGFloat toolBarY = 0;//toolBar的Y坐标
    if (statusModel.retweeted_status) {//有转发微博
        //转发微博内容
        CGFloat retweetContentLabelX = MARGIN;
        CGFloat retweetContentLabelY = MARGIN;
        CGSize retweetContentLabelSize = [statusModel.retweeted_status.text boundingRectWithSize:CGSizeMake(SCREENW - 2 * MARGIN, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:BFONT_SIZE]} context:nil].size;
        self.retweetContentLabelF = (CGRect){{retweetContentLabelX,retweetContentLabelY},retweetContentLabelSize};
        
        //转发微博的配图
        CGSize retweetViewSize = CGSizeZero;//toolBar的Y坐标
        if (statusModel.retweeted_status.pic_urls.count > 0) {//有配图
            CGFloat retweetImageX = MARGIN;
            CGFloat retweetImageY = CGRectGetMaxY(self.retweetContentLabelF) + MARGIN;
            CGSize retweetImageSize = [SinaPictureView picSize:statusModel.retweeted_status.pic_urls.count];
            self.retweetImageF = (CGRect){{retweetImageX,retweetImageY},retweetImageSize};
            
            CGFloat retweetViewHeight = 3 * MARGIN + retweetContentLabelSize.height +retweetImageSize.height;
            retweetViewSize = CGSizeMake(SCREENW , retweetViewHeight);
        } else {//无配图
            
            CGFloat retweetViewHeight = 2 * MARGIN + retweetContentLabelSize.height;
            retweetViewSize = CGSizeMake(SCREENW, retweetViewHeight);
        }
        
        //转发微博整体的View
        CGFloat retweetViewX = 0;
        CGFloat retweetViewY = CGRectGetMaxY(self.originalViewF);
        self.retweetViewF = (CGRect){{retweetViewX,retweetViewY},retweetViewSize};
        //toolBar的Y值
        toolBarY = CGRectGetMaxY(self.retweetViewF);
    } else { //无转发微博
        //toolBar的Y值
        toolBarY = CGRectGetMaxY(self.originalViewF);
    }
    
    //
    //计算toolBar
    CGFloat toolBarX = 0;
    CGSize toolBarSize = CGSizeMake(SCREENW, 44);
    self.toolBarF = (CGRect){{toolBarX,toolBarY},toolBarSize};
    
    //
    //cell的高度相对于toolBar的最大的Y值
    self.cellHeight = CGRectGetMaxY(self.toolBarF);
}

@end
