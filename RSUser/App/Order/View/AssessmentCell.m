//
//  AssessmentCell.m
//  RSUser
//
//  Created by 李江 on 16/10/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AssessmentCell.h"

static const CGFloat k_left=15.0;
static const CGFloat k_right=15.0;
//星星的宽
static const CGFloat k_start_width = 36;
//星星的高
static const CGFloat k_start_height = 36;
//两个星星间的间距
static const CGFloat k_starts_margin = 19;
//
static const CGFloat k_margin_top_15 = 15;
static const CGFloat k_margin_top_20 = 15;

static const CGFloat k_tag_heigth = 24;
static const CGFloat k_tags_margin = 9;

@interface AssessmentCell()
{
    AssessmentGoodModel *_assessmentGoodModel;
}

@end

@implementation AssessmentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.goodNameLabel = [RSLabel labellWithFrame:CGRectZero Text:nil Font:RS_FONT_14
                                            TextColor:RS_COLOR_C1];
        self.goodNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.goodNameLabel];
        
        self.startsView = [RSUIView viewWithbgCoclor:[UIColor clearColor]];
        [self.contentView addSubview:self.startsView];
        
        self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectZero Color:RS_Line_Color];
        [self.contentView addSubview:self.lineView];
        
        self.tagsView = [RSUIView viewWithbgCoclor:[UIColor clearColor]];
        [self.contentView addSubview:self.tagsView];
        
        self.celllineView = [RSLineView lineViewHorizontalWithFrame:CGRectZero Color:RS_Line_Color];
        [self.contentView addSubview:self.celllineView];
        
    }
    return self;
}

- (void)setModel:(AssessmentGoodModel *)model
{
    _assessmentGoodModel = model;
    if (model.assessmenttype == AssessmentDelivery) {
        [self.goodNameLabel removeFromSuperview];
    }
    if (model.assessmenttype == AssessmentGood) {
        NSString *goodName = model.goodname;
        CGSize goodNameSize = [goodName sizeWithFont:RS_FONT_14 byWidth:99999];
        self.goodNameLabel.text = goodName;
        self.goodNameLabel.frame = CGRectMake(2*k_left, k_margin_top_15, SCREEN_WIDTH-4*k_left, goodNameSize.height);
        self.goodNameLabel.centerX = SCREEN_WIDTH/2;
    }
    
    XHStarRateView *starRateView = nil;
    
    if (model.assessmenttype == AssessmentDelivery) {
        starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, k_starts_margin*4 + k_start_width * 5, k_start_height) rateType:RateTypeDelivery currentScore:[model.currentkey floatValue]];
        self.startsView.frame = CGRectMake(0, self.goodNameLabel.bottom, SCREEN_WIDTH, k_start_height);
    }
    if (model.assessmenttype == AssessmentGood) {
        starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, k_starts_margin*4 + k_start_width * 5, k_start_height) rateType:RateTypeGood currentScore:[model.currentkey floatValue]];
        self.startsView.frame = CGRectMake(0, self.goodNameLabel.bottom+k_margin_top_15, SCREEN_WIDTH, k_start_height);

    }
    starRateView.centerX = self.startsView.centerX;
    starRateView.isAnimation = NO;
    starRateView.rateStyle = WholeStar;
    starRateView.delegate = self;
    [self.startsView removeAllSubviews];
    [self.startsView addSubview:starRateView];
    
    self.lineView.left = k_left;
    self.lineView.width = SCREEN_WIDTH-k_left;
    self.lineView.y = self.startsView.bottom + k_margin_top_20;
    
    NSArray *tags = [model getCurrentTags];
    
    if (tags.count == 0) {
        [self.lineView removeFromSuperview];
    }
    
    CGFloat tempW = k_left;
    CGFloat tempH = 0;
    CGFloat line = 0;
    [self.tagsView removeAllSubviews];
    for (int i=0; i<tags.count; i++) {
        TagModel *tagModel = tags[i];
        UIButton *btn = [self assessTag:tagModel.tagcontent favorable:tagModel.isSelected];
        btn.tag = [tagModel.tagid integerValue];
        if (tagModel.tagfavorable) {
        }
        [self.tagsView addSubview:btn];
        btn.x = tempW;
        
        if (tempW + btn.width > SCREEN_WIDTH - k_right) {
            tempW = k_left;
            tempH += k_tag_heigth + k_margin_top_15;
            line ++;
        }
        btn.x = tempW;
        btn.y = tempH;
        tempW += k_tags_margin + btn.width;
        
        self.tagsView.height = btn.bottom;
    }
    
    if (tags.count ==0) {
        self.tagsView.height = 0;
    }
    
    self.tagsView.x = 0;
    self.tagsView.y = self.lineView.bottom+ k_margin_top_15;
    self.tagsView.width = SCREEN_WIDTH;
    
    self.celllineView.frame = CGRectMake(0, self.tagsView.bottom + k_margin_top_15, SCREEN_WIDTH, 1);
    model.cellHeight = self.tagsView.bottom + k_margin_top_15 + 1;
    
    
}
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    _assessmentGoodModel.currentkey = [NSString stringWithFormat:@"%ld", (int)currentScore];
    
    if (self.assessmentCellClickStardelegate && [self.assessmentCellClickStardelegate respondsToSelector:@selector(clickStart:)]) {
        [self.assessmentCellClickStardelegate clickStart:_assessmentGoodModel];
    }
}

