//
//  SinaCell.h
//  FrameModel方式
//
//  Created by san_xu on 2017/3/17.
//  Copyright © 2017年 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SinaFrameModel;

@interface SinaCell : UITableViewCell

//frame模型属性
@property (strong,nonatomic)SinaFrameModel *frameModel;

//初始化类方法
+ (instancetype)sinaCell:(UITableView *)tableView;

@end
