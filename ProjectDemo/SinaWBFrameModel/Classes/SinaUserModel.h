//
//  SinaUserModel.h
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaUserModel : NSObject

/**
 *  头像地址
 */
@property (nonatomic, copy) NSString *profile_image_url;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *screen_name;

@end