-(void)starRateView:(XHStarRateView *)starRateView beforeScore:(CGFloat)currentScore {
    [_assessmentGoodModel setNOFavorable];
}

- (UIButton *)assessTag:(NSString *)text favorable:(Boolean)favorable {
    CGSize textSize = [text sizeWithFont:RS_FONT_11 byWidth:99999];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 0, k_tag_heigth);
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    if (favorable) {
        button.layer.borderColor = [NSString colorFromHexString:@"ffa53a"].CGColor;
        [button setTitleColor:[NSString colorFromHexString:@"ffa53a"] forState:UIControlStateNormal];
        [button setTitleColor:[NSString colorFromHexString:@"ffa53a"] forState:UIControlStateHighlighted];
        button.backgroundColor = [NSString colorFromHexString:@"fef4e7"];
    }else {
        button.layer.borderColor = [NSString colorFromHexString:@"cccccc"].CGColor;
        [button setTitleColor:RS_COLOR_C3 forState:UIControlStateNormal];
        [button setTitleColor:RS_COLOR_C3 forState:UIControlStateHighlighted];
        button.backgroundColor = [NSString colorFromHexString:@"f5f5f5"];
    }
    
    button.titleLabel.font = RS_FONT_11;
    button.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    button.layer.cornerRadius = 12;
    button.layer.masksToBounds = YES;
    
    button.width = textSize.width + 30;
    
    return button;
}

-(void)btnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger tagid = sender.tag;
    [_assessmentGoodModel setSelected:sender.selected withTagid:@(tagid)];
    if (sender.selected) {
        sender.layer.borderColor = [NSString colorFromHexString:@"ffa53a"].CGColor;
        [sender setTitleColor:[NSString colorFromHexString:@"ffa53a"] forState:UIControlStateNormal];
        [sender setTitleColor:[NSString colorFromHexString:@"ffa53a"] forState:UIControlStateHighlighted];
        sender.backgroundColor = [NSString colorFromHexString:@"fef4e7"];
    }else {
        sender.layer.borderColor = [NSString colorFromHexString:@"cccccc"].CGColor;
        [sender setTitleColor:RS_COLOR_C3 forState:UIControlStateNormal];
        [sender setTitleColor:RS_COLOR_C3 forState:UIControlStateHighlighted];
        sender.backgroundColor = [NSString colorFromHexString:@"f5f5f5"];
    }
}

@end

@implementation AssessmentHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setModel:(RSModel *)model {
    [super setModel:model];
    [self setViewFrame:model];
}

- (void)setViewFrame:(RSModel *)model {
    self.iconImageView.frame = CGRectMake(k_left, 24, 15, 15);
    CGSize textSize = [self.titleLabel.text sizeWithFont:RS_FONT_14 byWidth:99999];
    self.titleLabel.font = RS_FONT_14;
    self.titleLabel.textColor = RS_COLOR_C3;
    self.titleLabel.frame = CGRectMake(self.iconImageView.right+6, 24, SCREEN_WIDTH-2*(self.iconImageView.right+6), textSize.height);
    
    self.lineView.y = self.iconImageView.bottom + 21;
    model.cellHeight = self.iconImageView.bottom + 22;
}

@end
