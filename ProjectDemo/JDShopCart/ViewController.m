//
//  ViewController.m
//  淘宝购物车
//
//  Created by 朱献国 on 20/09/2017.
//  Copyright © 2017 朱献国. All rights reserved.
//

#import "ViewController.h"
#import "ShoppingCarController.h"

@interface ViewController ()

@end

@implementation ViewController

//进入购物车
- (IBAction)enterShoppingCarClick:(id)sender {
    ShoppingCarController *shoppingCarController = [[ShoppingCarController alloc] init];
    [self.navigationController pushViewController:shoppingCarController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
