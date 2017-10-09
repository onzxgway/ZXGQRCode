//
//  ViewController.m
//  网易新闻
//
//  Created by 朱献国 on 14/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "ViewController.h"
#import "TopController.h"
#import "HotController.h"
#import "SportController.h"
#import "EntertainController.h"
#import "VideoController.h"
#import "FinaceController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *titles;
@end

#define TitleW (ScreenW * 0.22)
static CGFloat const radio = 1.4;

@implementation ViewController {
    UILabel *_preLabel;
    CGFloat _preOffsetX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addChildControllers];
    
    [self setupScrollView];
    
    [self setupTitles];
    
}

//设置ScrollView
- (void)setupScrollView {
    self.titleScrollView.contentSize = CGSizeMake(self.childViewControllers.count * TitleW, 0);
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * ScreenW, 0);
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
}

//设置标题
- (void)setupTitles {
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = TitleW;
    for (int i = 0; i < count; ++i) {
        
        UILabel *label = [[UILabel alloc] init];
        UIViewController *vc = self.childViewControllers[i];
        label.text = vc.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.userInteractionEnabled = YES;
        label.tag = i;
//        label.highlightedTextColor = [UIColor redColor];
        
        x = w * i;
        label.frame = CGRectMake(x, 0, w, self.titleScrollView.bounds.size.height);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
        
        if (i == 0) [self tap:tap];
        [self.titles addObject:label];
        [self.titleScrollView addSubview:label];
    }
    
}

//添加子控制器
- (void)addChildControllers {
    TopController *topController = [[TopController alloc] init];
    topController.title = @"头条";
    [self addChildViewController:topController];
    
    HotController *hotController = [[HotController alloc] init];
    hotController.title = @"热点";
    [self addChildViewController:hotController];
    
    SportController *sportController = [[SportController alloc] init];
    sportController.title = @"体育";
    [self addChildViewController:sportController];
    
    EntertainController *entertainController = [[EntertainController alloc] init];
    entertainController.title = @"娱乐";
    [self addChildViewController:entertainController];
    
    VideoController *videoController = [[VideoController alloc] init];
    videoController.title = @"视频";
    [self addChildViewController:videoController];
    
    FinaceController *finaceController = [[FinaceController alloc] init];
    finaceController.title = @"金融";
    [self addChildViewController:finaceController];
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    UILabel *label = (UILabel *)recognizer.view;
    
    [self setTitleStyle:label];
    
    //contentScrollView滚动到对应的位置
    CGFloat offsetX = label.tag * self.contentScrollView.bounds.size.width;
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0)];
    
    //添加view
    [self addSubView:label.tag];
    
}

//添加view
- (void)addSubView:(NSUInteger)index {
    CGFloat offsetX = index * self.contentScrollView.bounds.size.width;
    UIViewController *VC = self.childViewControllers[index];
    if (VC.isViewLoaded) return;
    VC.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:VC.view];
}

- (void)setTitleStyle:(UILabel *)label {
    //设置字体变色
//    _preLabel.highlighted = NO;
    _preLabel.textColor = [UIColor blackColor];
    _preLabel.transform = CGAffineTransformIdentity;
    
//    label.highlighted = YES;
    label.textColor = [UIColor redColor];
    label.transform = CGAffineTransformMakeScale(radio, radio);
    
    _preLabel = label;
    
    //titleScrollView滚动到中间
    CGFloat titleScrollOffsetX = label.center.x - ScreenW * 0.5;
    if (titleScrollOffsetX < 0) titleScrollOffsetX = 0;
    if (titleScrollOffsetX > (self.titleScrollView.contentSize.width - ScreenW)) titleScrollOffsetX = self.titleScrollView.contentSize.width - ScreenW;
    [self.titleScrollView setContentOffset:CGPointMake(titleScrollOffsetX, 0) animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //添加view
    [self addSubView:index];
    
    //选中title
    [self setTitleStyle:self.titles[index]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    NSInteger leftIndex = offsetX;
    NSInteger rightIndex = leftIndex + 1;
    
    UILabel *leftLabel = self.titles[leftIndex];
    UILabel *rightLabel = nil;
    if (rightIndex < self.titles.count) {
        rightLabel = self.titles[rightIndex];
    }
    
    CGFloat rightScale = offsetX - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * 0.4 + 1, leftScale * 0.4 + 1);
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * 0.4 + 1, rightScale * 0.4 + 1);
    
//    leftLabel.highlighted = NO;
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0.f blue:0.f alpha:1.f];
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0.f blue:0.f alpha:1.f];
}

//判断水平滚动方向
- (ScrollHDirection)scrollDirection:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    ScrollHDirection res;
    if (offsetX > _preOffsetX) {
        res = ScrollHDirectionLeft;
    } else {
        res = ScrollHDirectionRight;
    }
    _preOffsetX = offsetX;
    
    return res;
}

#pragma mark - lazy load
- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}


@end
