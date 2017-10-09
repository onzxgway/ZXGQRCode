//
//  SinaPictureView.m
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import "SinaPictureView.h"
#import "UIImageView+WebCache.h"

static CGFloat const ItemMargin = 5.0;
#define ItemWitdh ((SCREENW - 2 * MARGIN - 2 * ItemMargin) / 3)
static NSString * const reuse = @"SinaPictureView";

@interface SinaPictureView ()<UICollectionViewDataSource>

@end

@implementation SinaPictureView

#pragma mark -API
+ (instancetype)sinaPictureView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    SinaPictureView * pictureView = [[SinaPictureView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    flowLayout.itemSize = CGSizeMake(ItemWitdh, ItemWitdh);
    flowLayout.minimumLineSpacing = ItemMargin;
    flowLayout.minimumInteritemSpacing = ItemMargin;
    
    pictureView.dataSource = pictureView;
    pictureView.backgroundColor = [UIColor whiteColor];
    [pictureView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuse];
    
    
    return pictureView;
}

+ (CGSize)picSize:(NSInteger)picCount {
    
    if (picCount == 1) {
        return  CGSizeMake(ItemWitdh, ItemWitdh);
    } else if (picCount == 4) {
        return CGSizeMake(2 * ItemWitdh + ItemMargin, 2 * ItemWitdh + ItemMargin);
    } else {
        NSInteger count = (picCount - 1) / 3 + 1;
        CGFloat height = ItemWitdh * count + (count - 1) * ItemMargin;
        return CGSizeMake(SCREENW - 2 * MARGIN, height);
    }
  
}

- (void)setPicArr:(NSArray *)picArr {
    _picArr = picArr;
    
    //
    [self reloadData];
}


#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    
    //添加imageview
    UIImageView *img = [[UIImageView alloc] init];
    [cell addSubview:img];
    img.frame = cell.bounds;
    
    //
    NSString *imgPath = self.picArr[indexPath.item][@"thumbnail_pic"];
    [img sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    return cell;
}
//- (CGSize)picSizeWithCount:(NSInteger)picCount {
//    
//    
//    return 0;
//}

@end
