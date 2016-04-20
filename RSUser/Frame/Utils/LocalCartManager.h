//
//  LocalCartManager.h
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalCartManager : NSObject
+ (LocalCartManager *)shareLocalCartManager;
//所有学校的购物车数据
@property (nonatomic, strong)NSMutableDictionary *allSchoolCartData;
//当前学校的购物车数据
@property (nonatomic, strong)NSMutableArray *localCartData;
- (void)saveData;
- (NSMutableArray *)getData;
- (NSInteger)getMergeFlag;
- (void)saveMergeFlag:(NSInteger)merge;
@end
