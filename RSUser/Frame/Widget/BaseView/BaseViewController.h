//
//  BaseViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "RSTipsView.h"
#import "CartNumberLabel.h"
#import "BottomCartView.h"


@interface BaseViewController : UIViewController
@property (nonatomic, strong) RSTipsView *tips;
@property (nonatomic, strong) CartNumberLabel *countLabel;
@property (nonatomic, strong) BottomCartView *bottomCartView;

@property (nonatomic, assign)Boolean hasBackBtn;


@property (nonatomic ,assign)Boolean showCartBottom;

@end
