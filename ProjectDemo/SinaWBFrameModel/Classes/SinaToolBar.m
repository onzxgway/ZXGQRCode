//
//  SinaToolBar.m
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "SinaToolBar.h"
#import "SinaStatusModel.h"

@interface SinaToolBar ()
@property (weak,nonatomic)UIImageView *lineOne;
@property (weak,nonatomic)UIImageView *lineTwo;
@property (weak,nonatomic)UIImageView *lineTop;

@property (strong,nonatomic)NSArray *imgs;
@property (strong,nonatomic)NSArray *titles;
@end

@implementation SinaToolBar
#pragma mark - lazy load
- (NSArray *)imgs {
    if (!_imgs) {
        _imgs = @[@"timeline_icon_retweet",@"timeline_icon_comment",@"timeline_icon_unlike"];
    }
    return _imgs;
}
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"转发",@"评论",@"赞"];
    }
    return _titles;
}

#pragma mark - 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 私有方法
- (void)setupUI {
    
    //添加三个按钮
    for (int i = 0; i < self.imgs.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];

        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:SFONT_SIZE];
        [btn setImage:[UIImage imageNamed:self.imgs[i]] forState:UIControlStateNormal];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        btn.backgroundColor = [UIColor whiteColor];
    }
    
    //添加两个垂直分割线
    UIImageView *lineOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_highlighted"]];
    [self addSubview:lineOne];
    self.lineOne = lineOne;
    
    UIImageView *lineTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_highlighted"]];
    [self addSubview:lineTwo];
    self.lineTwo = lineTwo;
    
    //顶部分割线
    UIImageView *lineTop = [[UIImageView alloc] init];
    lineTop.backgroundColor = LineColor;
    [self addSubview:lineTop];
    self.lineTop = lineTop;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //按钮布局
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / self.imgs.count;
    CGFloat btnH = self.bounds.size.height;
    
    int index = 0;
    for (int i = 0; i < self.subviews.count; ++i) {
        if ([self.subviews[i] isKindOfClass:[UIButton class]]) {
            self.subviews[i].frame = CGRectMake(index * btnW, btnY, btnW, btnH);
            index ++;
        }
    }
    
    //两条垂直线布局
    self.lineOne.center = CGPointMake(btnW, self.bounds.size.height * 0.5);
    self.lineOne.bounds = CGRectMake(0, 0, self.lineOne.image.size.width, self.lineOne.image.size.height);
    self.lineTwo.center = CGPointMake(2 * btnW, self.bounds.size.height * 0.5);
    self.lineTwo.bounds = CGRectMake(0, 0, self.lineTwo.image.size.width, self.lineTwo.image.size.height);
    
    //顶部分割线
    self.lineTop.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

- (void)setStatusModel:(SinaStatusModel *)statusModel {
    
    int index = 0;
    for (int i = 0; i < self.subviews.count; ++i) {
        if ([self.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn = self.subviews[i];
            if (index == 0) {
                [btn setTitle:statusModel.reposts_count == 0 ? @"转发": [NSString stringWithFormat:@"%zd",statusModel.reposts_count] forState:UIControlStateNormal];
            }
            if (index == 1) {
                [btn setTitle:statusModel.comments_count == 0 ? @"评论": [NSString stringWithFormat:@"%zd",statusModel.comments_count] forState:UIControlStateNormal];
            }
            if (index == 2) {
                [btn setTitle:statusModel.attitudes_count == 0 ? @"赞": [NSString stringWithFormat:@"%zd",statusModel.attitudes_count] forState:UIControlStateNormal];
            }
            index ++;
        }
    }
    
}

@end
