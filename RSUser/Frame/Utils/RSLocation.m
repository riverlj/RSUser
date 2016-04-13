//
//  RSLocation.m
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSLocation.h"
@interface RSLocation()<CLLocationManagerDelegate>

@end

@implementation RSLocation

-(instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)startLocation
{
    _locationManager = [[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    CLLocationDegrees longitude = coordinate.longitude; //经度
    CLLocationDegrees latitude = coordinate.latitude; //纬度
    
    [_locationManager stopUpdatingLocation];
    
    //TODO 39.96101234,116.45981234  中电坐标
    longitude = 39.96101234;
    latitude = 116.45981234;
    NSDictionary *dic = @{
                          @"lat" : [NSNumber numberWithDouble:longitude], //经度
                          @"lng" : [NSNumber numberWithDouble:latitude]    //纬度
                          };
    
    [RSHttp requestWithURL:@"/weixin/locatecommunity" params:dic httpMethod:@"GET" success:^(id data) {
        NSDictionary *dic = (NSDictionary *)data;
        //定位成功
        [NSUserDefaults setCommuntityId:[dic valueForKey:@"id"]];
        [NSUserDefaults setCommuntityId: [dic valueForKey:@"name"]];

    } failure:^(NSInteger code, NSString *errmsg) {
        //定位失败
        NSString *communtityId = [NSUserDefaults getCommuntityId];
        NSString *communtityName = [NSUserDefaults getCommuntityName];
        if (communtityName && communtityId)
        {
            return;
        }
        else
        {
            //TODO跳转到地址搜索页
        }
    }];
    
}

@end
