//
//  RSTitleCell.m
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//


#import "RSTitleCell.h"
#import "RSTitleModel.h"

@implementation RSTitleCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    }
    return self;
}

-(void) setModel:(RSTitleModel *)model
{
    [super setModel:model];
    self.titleLabel.attributedText = model.attrStr;
}
@end
