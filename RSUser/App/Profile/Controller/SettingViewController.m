//
//  SettingViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/17.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "SettingViewController.h"
#import "ProfileModel.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    NSArray *items = @[
              @{
                  @"title" : @"关于我们",
                  @"imgUrl" : @"icon_link",
                  @"url" : @"rsuser://Aboutus",
                  }
              
              ];
    
    self.models = [[NSMutableArray alloc]init];

    for(NSDictionary *dict in items) {
        ProfileModel *model = [ProfileModel new];
        model.title = [dict valueForKey:@"title"];
        model.url = [dict valueForKey:@"url"];
        model.imgUrl = [dict valueForKey:@"imgUrl"];
        model.hiddenLine = YES;
        model.cellHeight = 44;
        [self.models addObject:model];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
//    
//    UIButton *loginOutBtn = [RSButton themeBackGroundButton:CGRectMake((SCREEN_WIDTH-295)/2, self.view.height/2-64, 295, 40) Text:@"退出登陆"];
//    [self.view addSubview:loginOutBtn];
//    
//    [[loginOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [NSUserDefaults clearValueForKey:@"token"];
//        [[AppConfig getAPPDelegate]setappRootViewControler];
//        
//    }];
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileModel *model = (ProfileModel *)[self getModelByIndexPath:indexPath];
    
    [RSRoute skipToViewController:[NSString stringWithFormat:@"%@?title=%@", model.url, model.title] model:RSRouteSkipViewControllerPush];
}

@end
