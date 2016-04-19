//
//  AppDelegate.h
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLocation.h"
#import "CartViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)RSLocation *location;

@property (nonatomic, strong)NSMutableArray *localCartData;
@property (nonatomic, strong)CartViewController *cartViewVc;

@end

