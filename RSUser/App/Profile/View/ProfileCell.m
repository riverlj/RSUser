//
//  ProfileCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-22.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "ProfileCell.h"
#import "ProfileModel.h"

@implementation ProfileCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, 200, 49)];
        _titleLabel.textColor = RS_COLOR_C2;
        _titleLabel.font = RS_FONT_F2;
        [self.contentView addSubview:_titleLabel];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 15, 15)];
        _imgView.centerY = 49/2;
        [self.contentView addSubview:_imgView];
        _titleLabel.x = _imgView.right+10;
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        arrow.right = SCREEN_WIDTH - 10;
        arrow.centerY = 49/2;
        arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:arrow];
        
        self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(10, 43, SCREEN_WIDTH-10, 1) Color:RS_Line_Color];
        self.lineView.hidden = YES;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

-(void) setModel:(ProfileModel *)model
{
    [super setModel:model];
    self.titleLabel.text = model.title;
    if([model.imgUrl hasPrefix:@"http"]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    } else {
        self.imgView.image = [UIImage imageNamed:model.imgUrl];
    }
    self.lineView.hidden = model.hiddenLine;
}
@end
