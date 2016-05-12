//
//  ProfileViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-22.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "ProfileViewController.h"
#import "BandleCellPhoneViewController.h"
#import "ProfileModel.h"
#import "SchoolModel.h"
#import "UserInfoModel.h"

@interface ProfileViewController()

@end


@implementation ProfileViewController
{
    NSArray *items;
    UIImage *oldImg1;
    UIImage *oldImg2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.hasBackBtn = NO;
    items = @[
        @{
            @"title" : @"管理收货地址",
            @"imgUrl" : @"icon_map",
            @"url" : @"addresses",
        },
        @{
            @"title" : @"我的优惠券",
            @"imgUrl" : @"icon_coupon",
            @"url" : @"coupon",
        },
        @{
            @"title" : @"联系我们",
            @"imgUrl" : @"icon_phone2",
            @"url" : @"contactUs",
        },
        @{
            @"title" : @"关于我们",
            @"imgUrl" : @"icon_link",
            @"url" : @"RSUser://Aboutus",
        },
    ];
    

}

- (void)initDataSorce
{
    [self.models removeAllObjects];
    __weak ProfileViewController *selfB = self;
    [UserInfoModel getUserInfo:^(UserInfoModel *userInfoModel) {
        userInfoModel.cellHeight = 172;
        userInfoModel.title = @"绑定手机";
        userInfoModel.cellClassName = @"HeadviewCell";
        userInfoModel.url = @"RSUser://BandleCellPhone";
        [userInfoModel setSelectAction:@selector(bandleCellPhone) target:self];
        [selfB.models addObject:userInfoModel];
        
        for(NSDictionary *dict in items) {
            ProfileModel *model = [ProfileModel new];
            model.title = [dict valueForKey:@"title"];
            model.url = [dict valueForKey:@"url"];
            model.imgUrl = [dict valueForKey:@"imgUrl"];
            [selfB.models addObject:model];
        }
        
        [selfB.tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initDataSorce];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    oldImg1 = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    oldImg2 = [self.navigationController.navigationBar shadowImage];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if(![AppConfig getAPPDelegate].schoolModel) {
        [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
            [AppConfig getAPPDelegate].schoolModel = schoolModel;
        }];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:oldImg1 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:oldImg2];
    self.navigationController.navigationBar.backgroundColor = RS_Theme_Color;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileModel *model = (ProfileModel *)[self getModelByIndexPath:indexPath];
    if([model.url isEqualToString:@"contactUs"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [AppConfig getAPPDelegate].schoolModel.contactMobile]]];
        return;
    }

    UIViewController *vc = [RSRoute getViewControllerByPath:model.url];
    if(vc) {
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
