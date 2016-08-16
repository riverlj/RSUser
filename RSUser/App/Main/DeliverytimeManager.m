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
@property (nonatomic, strong)NSMutableDictionary *selectedTimes;
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
        self.selectedTimes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)getTimesByCategoryid:(NSInteger)categoryid {
    NSArray * array = [_deliveryTimes valueForKey:[NSString stringFromNumber:@(categoryid)]];
    return array;
}

- (void)addDeliveryTimes:(NSArray *)array categoryid:(NSInteger)categoryid {
    [_deliveryTimes setValue:array forKey:[NSString stringFromNumber:@(categoryid)]];
}

+ (void) getDeliveryTimesFromNet:(void (^)(void))sucess {
    
    NSDictionary *params = @{
                             @"communityid" : COMMUNTITYID
                             };
    
    [RSHttp requestWithURL:@"/community/deliverytimes" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *key = [data allKeys];
        DeliverytimeManager *deliverytimeManager = [DeliverytimeManager shareDelivertimeManger];
        for (int i=0; i<key.count; i++) {
            NSMutableArray *timeModelArray = [[NSMutableArray alloc]init];
            NSArray *timesArray = [data valueForKey:key[i]];
            
            NSString *temp = key[i];
            for (int j=0; j<timesArray.count; j++) {
                NSDictionary *dic = timesArray[j];
                DeliverytimeModel *model = [MTLJSONAdapter modelOfClass:[DeliverytimeModel class] fromJSONDictionary:dic error:nil];
                [timeModelArray addObject:model];
                
            }
            
            [deliverytimeManager addDeliveryTimes:timeModelArray categoryid:temp.integerValue];
        }
        sucess();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

- (NSDictionary *)getSelectedTimeWithCategoryid:(NSInteger)categoryid {
     NSDictionary *dic = [self.selectedTimes valueForKey:[NSString stringFromNumber:@(categoryid)]];
    if (!dic) {
        NSArray *array = [self getTimesByCategoryid:categoryid];
        DeliverytimeModel *model = array[0];
        dic = @{
               @"date" : model.date,
               @"time" : model.time[0]
               };
        
        [self.selectedTimes setValue:dic forKey:[NSString stringFromNumber:@(categoryid)]];
    }
    
    return dic;
    
}

- (void)setSelectedTimes:(NSDictionary *)dic With:(NSInteger)categoryid {
    [self.selectedTimes setValue:dic forKey:[NSString stringFromNumber:@(categoryid)]];
}

-(void) clearData {
    [self.selectedTimes removeAllObjects];
    [self.deliveryTimes removeAllObjects];
}
@end
