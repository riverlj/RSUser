//
//  PromotionModel.h
//  RSUser
//
//  Created by 李江 on 16/8/9.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface PromotionModel : RSModel<MTLJSONSerializing>

@property (nonatomic, strong)NSArray *coupons;
@property (nonatomic, strong)NSArray *moneypromotions;
@property (nonatomic, strong)NSArray *paypromotions;
@property (nonatomic, strong)NSArray *giftpromotions;

+ (void)getPromotion:(void(^)(PromotionModel *))success;
@end


@interface GiftModel : RSModel<MTLJSONSerializing>
@property (nonatomic, assign)NSInteger masterid;
@property (nonatomic, strong)NSString *master_name;
@property (nonatomic, assign)NSInteger master_amount;

@property (nonatomic ,assign)NSInteger giftid;
@property (nonatomic, strong)NSString *gift_name;
@property (nonatomic, assign)NSInteger gift_amount;
@end

@interface GiftPromotionModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,assign)NSInteger giftpromotionid;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic, strong)NSDictionary *gift;
@end

@interface MoneypromotionModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong)NSString *desc;
@property (nonatomic ,assign)CGFloat reduce;
@property (nonatomic ,assign)NSInteger moneypromotionid;
@property (nonatomic ,assign)NSInteger type;

@property (nonatomic ,strong)NSString *imageName;
@end

@interface  MoneypromotionViewModel : RSModel
@property (nonatomic, strong)MoneypromotionModel *moneypromotionModel;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *subtitle;
@property (nonatomic, strong)NSString *imageName;
@property (nonatomic, strong)NSString *reduce;
@end

@interface ConfirmOrderDetailViewModel : RSModel
@property (nonatomic ,assign)NSInteger categoryid;
@property (nonatomic ,strong)NSString *categoryName;
@property (nonatomic ,strong)NSString *sendTimeDes;
@property (nonatomic ,strong)NSString *sendDay;
@property (nonatomic ,strong)NSString *sendTime;
@property (nonatomic ,strong)NSArray *goods;
@property (nonatomic, strong)NSArray *gifts;

@property (nonatomic ,strong)NSString *viewType;


@property (nonatomic ,assign)Boolean cellLineHidden;

@property (nonatomic, assign)BOOL inOderDetail;

@end
