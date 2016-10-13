//
//  RSTitleImageModel.h
//  RSUser
//
//  Created by 李江 on 16/10/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface RSTitleImageModel : RSModel
@property (nonatomic ,strong)NSString *imageName;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,assign)Boolean linehidden;
@end
