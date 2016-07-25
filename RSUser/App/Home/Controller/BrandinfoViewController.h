//
//  BrandinfoViewController.h
//  RSUser
//
//  Created by 李江 on 16/7/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface BrandinfoViewController : RSRefreshTableViewController
@property (nonatomic ,assign)NSInteger brandid;
@property (nonatomic ,strong)NSString *brandName;
@property (nonatomic ,copy)NSString *navtitle;


@end
