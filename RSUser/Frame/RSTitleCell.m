//
//  RSTitleCell.m
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//


#import "RSTitleCell.h"

@implementation RSTitleCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
        
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    }
    return self;
}

-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    //self.titleLabel.attributedText = model.title;
    
}
@end
