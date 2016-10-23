//
//  PaySuccessViewController.m
//  RSUser
//
//  Created by 李江 on 16/10/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "XHCustomShareView.h"

@interface PaySuccessViewController ()
{
    UIScrollView *_contentScrollView;
    NSDictionary *shareMsgDic;
}
@end

const static CGFloat k_topHeight = 137;

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享红包";
    self.hasBackBtn = YES;
    
    [self getshareMsg];
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _contentScrollView.backgroundColor = RS_Background_Color;
    [self.view addSubview:_contentScrollView];
    
    UIView *paySuccessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, k_topHeight)];
    paySuccessView.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:paySuccessView];
    
    UIImageView *iconImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, 43, 50) ImageName:@"icon_paysuccess"];
    [paySuccessView addSubview:iconImageView];
    
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"支付成功！";
    successLabel.font = RS_BOLDFONT_21;
    successLabel.textColor = RS_COLOR_C1;
    [paySuccessView addSubview:successLabel];
    CGSize successLabelSize = [successLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    successLabel.width = successLabelSize.width;
    successLabel.height = successLabelSize.height;
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"欢迎使用红领巾订餐";
    welcomeLabel.textColor = RS_COLOR_C1;
    welcomeLabel.font = RS_FONT_13;
    [paySuccessView addSubview:welcomeLabel];
    CGSize welcomeLabelSize = [welcomeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    welcomeLabel.width = welcomeLabelSize.width;
    welcomeLabel.height = welcomeLabelSize.height;
    
    CGFloat left = (SCREEN_WIDTH - (43+3+successLabel.width))/2;
    iconImageView.x = left;
    iconImageView.y = 50;
    
    successLabel.x = iconImageView.right+3;
    successLabel.y = iconImageView.y-2;
    welcomeLabel.x = successLabel.x;
    welcomeLabel.y = successLabel.bottom+2;
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, paySuccessView.bottom + 10, SCREEN_WIDTH, self.tableView.height-paySuccessView.bottom - 10-64)];
    shareView.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:shareView];
    
    iconImageView = [RSImageView imageViewWithFrame:CGRectMake((SCREEN_WIDTH-249)/2, 60, 249, 170)  ImageName:@"icon_free_wallet"];
    if (iPhone5S) {
        iconImageView.y = 30;
    }
    [shareView addSubview:iconImageView];
    
    successLabel = [[UILabel alloc] init];
    successLabel.text = [NSString stringWithFormat:@"恭喜你获得%@个红包可分享",self.bousnumber];
    successLabel.font = RS_BOLDFONT_18;
    successLabel.textColor = RS_Theme_Color;
    [shareView addSubview:successLabel];
    successLabelSize = [successLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    successLabel.y = iconImageView.bottom + 23;
    successLabel.width = SCREEN_WIDTH;
    successLabel.height = successLabelSize.height;
    successLabel.textAlignment = NSTextAlignmentCenter;
    
    welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"分享红包给好友，可用于抵扣在线支付";
    welcomeLabel.textColor = RS_Theme_Color;
    welcomeLabel.font = RS_FONT_13;
    welcomeLabel.y = successLabel.bottom + 3;
    [shareView addSubview:welcomeLabel];
    welcomeLabelSize = [welcomeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    welcomeLabel.width = SCREEN_WIDTH;
    welcomeLabel.height = welcomeLabelSize.height;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发红包" forState:UIControlStateNormal];
    [btn setTitle:@"发红包" forState:UIControlStateHighlighted];
    btn.titleLabel.font = RS_BOLDFONT_16;
    [btn setTitleColor:RS_Theme_Color forState:UIControlStateNormal];
    [btn setTitleColor:RS_Theme_Color forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(30, welcomeLabel.bottom+46, SCREEN_WIDTH-60, 42);
    if (iPhone5S) {
        btn.y = welcomeLabel.bottom + 23;
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_share_wallet"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_share_wallet"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(shareRedPacket) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:btn];
    
    if (iPhone4S) {
        shareView.height = btn.bottom + 30;
        _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, shareView.height + 10 + paySuccessView.height);
    }else {
        _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.view.frame.size.height-64);
    }
}

- (void)shareRedPacket {
    if (!shareMsgDic) {
        [[RSToastView shareRSToastView] showToast:@"获取分享信息失败"];
        return;
    }
    NSString *title = [shareMsgDic valueForKey:@"title"];
    NSString *context = [shareMsgDic valueForKey:@"desc"];
    NSString *clickUrl = [shareMsgDic valueForKey:@"link"];
    NSString *imageUrl = [shareMsgDic valueForKey:@"imgurl"];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",clickUrl];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",clickUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = context;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=  context;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            XHCustomShareView *shareView = [XHCustomShareView shareViewWithPresentedViewController:self items:@[UMShareToWechatSession,UMShareToWechatTimeline] title:nil image:image urlResource:nil];
            shareView.tag = 9876;
            [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        });
    });
}

- (void)getshareMsg {
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    //TODO
    [requestParams setValue:@"bonus" forKey:@"campaign"];
    NSString *orderid = [NSUserDefaults getValue:@"creatorderid"];
    [requestParams setValue:orderid forKey:@"orderid"];
    
    [RSHttp mobileRequestWithURL:@"/mobile/index/campaignconfig" params:requestParams httpMethod:@"GET" success:^(NSDictionary *data) {
        shareMsgDic = data;
    } failure:^(NSInteger code, NSString *errmsg) {
        shareMsgDic = nil;
    }];

}

- (void)backUp {
    [[AppConfig getAPPDelegate].crrentNavCtl popToRootViewControllerAnimated:NO];
    [AppConfig getAPPDelegate].tabBarControllerConfig.tabBarController.selectedIndex = 1;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
