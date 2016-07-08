//
//  ChooseCouponViewController.h
//  RSUser
//
//  Created by 李江 on 16/5/16.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewController.h"

typedef void (^SelectedCouponBlock) (void);
@interface ChooseCouponViewController : RSTableViewController
@property (nonatomic ,strong)NSArray *couponArray;
@property (nonatomic ,copy)SelectedCouponBlock selectedCouponBlock;


@end
