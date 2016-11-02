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
#import "HeadviewCell.h"
#import "RSJSWebViewController.h"


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
    UIView *statusBarView;
}

#pragma mark 生命周期
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
            @"imgUrl" : @"icon_phone",
            @"url" : @"contactUs",
        },
    ];
    
    self.models = [[NSMutableArray alloc]init];
    userInfoModel = [[UserInfoModel alloc]init];
    userInfoModel.cellHeight = 145;
    userInfoModel.title = @"绑定手机";
    userInfoModel.cellClassName = @"HeadviewCell";
    userInfoModel.url = @"RSUser://RSJSWeb";
    [self.models addObject:userInfoModel];
    
    for(NSDictionary *dict in items) {
        ProfileModel *model = [ProfileModel new];
        model.title = [dict valueForKey:@"title"];
        model.url = [dict valueForKey:@"url"];
        model.imgUrl = [dict valueForKey:@"imgUrl"];
        model.cellHeight = 44;
        [self.models addObject:model];
    }
    
    ProfileModel *model = self.models.lastObject;
    model.hiddenLine = YES;
    
    [self.tableView reloadData];
    
    RSButton *settingBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 30, 44) ImageName:@"icon_setting" Text:nil TextColor:RS_Clear_Clor];
    
    @weakify(self)
    [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [RSRoute skipToViewController:@"rsuser://setting" model:RSRouteSkipViewControllerPush];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initDataSorce];
    self.tableView.y = 63;

    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_image"]];
    oldImg1 = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    oldImg2 = [self.navigationController.navigationBar shadowImage];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"content_image"]];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    if(![AppConfig getAPPDelegate].schoolModel) {
        [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
            [AppConfig getAPPDelegate].schoolModel = schoolModel;
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1000, [UIScreen mainScreen].bounds.size.width, 1001)];
    imageView.alpha = 1.0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"content_image"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:imageView];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:oldImg1 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:oldImg2];
    self.navigationController.navigationBar.backgroundColor = RS_Theme_Color;
    
    [statusBarView removeFromSuperview];
}

#pragma mark 初始化数据
- (void)initDataSorce
{
    __weak ProfileViewController *selfB = self;
    [UserInfoModel getUserInfo:^(UserInfoModel *userInfoModelparam) {
        userInfoModel=userInfoModelparam;
        userInfoModel.cellHeight = 145;
        userInfoModel.title = @"绑定手机";
        userInfoModel.cellClassName = @"HeadviewCell";
        userInfoModel.url = @"RSUser://RSJSWeb";
        
        [selfB.models removeObjectAtIndex:0];
        [selfB.models insertObject:userInfoModel atIndex:0];
        [selfB.tableView reloadData];
    }];

}

#pragma mark tableView delegate
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
    if ([vc isKindOfClass:[RSJSWebViewController class]])
    {
        RSJSWebViewController *vc = [[RSJSWebViewController alloc] init];
        NSString * url = @"/static/myAccount";
        NSString* urlStr = [NSString URLencode:[url urlWithHost:APP_CHANNEL_BASE_URL] stringEncoding:NSUTF8StringEncoding];
        vc.urlString = urlStr;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    if(vc) {
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end;
