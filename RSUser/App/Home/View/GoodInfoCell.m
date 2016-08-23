//
//  GoodInfoCell.m
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodInfoCell.h"
#import "GoodListModel.h"

@implementation GoodInfoSubCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.saledLabel];
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
    _saledLabel.textAlignment = NSTextAlignmentLeft;
    _saledLabel.numberOfLines = 0;
    return _saledLabel;
}

-(UIView *)lineView {
    if (_lineView) {
        return _lineView;
    }
    _lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-18, 1) Color:RS_Line_Color];
    return _lineView;
}

-(void)setModel:(GoodModel *)model{
    [self.lineView removeFromSuperview];
    
    CGFloat cellHeight = 0;
    self.nameLabel.text = model.name;
    self.saledLabel.text = model.subText;
    
    CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.nameLabel.frame = CGRectMake(18, 15, nameSize.width,nameSize.height);
    
    CGSize saledSize = [self.saledLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.saledLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 6, SCREEN_WIDTH-2*self.nameLabel.left, saledSize.height);
    
    cellHeight = self.saledLabel.bottom + 15;
    
    if (!model.lineHidden) {
        [self.contentView addSubview:self.lineView];
        cellHeight += 1;
    }
    
    model.cellHeight = cellHeight;

}

@end

@implementation GoodInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.addCartBtn];
        [self.contentView addSubview:self.subIV];
        [self.contentView addSubview:self.addIV];
        [self.contentView addSubview:self.countLabel];
        
        [RACObserve(self.countLabel, text) subscribeNext:^(NSString *value) {
            if ([value integerValue] > 0) {
                self.addCartBtn.hidden = YES;
                self.addIV.hidden = NO;
                self.subIV.hidden = NO;
            }else{
                self.addCartBtn.hidden = NO;
                self.addIV.hidden = YES;
                self.subIV.hidden = YES;
            }
        }];
    }
    return self;
}

-(UILabel *)priceLabel {
    if (_priceLabel) {
        return _priceLabel;
    }
    _priceLabel = [RSLabel themeLabel];
    return _priceLabel;
}

-(UIImageView *)addIV {
    if (_addIV) {
        return _addIV;
    }
    _addIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    _addIV.contentMode = UIViewContentModeLeft;
    [_addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [_addIV addTapAction:@selector(addCartBtnClicked:) target:self];
    return _addIV;
}

-(UIImageView *)subIV{
    if (_subIV) {
        return _subIV;
    }
    _subIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    _subIV.contentMode = UIViewContentModeRight;
    [_subIV setImage:[UIImage imageNamed:@"subActivate"]];
    [_subIV addTapAction:@selector(subCountClick) target:self];
    return _subIV;
}

-(UILabel *)countLabel{
    if (_countLabel) {
        return _countLabel;
    }
    _countLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_COLOR_NUMLABEL];
    _countLabel.font = RS_FONT_F2;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    return _countLabel;
}

