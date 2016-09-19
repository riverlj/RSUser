//
//  OrderInfoModel.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright © 2016年 lishipeng. All rights reserved.
//


#import "RSModel.h"

@interface OrderInfoModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSInteger business;
@property (nonatomic) NSInteger communityid;
@property (nonatomic, strong) NSString *payed;
@property (nonatomic, strong) NSString *ordertime;
@property (nonatomic) NSInteger subscribetime;
@property (nonatomic, strong) NSString *fastesttime;
@property (nonatomic, strong) NSString *lastesttime;
@property (nonatomic) NSInteger status;
@property (nonatomic, strong) NSString *statusDesc;
@property (nonatomic, strong) NSString *totalprice;
@property (nonatomic, strong) NSString *paymethod;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSArray *deliverys;
@property (nonatomic, strong) NSArray *orderlog;
@property (nonatomic) NSInteger couponid;
@property (nonatomic,strong) NSString* couponmoney;
@property (nonatomic, strong) NSString *coupontitle;
@property (nonatomic) NSInteger notify;
@property (nonatomic, strong) NSString *notifymsg;
@property (nonatomic, strong) NSString *notifytime;
@property (nonatomic, strong) NSArray *promotions;
@property (nonatomic, strong) NSString *amount;


@property (nonatomic) NSInteger canpay; // 支付
@property (nonatomic) NSInteger canreorder; // 再来一单
@property (nonatomic) NSInteger cancancel; //取消
@property (nonatomic) NSInteger canrate; // 评价， 1 评价， 2， 查看评价
@property (nonatomic) NSInteger canrefund; //退单
@property (nonatomic) NSInteger canticket; //反馈

@property (nonatomic, strong) NSDictionary *deliverytime;


@property (nonatomic ,assign)NSInteger displayFlag;
//@property (nonatomic ,strong)UserAddressModell  *userAddressModel;


- (OrderInfoModel *)getUserInfoModel;
- (OrderInfoModel *)sendTimeModel;
- (OrderInfoModel *)getGoodsDetatil;
- (OrderInfoModel *)getOtherInfoModel;

- (void)orderPaySuccess:(void(^)(NSString*))success;
+ (void)getReOrderInfo:(void(^)(NSArray*))success Orderid:(NSString *)orderid;
+ (void)getOrderInfo:(void(^)(OrderInfoModel*))success Orderid:(NSString *)orderid;
@end
