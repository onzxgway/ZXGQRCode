//
//  SinaStatusModel.h
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SinaUserModel;

@interface SinaStatusModel : NSObject

/**
 *  微博的id
 */
@property (nonatomic, assign) long long id;


/**
 *  发布当前微博的人
 */
@property (nonatomic, strong) SinaUserModel *user;

/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *created_at;

/**
 *  来源
 */
@property (nonatomic, copy) NSString *source;

/**
 *  当前微博的内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  一张缩略图的地址
 */
@property (nonatomic, copy) NSString *thumbnail_pic;


/**
 *  微博配图的数组
 */
@property (nonatomic, strong) NSArray *pic_urls;


/**
 *  代表当前微博转发的别人的微博的内容
 */
@property (nonatomic, strong) SinaStatusModel *retweeted_status;


//转发数
@property (nonatomic, assign) NSInteger reposts_count;
//评论数
@property (nonatomic, assign) NSInteger comments_count;
//表态数
@property (nonatomic, assign) NSInteger attitudes_count;

@end
