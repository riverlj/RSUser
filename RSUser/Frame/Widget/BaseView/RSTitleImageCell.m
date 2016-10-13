//
//  RSTitleImageCell.m
//  RSUser
//
//  Created by 李江 on 16/10/12.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTitleImageCell.h"
#import "RSTitleImageModel.h"

@implementation RSTitleImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) Color:RS_Line_Color];
        self.lineView.hidden = YES;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

-(void)setModel:(RSTitleImageModel *)model{
    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.titleLabel.text = model.title;
    self.lineView.hidden = model.linehidden;
}

@end
