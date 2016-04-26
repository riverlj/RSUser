//
//  CouponViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponModel.h"

@interface CouponViewController()

@end

@implementation CouponViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self beginHttpRequest];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"/weixin/coupon";
    self.useHeaderRefresh = YES;
}

-(void)beforeHttpRequest{
    [super beforeHttpRequest];
    [self.params setValue:@"history" forKey:@"type"];

}
-(void) afterHttpSuccess:(NSDictionary *)data
{
    NSArray *temp = [[MTLJSONAdapter modelsOfClass:[CouponModel class] fromJSONArray:data error:nil] mutableCopy];
    [self.models addObjectsFromArray:temp];
}
@end
