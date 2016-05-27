//
//  AboutUsViewController.m
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AboutusViewController.h"

@implementation AboutusViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 64, 82)];
    logo.centerX = SCREEN_WIDTH/2;
    logo.image = [UIImage imageNamed:@"logo_version"];
    [self.view addSubview:logo];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, logo.bottom, 100, 20)];
    versionLabel.text = @"";
    versionLabel.centerX = SCREEN_WIDTH/2;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = RS_MainLable_Text_Color;
    versionLabel.text = [NSString stringWithFormat:@"版本%@", [UIDevice clientVersion]];
    [self.view addSubview:versionLabel];
    
    UIImageView *wxLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, versionLabel.bottom + 32, 29, 24)];
    wxLogo.image = [UIImage imageNamed:@"logo_weixin"];
    wxLogo.centerX = versionLabel.left;
    [self.view addSubview:wxLogo];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(wxLogo.right + 5, 0, 80, 15)];
    nameLabel.centerY = wxLogo.centerY;
    nameLabel.font = Font(13);
    nameLabel.textColor = RS_TabBar_Title_Color;
    nameLabel.text = @"aihonglingjin";
    [self.view addSubview:nameLabel];
 
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 10)];
    copyrightLabel.numberOfLines = 0;
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:4];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          Font(10), NSFontAttributeName,
                          RS_TabBar_Title_Color, NSForegroundColorAttributeName,
                          paragraphStyle, NSParagraphStyleAttributeName,
                          nil];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"宜兴大师兄科技有限公司\nBig brother Technology Co., Ltd\n苏ICP备15033358号-1" attributes:dict];
    [copyrightLabel setGrowthAttributedText:attrStr];
    copyrightLabel.bottom = SCREEN_HEIGHT - 20 - 64;
    copyrightLabel.centerX = SCREEN_WIDTH/2;
    [self.view addSubview:copyrightLabel];
}
@end
