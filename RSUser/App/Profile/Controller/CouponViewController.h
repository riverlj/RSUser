//
//  CouponViewController.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface CouponViewController : RSRefreshTableViewController<UITextFieldDelegate>
@property(nonatomic, strong) UIView *headView;
@property(nonatomic) NSInteger searchType;
@property(nonatomic) BOOL selectReturn; //选中后是否返回
@end

