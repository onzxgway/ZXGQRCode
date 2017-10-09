//
//  ShoppingCarController.m
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "ShoppingCarController.h"
#import "Const.h"
#import "ShoppingCarCell.h"
#import "PayView.h"
#import "ShoppingViewModel.h"
#import "ShoppingCarModel.h"
#import "CommodityModel.h"
#import "MBProgressHUD.h"
#import "SecHeaderView.h"
#import "TBButton.h"
#import "NumberView.h"
#import "BaseModel.h"
#import "SecHeaderModel.h"

#define ZXGNotifier [NSNotificationCenter defaultCenter]

@interface ShoppingCarController ()<UITableViewDelegate,UITableViewDataSource,ShoppingCarCellDelegate,NumberViewDelegate>
@property (nonatomic, strong) UITableView *spTableView;
@property (nonatomic, strong) PayView *payView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *models;
@property (nonatomic, strong) NSMutableArray *deepCopyArr;
@end

@implementation ShoppingCarController

#pragma mark - lazy load
- (NSMutableArray<NSMutableArray *> *)models {
    if (!_models) {
        _models = @[].mutableCopy;
    }
    return _models;
}

- (NSMutableArray *)deepCopyArr {
    if (!_deepCopyArr) {
        _deepCopyArr = @[].mutableCopy;
    }
    return _deepCopyArr;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupOthers];
    
    [self.view addSubview:self.spTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShoppingViewModel getData:^(NSArray *datas) {
        [hud hideAnimated:YES];
        [self.view addSubview:self.payView];
        self.models = datas.mutableCopy;
        [self calculateTMoney];
        [_spTableView reloadData];
    } refresh:^{
        [self calculateTMoney];
    }];
    
    [self addKeyboardNoti];
}
#pragma mark - observe keyboard
- (void)keyboardWillShow:(NSNotification *)noti {
    
    NSLog(@"%@",noti.userInfo);
    
//    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat time = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:time animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)keyboardDidShow:(NSNotification *)noti {
    
}
- (void)keyboardWillHide:(NSNotification *)noti {
    
}
- (void)keyboardDidHide:(NSNotification *)noti {
    
}

#pragma mark - private methods
- (void)setupOthers {
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = TableBGColor;
}

