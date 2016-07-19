//
//  brandListModel.h
//  RSUser
//
//  Created by 李江 on 16/7/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"
@class BrandListModel;

typedef void(^ClickMoreBtnBlock)(BrandListModel *channelModel);
@interface BrandListModel : RSModel<MTLJSONSerializing>

@property (nonatomic ,assign)NSInteger brandId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *logoimg;
@property (nonatomic ,strong)NSArray *detailimg;
@property (nonatomic ,assign)NSInteger hasmore;
@property (nonatomic ,strong)NSArray *products;

@property (nonatomic ,copy)ClickMoreBtnBlock clickMoreBtnBlock;


@end
