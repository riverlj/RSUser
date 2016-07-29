//
//  GoodInfoView.m
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodInfoView.h"
#import "GoodModel.h"

@implementation GoodInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.saledLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.addCartBtn];
        [self addSubview:self.goodInfoLabel];
        [self addSubview:self.goodDesLabel];
    }
    return self;
}

-(UILabel *)nameLabel{
    if (_nameLabel) {
        return _nameLabel;
    }
    _nameLabel = [RSLabel mainLabel];
    return _nameLabel;
}

-(UILabel *)saledLabel {
    if (_saledLabel) {
        return _saledLabel;
    }
    _saledLabel = [RSLabel twoLabel];
    return _saledLabel;
}

-(UILabel *)priceLabel {
    if (_priceLabel) {
        return _priceLabel;
    }
    _priceLabel = [RSLabel themeLabel];
    return _priceLabel;
}

-(UILabel *)goodInfoLabel {
    if (_goodInfoLabel) {
        return _goodInfoLabel;
    }
    _goodInfoLabel = [RSLabel twoLabel];
    return _goodInfoLabel;
}

-(UILabel *)goodDesLabel{
    if (_goodDesLabel) {
        return _goodDesLabel;
    }
    _goodDesLabel = [RSLabel twoLabel];
    return _goodDesLabel;
}

-(UIButton *)addCartBtn {
    if (_addCartBtn) {
        return _addCartBtn;
    }
    _addCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addCartBtn.width = 85;
    _addCartBtn.height = 24;
    _addCartBtn.backgroundColor = RS_Theme_Color;
    _addCartBtn.layer.cornerRadius = 10;
    return _addCartBtn;
}

-(UIImageView *)headImageView {
    if (_headImageView) {
        return _headImageView;
    }
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    _headImageView.backgroundColor = RS_Background_Color;
    return _headImageView;
}

-(UILabel *)goodInfoTitleLabel{
    if (_goodInfoTitleLabel) {
        return _goodInfoTitleLabel;
    }
    _goodInfoTitleLabel = [RSLabel mainLabel];
    _goodInfoTitleLabel.text = @"商品详情:";
    return _goodInfoTitleLabel;
}

- (UILabel *)goodDesTitleLabel{
    if (_goodDesTitleLabel) {
        return _goodDesTitleLabel;
    }
    
    _goodDesTitleLabel = [RSLabel mainLabel];
    _goodDesTitleLabel.text = @"商品描述:";
    return _goodDesTitleLabel;
}

-(void)setModel:(GoodModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    self.nameLabel.text = model.name;
    self.saledLabel.text = [NSString stringWithFormat:@"已售%ld份",model.saled];
    self.goodInfoLabel.text = model.dashinfo;
    self.goodDesLabel.text = model.desc;
    
    [self setSubViewFrame];
}


-(void)setSubViewFrame{
    CGFloat h1 = 0;
    CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.nameLabel.frame = CGRectMake(18, _headImageView.bottom+15, nameSize.width,nameSize.height);
    
    CGSize saledSize = [self.saledLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.saledLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 6, saledSize.width, saledSize.height);
    
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.priceLabel.frame = CGRectMake(self.nameLabel.left, self.saledLabel.bottom+10 , priceSize.width, priceSize.height);
    
    self.addCartBtn.x = SCREEN_WIDTH-18+self.addCartBtn.width;
    self.addCartBtn.y = self.priceLabel.top - 5;
    
    h1 = self.headImageView.y + self.headImageView.height + self.priceLabel.bottom + 15;
}
@end
