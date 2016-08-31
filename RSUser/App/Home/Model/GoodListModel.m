//
//  GoodListModel.m
//  RSUser
//
//  Created by 李江 on 16/4/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodListModel.h"

@implementation GoodListpromotion

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"desc" : @"desc",
             @"title" : @"title",
             @"type" : @"type",
             @"promotionid" : @"id",
             };
}

- (NSString *)getImageNameByType {
    NSString *imageName = @"icon_hui";
    
    if (self.type == 2) {
        imageName = @"icon_zhe";
    }else if(self.type == 5) {
        imageName = @"icon_zeng";
    }
    return imageName;
}
@end

@implementation GoodListModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"saled" : @"saled",
             @"canbuymax" : @"canbuymax",
             @"saleprice" : @"saleprice",
             @"desc" : @"desc",
             @"productid" : @"productid",
             @"comproductid" : @"id",
             @"headimg" : @"headimg",
             @"name" : @"name",
             @"price" : @"price",
             @"topcategoryid" : @"topcategoryid",
             @"ishot" : @"ishot",
             @"isnew" : @"isnew",
             @"promotions" : @"promotions"
             };
}

-(NSString *)headimg {
    if (!_headimg) {
        return nil;
    }
    NSString *sizestr = @"@140w_140h_1e_1c";
    if ([_headimg isAliyImageUrlStr] && ![_headimg hasSuffix:sizestr]) {
        _headimg = [_headimg stringByAppendingString:sizestr];
    }
    return _headimg;
}

+ (NSValueTransformer *)promotionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:GoodListpromotion.class];
}

- (NSString *)getImageNameBytopcategoryid {
    NSString *imageName = @"";
    if (self.topcategoryid == 1) {
        imageName = @"label_breakfast";
    }else if(self.topcategoryid == 2) {
        imageName = @"label_lunch";
    }else if(self.topcategoryid == 3) {
        imageName = @"label_fruit";
    }
    return imageName;
}
@end

