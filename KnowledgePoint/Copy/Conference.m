//
//  Conference.m
//  copy
//
//  Created by san_xu on 2017/8/10.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "Conference.h"

@implementation Conference

- (NSMutableArray *)conferees {
    if (!_conferees) {
        _conferees = [NSMutableArray array];
    }
    return _conferees;
}

#pragma mark - NSCoping
- (id)copyWithZone:(nullable NSZone *)zone {
    Conference *conference = [[[self class] allocWithZone:zone] init];
    conference.conferenceID = [self.conferenceID copy];
    conference.conferees = [self.conferees mutableCopy];
    return conference;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Conference *ence = [[[self class] allocWithZone:zone] init];
    ence.conferenceID = [self.conferenceID copy];
    ence.conferees = [self.conferees mutableCopy];
    return ence;
}

#pragma mark - Public

- (id)shallowCopy {
    Conference *conference = [[Conference alloc] init];
    conference.conferenceID = [self.conferenceID copy];
    conference.conferees = [self.conferees mutableCopy];
    return conference;
}

- (id)deepCopy {
    Conference *conference = [[Conference alloc] init];
    conference.conferenceID = [self.conferenceID copy];
    conference.conferees = [[NSMutableArray alloc] initWithArray:self.conferees copyItems:YES];
    return conference;
}

@end
