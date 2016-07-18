//
//  brandListModel.h
//  RSUser
//
//  Created by 李江 on 16/7/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface BrandListModel : RSModel<MTLJSONSerializing>

@property (nonatomic ,assign)NSInteger brandId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *logoimg;
@property (nonatomic ,strong)NSArray *detailimg;
@property (nonatomic ,assign)NSInteger hasmore;
@property (nonatomic ,strong)NSArray *products;

@end
