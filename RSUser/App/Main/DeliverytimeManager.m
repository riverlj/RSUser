//
//  DeliverytimeManager.m
//  RSUser
//
//  Created by 李江 on 16/8/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "DeliverytimeManager.h"
#import "DeliverytimeModel.h"

static DeliverytimeManager *deliverytimeManager = nil;

@interface DeliverytimeManager()
/**
 {
    categoryid : times(timeModel);
 }
 */
@property (nonatomic, strong)NSMutableDictionary *deliveryTimes;
@end

@implementation DeliverytimeManager

+ (id)shareDelivertimeManger {
    @synchronized (self) {
        if (!deliverytimeManager) {
            deliverytimeManager = [[DeliverytimeManager alloc]init];
        }
    }
    
    return deliverytimeManager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.deliveryTimes = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setDeliveryTimes:(NSDictionary *)deliveryTimes{
    _deliveryTimes = [deliveryTimes mutableCopy];
}

- (NSArray *)getTimesByCategoryid:(NSInteger)categoryid {
    NSArray * array = [_deliveryTimes valueForKey:[NSString stringFromNumber:@(categoryid)]];
    return array;
}

- (void)addDeliveryTimes:(NSArray *)array categoryid:(NSInteger)categoryid {
    [_deliveryTimes setValue:array forKey:[NSString stringFromNumber:@(categoryid)]];
}

+ (void) getDeliveryTimesFromNet {
    
    NSDictionary *params = @{
                             @"communityid" : COMMUNTITYID
                             };
    
    [RSHttp requestWithURL:@"/community/deliverytimes" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSLog(@"%@", data);
        NSArray *key = [data allKeys];
        DeliverytimeManager *deliverytimeManager = [DeliverytimeManager shareDelivertimeManger];
        for (int i=0; i<key.count; i++) {
            NSMutableArray *timeModelArray = [[NSMutableArray alloc]init];
            NSArray *timesArray = [data valueForKey:key[i]];
            for (int j=0; j<timesArray.count; j++) {
                NSDictionary *dic = timesArray[j];
                DeliverytimeModel *model = [MTLJSONAdapter modelOfClass:[DeliverytimeModel class] fromJSONDictionary:dic error:nil];
                [timeModelArray addObject:model];
            }
            NSString *temp = key[i];
            [deliverytimeManager addDeliveryTimes:timeModelArray categoryid:temp.integerValue];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

- (void)updateDeliveryTimes {
    [DeliverytimeManager getDeliveryTimesFromNet];
}

@end
