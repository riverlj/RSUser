//
//  HomeViewController.h
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSRefreshTableViewController.h"
#import "SDCycleScrollView.h"

@interface HomeViewController : RSRefreshTableViewController
@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end
