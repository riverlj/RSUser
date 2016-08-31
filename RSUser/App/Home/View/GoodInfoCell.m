//
//  GoodInfoCell.m
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodInfoCell.h"
#import "GoodListModel.h"

#define MARGIN_LEFT 18

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
{
    NSInteger maxCount;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.hotImageView];
        [self.contentView addSubview:self.newsImageView];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.addCartBtn];
        [self.contentView addSubview:self.subIV];
        [self.contentView addSubview:self.addIV];
        [self.contentView addSubview:self.goodInfolineView];
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

- (UIImageView *)hotImageView {
    if (_hotImageView) {
        return _hotImageView;
    }
    _hotImageView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@"label_hot"];
    _hotImageView.hidden = YES;
    return _hotImageView;
}

-(UIImageView *)newsImageView {
    if (_newsImageView) {
        return _newsImageView;
    }
    _newsImageView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@"label_new"];
    _newsImageView.hidden = YES;
    return _newsImageView;
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

-(UIView *)goodInfolineView{
    if (_goodInfolineView) {
        return _goodInfolineView;
    }
    _goodInfolineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-18, 1) Color:RS_Line_Color];
    _goodInfolineView.hidden = YES;
    
    return _goodInfolineView;
}

-(void)setModel:(GoodModel *)model {
    CGFloat cellHeight = 0;

    self.goodmodel = model;
    
    //商品名称
    self.nameLabel.text = model.name;
    CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (model.isnew) { //是否是新品
        self.newsImageView.hidden = NO;
        self.newsImageView.frame = CGRectMake(MARGIN_LEFT, 10, 14, 14);
        self.nameLabel.frame = CGRectMake(MARGIN_LEFT + 14 + 4, 10, nameSize.width,nameSize.height);
        self.nameLabel.centerY = self.newsImageView.centerY;
    }else {
        self.newsImageView.hidden = YES;
        self.nameLabel.frame = CGRectMake(MARGIN_LEFT, 10, nameSize.width, nameSize.height);
    }
    
    //商品销售量
    self.saledLabel.text = model.subText;
    CGSize saledSize = [self.saledLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.saledLabel.frame = CGRectMake(MARGIN_LEFT, self.nameLabel.bottom + 6, SCREEN_WIDTH-2*self.nameLabel.left, saledSize.height);

    // 商品价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.saleprice];
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    _priceLabel.frame = CGRectMake(MARGIN_LEFT, self.saledLabel.bottom+10, priceSize.width, priceSize.height);
    
    //人气旺
    if (model.ishot) {
        self.hotImageView.hidden = NO;
        self.hotImageView.frame = CGRectMake(self.priceLabel.right + 10, self.priceLabel.top, 38, 14);
        self.hotImageView.centerY = self.priceLabel.centerY;
    }else{
        self.hotImageView.hidden = YES;
    }
    
    //加入购物车按钮
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
    
    
    //优惠信息
    NSArray *promotions = model.promotions;
    if (promotions.count > 0) {
        _goodInfolineView.hidden = NO;
        _goodInfolineView.x = MARGIN_LEFT;
        _goodInfolineView.y = self.priceLabel.bottom + 14;
    }else {
        _goodInfolineView.hidden = YES;
    }
    CGFloat h = self.priceLabel.bottom;
    h += 25;
    
    if (promotions.count>maxCount) {
        maxCount = promotions.count;
    }
    for (int i=0; i<maxCount; i++) {
        [[self.contentView viewWithTag:(1000+i)] removeFromSuperview];
        [[self.contentView viewWithTag:(10000+i)] removeFromSuperview];
    }
    for (int i=0;  i<promotions.count; i++) {
        GoodListpromotion *promotion = promotions[i];
        NSString *imageName = [promotion getImageNameByType];
        UIImageView *actionImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        actionImageView.tag = 1000+i;
        actionImageView.frame = CGRectMake(MARGIN_LEFT, h+4, 15, 15);
        actionImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:actionImageView];
        
        UILabel *label = [RSLabel labellWithFrame:CGRectMake(actionImageView.right+5, actionImageView.top, SCREEN_WIDTH-actionImageView.right-23, 15) Text:promotion.desc Font:Font(9) TextColor:[NSString colorFromHexString:@"818181"]];
        label.tag = 10000+i;
        [self.contentView addSubview:label];
        
        label.centerY = actionImageView.centerY;
        
        h = label.bottom;
    }
    
    cellHeight = h + 15;
    
    
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
