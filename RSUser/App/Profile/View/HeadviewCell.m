//
//  HeadviewCell.m
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "HeadviewCell.h"
#import "UserInfoModel.h"

@implementation HeadviewCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
//        [self setBackgroundColor:RS_Theme_Color];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-79)/2.0, 17, 79, 80)];
        bgView.image = [UIImage imageNamed:@"bg_headView"];
        [self.contentView addSubview:bgView];
        
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        _headView.centerX = bgView.width/2;
        _headView.centerY = bgView.height/2;
        _headView.layer.cornerRadius = _headView.width/2;
        _headView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headView.image = [UIImage imageNamed:@"icon_header"];
        _headView.layer.borderWidth = 2;
        _headView.clipsToBounds = YES;
        [bgView addSubview:_headView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, bgView.bottom+5, 0,0)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = Font(17);
        [self.contentView addSubview:_nameLabel];
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,145)];
        bgImgView.image = [UIImage imageNamed:@"bg_headcell"];
        [self.contentView addSubview:bgImgView];
        [self.contentView sendSubviewToBack:bgImgView];
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        arrow.right = SCREEN_WIDTH - 18;
        arrow.centerY = 145/2;
        arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:arrow];
        
    }
    return self;
}

-(void) setModel:(UserInfoModel *)model
{
    [super setModel:model];
    _nameLabel.text = model.name;
    CGSize size = [_nameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    _nameLabel.x = (SCREEN_WIDTH-size.width)/2.0;
    _nameLabel.width = size.width;
    _nameLabel.height = size.height;
    
    _phoneLabel.text = model.mobile;
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"icon_header"] ];
}


@end
