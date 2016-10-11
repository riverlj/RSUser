//
//  AssessmentCell.h
//  RSUser
//
//  Created by 李江 on 16/10/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewCell.h"
#import "XHStarRateView.h"

@interface AssessmentCell : RSTableViewCell<XHStarRateViewDelegate>
@property (nonatomic ,strong)UILabel *goodNameLabel;
@property (nonatomic ,strong)UIView *startsView;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIView *tagsView;
@property (nonatomic ,strong)UIView *celllineView;
@end
