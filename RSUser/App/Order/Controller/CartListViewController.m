//
//  CartListViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CartListViewController.h"

@interface CartListViewController ()

@end

@implementation CartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.models = [[NSMutableArray alloc]init];
    NSMutableArray *array = [[Cart sharedCart] getCartDetail];
    self.models = array;
    [self.tableView reloadData];
}

@end