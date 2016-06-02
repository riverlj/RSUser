//
//  LoginViewController.h
//  RSUser
//
//  Created by 李江 on 16/4/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginView.h"
#import "LoginModel.h"

@interface LoginViewController : BaseViewController

@property (nonatomic ,strong)LoginView *loginView;
@property (nonatomic ,strong)LoginModel *loginModel;

@end
