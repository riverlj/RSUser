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
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.height = [[Cart sharedCart] getCartDetail].count * 30;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [[Cart sharedCart] getCartDetail].count * 30);
    for (UIView *subview in self.tableView.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"])
        {
            subview.frame = CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height);
            
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [[Cart sharedCart] getCartDetail].count * 30);
}

@end