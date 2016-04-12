//
//  BannerModel.h
//  RSUser
//
//  Created by 李江 on 16/4/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface BannerModel : RSModel<MTLJSONSerializing>
/**图片链接*/
@property (nonatomic ,copy)NSString *path;
/**点击链接*/
@property (nonatomic ,copy)NSString *url;
/**banner标题*/
@property (nonatomic ,copy)NSString *title;

+ (void)getBannerArraySuccess:(void (^)(NSArray *))successArray;

@end
