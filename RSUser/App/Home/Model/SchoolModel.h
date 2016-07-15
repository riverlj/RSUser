//
//  SchoolModel.h
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface ChannelViewModel : RSModel
@property (nonatomic, strong)NSMutableArray *channelsArray;
@end

@interface ChannelModel : RSModel<MTLJSONSerializing>

/**频道ID*/
@property (nonatomic ,assign)NSInteger channelId;
/**频道文案*/
@property (nonatomic, strong)NSString *title;
/**频道频道LOGO*/
@property (nonatomic, strong)NSString *path;
/**App使用的跳转链接*/
@property (nonatomic, strong)NSString *appurl;
@property (nonatomic, strong)NSString *h5url;

-(NSComparisonResult) sortChannels: (ChannelModel *)another;
@end

@interface SchoolModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,assign)NSInteger communtityId;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *closedesc;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,copy)NSString *fastesttime;
@property (nonatomic ,copy)NSString *lastesttime;
@property (nonatomic ,strong)NSArray *subscribedates;
@property (nonatomic ,strong)NSDictionary *deliverytime;
@property (nonatomic ,assign)CGFloat minprice;
@property (nonatomic ,strong)NSArray *channels;
@property (nonatomic, strong) NSString *contactMobile;

+ (void)getSchoolMsg:(void (^)(SchoolModel *))successArray;
@end