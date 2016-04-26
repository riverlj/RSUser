//
//  HeadviewCell.m
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "HeadviewCell.h"

@implementation HeadviewCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:RS_Theme_Color];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 52, 99, 101)];
        bgView.image = [UIImage imageNamed:@"bg_headView"];
        [self.contentView addSubview:bgView];
        
        UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 92, 92)];
        headView.centerX = bgView.width/2;
        headView.centerY = bgView.height/2;
        headView.layer.cornerRadius = headView.width/2;
        headView.layer.borderColor = [UIColor whiteColor].CGColor;
        headView.layer.borderWidth = 2;
        headView.clipsToBounds = YES;
        [headView sd_setImageWithURL:[NSURL URLWithString:@"http://i01.lw.aliimg.com/media/lADOB8Ps-s0Cfs0CgA_640_638.jpg"]];
        [bgView addSubview:headView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgView.right+31, 0, SCREEN_WIDTH - bgView.right - 36 - 31, 20)];
        _nameLabel.bottom = bgView.centerY -6;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = Font(17);
        [self.contentView addSubview:_nameLabel];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 13, 15, 15)];
        icon.image = [UIImage imageNamed:@"icon_phone1"];
        [self.contentView addSubview:icon];
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(icon.right + 5, icon.top, _nameLabel.width - 5 - icon.width, 14)];
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.font = Font(14);
        [self.contentView addSubview:_phoneLabel];
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        arrow.right = SCREEN_WIDTH - 18;
        arrow.centerY = 102;
        arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:arrow];
    }
    return self;
}

-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    _nameLabel.text = @"lishipeng";
    _phoneLabel.text = @"18910257050";
}
@end
