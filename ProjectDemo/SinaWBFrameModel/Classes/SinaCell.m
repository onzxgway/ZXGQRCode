//
//  SinaCell.m
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "SinaCell.h"
#import "SinaFrameModel.h"
#import "SinaStatusModel.h"
#import "SinaUserModel.h"
#import "UIImageView+WebCache.h"
#import "SinaToolBar.h"
#import "SinaPictureView.h"

static NSString *reuseId = @"SinaCell";

@interface SinaCell ()

//原创微博整体View
@property (weak,nonatomic)UIView *originalView;
//头像
@property (nonatomic, weak) UIImageView *headImage;
//昵称的label
@property (nonatomic, weak) UILabel *nameLabel;
//时间
@property (nonatomic, weak) UILabel *timeLabel;
//来源
@property (nonatomic, weak) UILabel *sourceLabel;
//内容的label
@property (nonatomic, weak) UILabel *contentLabel;
//原创微博的配图
@property (nonatomic, weak) SinaPictureView *originalImage;


//转发微博整体的View
@property (nonatomic, weak) UIView *retweetView;
//转发微博内容
@property (nonatomic, weak) UILabel *retweetContentLabel;
//转发微博的图片
@property (nonatomic, weak) SinaPictureView *retweetImage;



//工具条
@property (nonatomic, weak) SinaToolBar *toolBar;

@end

@implementation SinaCell

#pragma mark - API
+ (instancetype)sinaCell:(UITableView *)tableView {
    
    SinaCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[SinaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    return cell;
    
}

#pragma mark - 重写初始化方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    if (self) {
        self.backgroundColor = BackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    
    return self;
}

#pragma mark - 私有方法
- (void)setupSubView {
    
    //添加子控件
    //第一块:添加原创微博的内容
    [self addOriginalView];
    
    //第二块:添加转发微博的内容
    [self addretweetView];
    
    //第三块:添加底部的工具条
    SinaToolBar *toolBar = [[SinaToolBar alloc] init];
    [self.contentView addSubview:toolBar];
    self.toolBar = toolBar;
}

/**
 *  添加原创微博的内容View
 */
- (void)addOriginalView{
    //0.原创微博整体View
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    //0.1整体View顶部加一条分割线
    UIImageView *lineTop = [[UIImageView alloc] init];
    lineTop.backgroundColor = LineColor;
    lineTop.frame = CGRectMake(0, 0, SCREENW, 0.5);
    [originalView addSubview:lineTop];

    
    //1.添加头像
    UIImageView *headImage = [UIImageView new];
    [self.originalView addSubview:headImage];
    self.headImage = headImage;
    
    //2.添加昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:BFONT_SIZE];
    [self.originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    //3.添加时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:SFONT_SIZE];
    timeLabel.textColor = [UIColor grayColor];
    [self.originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    //4.添加来源
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = [UIColor grayColor];
    sourceLabel.font = [UIFont systemFontOfSize:SFONT_SIZE];
    [self.originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    
    //5,添加内容label
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:BFONT_SIZE];
    [self.originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    //6,配图
    SinaPictureView *originalImage = [SinaPictureView sinaPictureView];
    [self.originalView addSubview:originalImage];
    self.originalImage = originalImage;
}


- (void)addretweetView{
    //打转发微博整体的View初始化出来
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = BackColor;
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    //转发微博内容
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.font = [UIFont systemFontOfSize:BFONT_SIZE];
    //设置多行
    retweetContentLabel.numberOfLines = 0;
    [self.retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    //配图
    SinaPictureView *retweetImage = [SinaPictureView sinaPictureView];
    [self.retweetView addSubview:retweetImage];
    self.retweetImage = retweetImage;
    
    
}

#pragma mark - 重写set方法
- (void)setFrameModel:(SinaFrameModel *)frameModel {
    _frameModel = frameModel;
    SinaStatusModel *status = frameModel.statusModel;
    
    //原创整体View
    self.originalView.frame = frameModel.originalViewF;
    
    //设置头像
    self.headImage.frame = frameModel.headImageF;
    NSURL *url = [NSURL URLWithString:status.user.profile_image_url];
    NSLog(@"===%@===",url.absoluteString);
    [self.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //设置昵称
    self.nameLabel.frame = frameModel.nameLabelF;
    self.nameLabel.text = status.user.screen_name;
    
    //设置时间
    self.timeLabel.frame = frameModel.timeLabelF;
    self.timeLabel.text = status.created_at;
    
    //设置来源
    self.sourceLabel.frame = frameModel.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    //设置内容
    self.contentLabel.frame = frameModel.contentLabelF;
    self.contentLabel.text = status.text;
    
    //设置原创配图
    if (status.pic_urls.count > 0) {
        self.originalImage.frame = frameModel.originalImageF;
        self.originalImage.picArr = status.pic_urls;
        self.originalImage.hidden = NO;
    } else {
        self.originalImage.hidden = YES;
    }
    
    if (status.retweeted_status) {
        //转发微博整体的View
        self.retweetView.frame = frameModel.retweetViewF;
        self.retweetView.hidden = NO;
        //转发微博内容
        self.retweetContentLabel.frame = frameModel.retweetContentLabelF;
        self.retweetContentLabel.text = status.retweeted_status.text;
        //转发微博的配图
        if (status.retweeted_status.pic_urls.count > 0) {
            self.retweetImage.frame = frameModel.retweetImageF;
            self.retweetImage.picArr = status.retweeted_status.pic_urls;
            self.retweetImage.hidden = NO;
        } else {
            self.retweetImage.hidden = YES;
        }
        
    } else {
        self.retweetView.hidden = YES;
    }
    
    //toolBar
    self.toolBar.frame = frameModel.toolBarF;
    self.toolBar.statusModel = status;
}

@end
