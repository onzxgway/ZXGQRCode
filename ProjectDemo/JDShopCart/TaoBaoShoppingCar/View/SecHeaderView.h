//
//  SecHeaderView.h
//  淘宝购物车
//
//  Created by 朱献国 on 23/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecHeaderModel;
@class TBButton;

@interface SecHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) TBButton *selectBtn;           //选择按钮
@property (nonatomic, strong) SecHeaderModel *secHeaderModel;//数据源
@property (nonatomic, assign) NSUInteger section;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