-(UIButton *)addCartBtn {
    if (_addCartBtn) {
        return _addCartBtn;
    }
    _addCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addCartBtn.width = 85;
    _addCartBtn.height = 24;
    _addCartBtn.backgroundColor = RS_Theme_Color;
    _addCartBtn.layer.cornerRadius = 12;
    [_addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    _addCartBtn.titleLabel.font = RS_FONT_F4;
    [_addCartBtn addTarget:self action:@selector(addCartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return _addCartBtn;
}

-(void)setModel:(GoodModel *)model {
    [super setModel:model];
    self.goodmodel = model;
    CGFloat cellHeight = 0;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@", model.saleprice];
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    _priceLabel.frame = CGRectMake(self.nameLabel.left, self.saledLabel.bottom+10, priceSize.width, priceSize.height);
    self.addCartBtn.x = SCREEN_WIDTH - 10 - self.addCartBtn.width;
    self.addCartBtn.y = self.priceLabel.top - 5;
    
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    self.addIV.frame = CGRectMake(SCREEN_WIDTH-32, 93/2, 2*addSize.width, 93/2);
    self.addIV.centerY = self.addCartBtn.centerY;
    
    self.countLabel.frame = CGRectMake(self.addIV.x- 38, self.addIV.top, 38, self.addIV.height);
    if (model.num > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%ld",model.num];
    }else{
        self.countLabel.text = @"";
    }
    self.countLabel.centerY = self.addCartBtn.centerY;
    
    self.subIV.frame = CGRectMake(self.countLabel.x-2*addSize.width, self.addIV.top, self.addIV.width, self.addIV.height);
    self.subIV.centerY = self.addCartBtn.centerY;
    
    cellHeight = self.priceLabel.bottom + 15;
    model.cellHeight = cellHeight;
}

- (void)addCartBtnClicked:(UIButton *)sender
{
    if (self.countLabel.text.integerValue >= self.goodmodel.canbuymax && self.goodmodel.canbuymax!=-1) {
        
        [[RSToastView shareRSToastView] showToast:@"库存不足啦，先买这么多吧～"];
        return;
    }
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    UIImageView *throwedView = [[UIImageView alloc]init];
    throwedView.frame = CGRectMake(self.addIV.x, self.addIV.y + (self.addIV.y - addSize.height)/2, addSize.width, addSize.height);
    [throwedView setImage:[UIImage imageNamed:@"addActivate"]];
    throwedView.contentMode = UIViewContentModeLeft;
    
    throwedView.tag = 10;
    [self.contentView addSubview:throwedView];
    
    
    ThrowLineTool *throwLineTool = [ThrowLineTool sharedTool];
    throwLineTool.delegate = self;
    CartNumberLabel *cartNumberLabel = [CartNumberLabel shareCartNumberLabel];
    CGPoint cartLabelPoint = cartNumberLabel.center;
    
    cartLabelPoint = [cartNumberLabel.superview convertPoint:cartLabelPoint toView:self.contentView];
    CGRect beginRect = [self.addIV.superview convertRect:self.addIV.frame toView:nil];
    CGRect endRect = [cartNumberLabel.superview convertRect:cartNumberLabel.frame toView:nil];
    cartLabelPoint = [cartNumberLabel.superview convertPoint:cartLabelPoint toView:nil];
    
    CGPoint benginPoint = CGPointMake(beginRect.origin.x+self.addIV.width/2, beginRect.origin.y+self.addIV.height/2);
    CGPoint endpoint = CGPointMake(endRect.origin.x+cartNumberLabel.width/2, endRect.origin.y+cartNumberLabel.height/2);
    
    UIWindow *window = [AppConfig getAPPDelegate].window;
    throwedView.frame = beginRect;
    [window addSubview:throwedView];
    
    [throwLineTool throwObject:throwedView from:benginPoint to:endpoint height:40 duration:0.5];
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] +1];
    
    
    if ([self.countLabel.text integerValue] > 0)
    {
        self.subIV.hidden = NO;
        self.countLabel.hidden = NO;
    }
    
    [[Cart sharedCart] addGoods:[self goodmodelToGoodListModel:self.goodmodel]];
    
}

- (void)animationDidFinish
{
    [[[AppConfig getAPPDelegate].window viewWithTag:10] removeFromSuperview];
}

- (void)subCountClick
{
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] -1];
    if ([self.countLabel.text integerValue] == 0)
    {
        self.subIV.hidden = YES;
        self.countLabel.hidden = YES;
    }
    
    [[Cart sharedCart] deleteGoods:[self goodmodelToGoodListModel:self.goodmodel]];
}


- (GoodListModel *)goodmodelToGoodListModel:(GoodModel *)goodModel {
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:goodModel error:NULL];
    GoodListModel *goodListModel = [MTLJSONAdapter modelOfClass:[GoodListModel class] fromJSONDictionary:dic error:NULL];
    goodListModel.num = goodModel.num;
    return goodListModel;
}

@end
