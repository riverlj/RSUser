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
#import "ProfileCell.h"

@interface ProfileViewController()
{
    UserInfoModel *userInfoModel;
}
@end


@implementation ProfileViewController
{
    NSArray *items;
    UIImage *oldImg1;
    UIImage *oldImg2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    
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
    ];
    
    self.models = [[NSMutableArray alloc]init];
    userInfoModel = [[UserInfoModel alloc]init];
    userInfoModel.cellHeight = 172;
    userInfoModel.title = @"绑定手机";
    userInfoModel.cellClassName = @"HeadviewCell";
    userInfoModel.url = @"RSUser://BandleCellPhone";
    [self.models addObject:userInfoModel];
    
    for(NSDictionary *dict in items) {
        ProfileModel *model = [ProfileModel new];
        model.title = [dict valueForKey:@"title"];
        model.url = [dict valueForKey:@"url"];
        model.imgUrl = [dict valueForKey:@"imgUrl"];
        [self.models addObject:model];
    }
    
    [self.tableView reloadData];
    RSButton *settingBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 30, 44) ImageName:@"icon_setting" Text:nil TextColor:RS_Clear_Clor];
    
    @weakify(self)
    [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        UIViewController *vc = [RSRoute getViewControllerByPath:@"RSUser://setting"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    
}

- (void)initDataSorce
{
    __weak ProfileViewController *selfB = self;
    [UserInfoModel getUserInfo:^(UserInfoModel *userInfoModelparam) {
        userInfoModel=userInfoModelparam;
        userInfoModel.cellHeight = 172;
        userInfoModel.title = @"绑定手机";
        userInfoModel.cellClassName = @"HeadviewCell";
        userInfoModel.url = @"RSUser://BandleCellPhone";
        
        [selfB.models removeObjectAtIndex:0];
        [selfB.models insertObject:userInfoModel atIndex:0];
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
        NSString *phone = [AppConfig getAPPDelegate].schoolModel.contactMobile;
        if (phone.length == 0) {
            [[RSToastView shareRSToastView] showToast:@"号码获取失败,请稍后尝试"];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone]]];
        return;
    }

    UIViewController *vc = [RSRoute getViewControllerByPath:model.url];
    if ([vc isKindOfClass:[BandleCellPhoneViewController class]])
    {
        return;
    }
    if(vc) {
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
