//
//  RSTwoTitleViewModel.h
//  RSUser
//
//  Created by 李江 on 16/8/15.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface RSTwoTitleViewModel : RSModel
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *subtitle;
@property (nonatomic, strong)NSDictionary *titleAttrs;
@property (nonatomic, strong)NSDictionary *subtitleAttrs;
@end
