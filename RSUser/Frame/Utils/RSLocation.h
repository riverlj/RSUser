//
//  RSLocation.h
//  RSUser
//
//  Created by 李江 on 16/4/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSLocation : NSObject
@property (nonatomic ,strong)CLLocationManager *locationManager;
- (void)startLocation;
@end