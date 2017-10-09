//
//  Conference.h
//  copy
//
//  Created by san_xu on 2017/8/10.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Conferee;

@interface Conference : NSObject <NSCopying,NSMutableCopying>

@property (nonatomic, copy) NSString *conferenceID;
@property (nonatomic, strong) NSMutableArray *conferees;

- (id)shallowCopy;
- (id)deepCopy;

@end
