//
//  Conferee.m
//  copy
//
//  Created by san_xu on 2017/8/10.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "Conferee.h"

@implementation Conferee

- (id)copyWithZone:(NSZone *)zone {
    Conferee *ee = [[[self class] allocWithZone:zone] init];
    ee.name = [self.name copy];
    return ee;
}

@end
