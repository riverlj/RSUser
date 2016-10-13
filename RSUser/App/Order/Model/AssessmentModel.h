//
//  AssessmentModel.h
//  RSUser
//
//  Created by 李江 on 16/10/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface TagModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,strong)NSNumber *tagid;
@property (nonatomic ,strong)NSString *tagcontent;
@property (nonatomic ,assign)Boolean tagfavorable;
@property (nonatomic, assign)Boolean isSelected;

@end

typedef enum : NSUInteger {
    AssessmentDelivery,
    AssessmentGood,
} AssessmentType;

@interface AssessmentGoodModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,strong)NSNumber *goodid;
@property (nonatomic ,strong)NSString *goodname;
@property (nonatomic ,strong)NSDictionary *tag;
@property (nonatomic ,strong)NSDictionary *tagObjs;
@property (nonatomic ,strong)NSString *currentkey;

@property (nonatomic ,assign)AssessmentType assessmenttype;

- (NSArray *)getCurrentTags;
- (void)setSelected:(Boolean)tagfavorable withTagid:(NSNumber *)tagid;
- (void)setNOFavorable;
- (NSArray *)getSelectedTag;

@end

@interface AssessmentModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,strong)NSArray *product;
@property (nonatomic ,strong)AssessmentGoodModel *delivery;

+ (void)getAssessmentWithOrderid:(NSString *)orderid success:(void(^)(AssessmentModel *assessmentModel))success failure:(void(^)(void))failure;
+(void)submitRate:(NSDictionary *)params success:(void (^)(void)) success failure:(void (^) (void)) failure;
@end