//监听键盘
- (void)addKeyboardNoti {
    [ZXGNotifier addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [ZXGNotifier addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [ZXGNotifier addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [ZXGNotifier addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

//计算总价
- (void)calculateTMoney {
    NSDecimalNumber *totalNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (NSArray *tempArr in self.models) {
        
        for (id model in tempArr) {
            if (![model isKindOfClass:[ShoppingCarModel class]]) continue;
            
            ShoppingCarModel *shoppingCarModel = (ShoppingCarModel *)model;
            if (!shoppingCarModel.isSelected) continue;
            
            NSDecimalNumber *curCount = [NSDecimalNumber decimalNumberWithString:shoppingCarModel.count];
            NSDecimalNumber *curPrice = [NSDecimalNumber decimalNumberWithString:shoppingCarModel.item_info.sale_price];
            
            NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
            NSDecimalNumber *curTotalMoney = [curCount decimalNumberByMultiplyingBy:curPrice withBehavior:handler];
            totalNumber = [totalNumber decimalNumberByAdding:curTotalMoney withBehavior:handler];
        }
    }
    
    [self refreshTotalPriceLabel:totalNumber.stringValue];
}

//刷新底部支付view
- (void)refreshTotalPriceLabel:(NSString *)totalPrice {
    NSArray<NSString *> *strs = [self.payView.totalPriceLabel.text componentsSeparatedByString:@"￥"];
    self.payView.totalPriceLabel.text = [NSString stringWithFormat:@"%@￥%@",[strs firstObject],totalPrice];
}

//
- (void)changeState:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    SecHeaderView *secHeaderView = (SecHeaderView *)[_spTableView headerViewForSection:indexPath.section];
    
    if (isSelected) {
        BOOL res = YES;
        NSArray *models = self.models[indexPath.section];
        for (int i = 1; i < models.count; ++i) {
            ShoppingCarModel *shoppingCarModel = [models objectAtIndex:i];
            if (!shoppingCarModel.isSelected) {
                res = NO;
                break;
            }
        }
        secHeaderView.secHeaderModel.isSelected = res;
        
    } else {
        secHeaderView.secHeaderModel.isSelected = NO;
    }
    [_spTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    [self changeAllSelectBtnState];
}

- (void)changeAllSelectBtnState {
    
    BOOL reloadSecHead = YES;
    for (NSArray *tempArr in self.models) {
        SecHeaderModel *secHeaderModel = (SecHeaderModel *)[tempArr firstObject];
        if (!secHeaderModel.isSelected) {
            reloadSecHead = NO;
            break;
        }
    }
    self.payView.selectAllBtn.selected = reloadSecHead;
}

// 组全选按钮
- (void)secAllSelect:(UIButton *)btn {
    BOOL res = !btn.isSelected;
    
    SecHeaderView *secHeaderView = (SecHeaderView *)btn.superview;
    //修改cell对应的模型对象
    NSArray *tempModels = self.models[secHeaderView.section];
    for (BaseModel *baseModel  in tempModels) {
        baseModel.isSelected = res;
    }
    //刷新当前cell
    [_spTableView reloadSections:[NSIndexSet indexSetWithIndex:secHeaderView.section] withRowAnimation:UITableViewRowAnimationNone];
    
    [self changeAllSelectBtnState];
}

// 全选按钮
- (void)allSelect:(UIButton *)btn {
    BOOL res = !btn.isSelected;
    btn.selected = res;
    
    //修改cell对应的模型对象
    for (NSArray *tempArr in self.models) {
        for (BaseModel *baseModel in tempArr) {
            baseModel.isSelected = res;
        }
    }

    //刷新全局
    [_spTableView reloadData];
}

// 支付或者删除
- (void)payOrDel:(UIButton *)btn {
    
    if ([@"删除" isEqualToString:btn.titleLabel.text]) {
        for (int i = 0; i < self.models.count; ++i) {
            NSMutableArray *inArray = [self.models objectAtIndex:i];
            NSMutableArray *inArr = [self.deepCopyArr objectAtIndex:i];
            
            for (ShoppingCarModel *shoppingCarModel in inArray.reverseObjectEnumerator) {
                if (shoppingCarModel.isSelected) {
                    NSUInteger index = [inArray indexOfObject:shoppingCarModel];
                    [inArray removeObject:shoppingCarModel];
                    [inArr removeObjectAtIndex:index];
                }
            }
        }
        
        for (NSMutableArray *arr in self.models.reverseObjectEnumerator) {
            if (arr.count == 1 || arr.count == 0) {
                NSUInteger index = [self.models indexOfObject:arr];
                [self.deepCopyArr removeObjectAtIndex:index];
                [self.models removeObjectAtIndex:index];
            }
        }
        [_spTableView reloadData];
    }
}

//编辑
- (void)edit:(UIBarButtonItem *)barButtonItem {
    NSString *title = barButtonItem.title;
    
    if ([@"编辑" isEqualToString:title]) {
        barButtonItem.title = @"完成";
        _payView.payBtn.selected = YES;
        [_payView.payBtn setBackgroundColor:[UIColor orangeColor]];
        [_payView.payBtn setTitle:@"删除" forState:UIControlStateNormal];
        
        //记录编辑之前的选中状态
        //数据源数组
        [self.deepCopyArr removeAllObjects];
        for (NSArray *tempArr in self.models) {
            NSMutableArray *newArr = [[NSMutableArray alloc] initWithArray:tempArr copyItems:YES];
            [self.deepCopyArr addObject:newArr];
        }
        
        //相当于点击了全选按钮
        _payView.selectAllBtn.selected = YES;
        [self allSelect:_payView.selectAllBtn];
    }
    
    if ([@"完成" isEqualToString:title]) {
        barButtonItem.title = @"编辑";
        _payView.payBtn.selected = NO;
        [_payView.payBtn setBackgroundColor:[UIColor redColor]];
        [_payView.payBtn setTitle:@"去结算" forState:UIControlStateNormal];
        
        for (int i = 0; i < self.models.count; ++i) {
            NSArray *inArray = [self.models objectAtIndex:i];
            NSArray *inArr = [self.deepCopyArr objectAtIndex:i];
    
            BOOL tempVal = NO;
            for (int j = 0; j < inArr.count; ++j) {
                BaseModel *baseModelData = [inArray objectAtIndex:j];
                BaseModel *baseModel = [inArr objectAtIndex:j];
                baseModelData.isSelected = baseModel.isSelected;
                if (j != 0 && !baseModel.isSelected) {
                    tempVal = YES;
                }
                BaseModel *model = [inArray firstObject];
                if (tempVal) {
                    model.isSelected = NO;
                } else {
                    model.isSelected = YES;
                }
            }
        }
        [_spTableView reloadData];
    }
}

#pragma mark - lazy load
- (UITableView *)spTableView {
    if (!_spTableView) {
        _spTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _spTableView.frame = (CGRect){{0, 0}, {ScreenW, spTableViewH}};
        _spTableView.delegate = self;
        _spTableView.dataSource = self;
        _spTableView.rowHeight = CellH;
        _spTableView.tableFooterView = [[UIView alloc] init];
        _spTableView.backgroundColor = TableBGColor;
    }
    return _spTableView;
}

- (PayView *)payView {
    if (!_payView) {
        _payView = [[PayView alloc] initWithFrame:(CGRect){{0,spTableViewH},{ScreenW,PayViewH}}];
        [_payView.selectAllBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_payView.payBtn addTarget:self action:@selector(payOrDel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payView;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models[section].count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCarCell *shoppingCarCell = [[ShoppingCarCell alloc] initWithStyle:UITableViewCellStyleDefault tableView:tableView];
    shoppingCarCell.delegate = self;
    shoppingCarCell.numberView.delegate = self;
    shoppingCarCell.shoppingCarModel = self.models[indexPath.section][indexPath.item + 1];
    return shoppingCarCell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SecHeaderView *secHeaderView = [[SecHeaderView alloc] initWithTableView:tableView];
    secHeaderView.section = section;
    secHeaderView.secHeaderModel = [self.models[section] firstObject];
    
    [secHeaderView.selectBtn addTarget:self action:@selector(secAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    return secHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = self.models[indexPath.section];
        
        if (array.count == 2) {
            [self.models removeObjectAtIndex:indexPath.section];
            [tableView reloadData];
            return;
        }
        
        [array removeObjectAtIndex:indexPath.row + 1];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - ShoppingCarCell Delegate
- (void)ShoppingCarCell:(ShoppingCarCell *)shoppingCarCell {
    
    NSIndexPath *indexPath = [_spTableView indexPathForCell:shoppingCarCell];
    //修改cell对应的模型对象
    ShoppingCarModel *shoppingCarModel = self.models[indexPath.section][indexPath.row + 1];
    BOOL btnState = !shoppingCarCell.selectBtn.isSelected;
    //刷新价格payview kvo
    shoppingCarModel.isSelected = btnState;
    
    [self changeState:indexPath isSelected:btnState];
}

#pragma mark - NumberView Delegate
- (void)numberView:(NumberView *)numberView opeaType:(BtnOperaType)btnOperaType {
    ShoppingCarCell *shoppingCarCell = (ShoppingCarCell *)numberView.superview.superview;
    NSIndexPath *indexPath = [_spTableView indexPathForCell:shoppingCarCell];
    ShoppingCarModel *shoppingCarModel = self.models[indexPath.section][indexPath.row + 1];
    NSInteger count = [shoppingCarModel.count integerValue];
    //修改cell对应的模型对象
    if (btnOperaType == BtnOperaTypeAdd) {
        if (!numberView.subBtn.enabled) numberView.subBtn.enabled = YES;
        if (count >= [shoppingCarModel.item_info.stock_quantity integerValue]) {
            numberView.addBtn.enabled = NO;
        } else {
            shoppingCarModel.count = [NSString stringWithFormat:@"%zd",++count];
        }
    
    }
    
    if (btnOperaType == BtnOperaTypeSub) {
        if (!numberView.addBtn.enabled) numberView.addBtn.enabled = YES;
        if (count == 1) {
            numberView.subBtn.enabled = NO;
        } else {
            shoppingCarModel.count = [NSString stringWithFormat:@"%zd",--count];
        }
    }
    //刷新当前cell
    [_spTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //刷新价格payview kvo
    shoppingCarModel.isSelected = shoppingCarModel.isSelected;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
