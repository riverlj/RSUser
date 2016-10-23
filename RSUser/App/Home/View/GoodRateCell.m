//
//  GoodRateCell.m
//  RSUser
//
//  Created by 李江 on 16/10/13.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "GoodRateCell.h"
#import "GoodRateModel.h"
#import "AssessmentCell.h"

@implementation GoodRateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [RSLabel twoLabel];
        self.titleLabel.font = RS_FONT_F3;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.tagsView = [[UIView alloc] init];
        [self.contentView addSubview:self.tagsView];
    }
    return self;
}

-(void)setModel:(GoodRateModel *)model {
    self.titleLabel.text = model.title;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(99999, 999999)];
    self.titleLabel.frame = CGRectMake(16, 15, SCREEN_WIDTH, titleSize.height);
    
    CGFloat tempW = 16;
    CGFloat tempH = 0;
    CGFloat line = 0;
    
    [self.tagsView removeAllSubviews];
    for (int i=0; i<model.tags.count; i++) {
        TagModel *tagModel = model.tags[i];
        UIButton *btn = [self assessTag:[NSString stringWithFormat:@"%@(%@)", tagModel.tagcontent, tagModel.num] favorable:tagModel.tagfavorable];
        [self.tagsView addSubview:btn];
        btn.x = tempW;
        
        if (tempW + btn.width > SCREEN_WIDTH - 16) {
            tempW = 16;
            tempH += 24 + 15;
            line ++;
        }
        btn.x = tempW;
        btn.y = tempH;
        tempW += 8 + btn.width;
        self.tagsView.height = btn.bottom;
    }
    
    
    
    self.tagsView.x = 0;
    self.tagsView.y = self.titleLabel.bottom + 15;
    self.tagsView.width = SCREEN_WIDTH;
    
    if (model.tags.count == 0) {
        model.cellHeight = 0;
        [self.notagLabel removeFromSuperview];
        self.notagLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.titleLabel.bottom + 10, SCREEN_WIDTH, 20)];
        self.notagLabel.text = @"暂无评价~";
        self.notagLabel.font = RS_FONT_F4;
        self.notagLabel.textColor = RS_COLOR_C1;
        [self.contentView addSubview:self.notagLabel];
    }
    
    model.cellHeight = self.tagsView.bottom + 20;
}

- (UIButton *)assessTag:(NSString *)text favorable:(Boolean)favorable {
    CGSize textSize = [text sizeWithFont:RS_FONT_11 byWidth:99999];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 0, 24);
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
    
    button.width = textSize.width + 20;
    
    return button;
}
@end
