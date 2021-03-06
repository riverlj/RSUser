//
//  TicketCell.h
//  RedScarf
//
//  Created by lishipeng on 2016-05-04.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSTableViewCell.h"
@class TicketModel;

@protocol CheckItemDelagete <NSObject>

- (void)checkeTicketModel:(NSInteger)ticketid;
@end

@interface TicketTextFiled : UITextField
@end

@interface TicketCell : RSTableViewCell
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UIImageView *checkedImageView;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIView *radiosContentView;

@property (nonatomic ,strong)RSRadioGroup *radios;

@property (nonatomic ,weak)id target;
@property (nonatomic, strong)TicketModel *ticketModel;
@property (nonatomic, weak)id<CheckItemDelagete> checkItemDelagete;


@end

