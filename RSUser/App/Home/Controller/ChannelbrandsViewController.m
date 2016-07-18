//
//  channelbrandsViewController.m
//  RSUser
//
//  Created by 李江 on 16/7/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "channelbrandsViewController.h"
#import "BrandListModel.h"

@interface ChannelbrandsViewController ()

@end

@implementation ChannelbrandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌馆";
    
    self.models = [[NSMutableArray alloc]init];
    
    self.url = @"/brand/list";
    self.useHeaderRefresh = YES;
    self.useFooterRefresh = NO;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)beforeHttpRequest {
    [super beforeHttpRequest];
    self.params = @{
                    @"communityid" : COMMUNTITYID
                    };
}

-(void)afterHttpSuccess:(NSArray *)data {
    [data enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        BrandListModel *brandListModel =[MTLJSONAdapter modelOfClass:[BrandListModel class] fromJSONDictionary:dic error:&error];
        [self.models addObject:brandListModel];
    }];
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
}

@end