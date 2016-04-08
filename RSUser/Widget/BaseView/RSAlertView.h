//
//  RSAlertView.h
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAlertView : NSObject
@property (nonatomic, strong)MBProgressHUD *hud;
+(id)shareRSAlertView;
+(void)alertView:(NSString *)msg;

- (void)showHUD:(NSString *)title;
- (void)hidHUD;
-(void)showToast:(NSString *)str;

@end
