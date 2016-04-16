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
        _locationManager = [[CLLocationManager alloc]init];
    }
    return self;
}

- (void)startLocation
{
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

//地理坐标恢复
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    [manager startUpdatingLocation];
}

//获取地理坐标失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //地位失败跳转到首页
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    CLLocationDegrees longitude = coordinate.longitude; //经度
    CLLocationDegrees latitude = coordinate.latitude; //纬度
    
    [manager stopUpdatingLocation];
    
    NSDictionary *dic = @{
                          @"lat" : [NSNumber numberWithDouble:longitude], //经度
                          @"lng" : [NSNumber numberWithDouble:latitude]    //纬度
                          };
    
    [RSHttp requestWithURL:@"/weixin/locatecommunity" params:dic httpMethod:@"GET" success:^(id data) {
        NSDictionary *dic = (NSDictionary *)data;
        // 将信息存到本地文件
        if (!COMMUNTITYID)
        {
            [LOCATIONMODEL setLocationModel:dic];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        //获取位置信息失败
    }];
}

@end
