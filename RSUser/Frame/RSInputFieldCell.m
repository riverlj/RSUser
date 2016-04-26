//
//  RSInputFieldCell.m
//  RSUser
//
//  Created by lishipeng on 16/4/26.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSInputFieldCell.h"
#import "RSUIView.h"
@implementation RSInputFieldCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 17, 75, 15)];
        _titleLabel.textColor = RS_MainLable_Text_Color;
        _titleLabel.font = RS_MainLable_Font;
        [self.contentView addSubview:_titleLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.right + 20, 0, SCREEN_WIDTH - _titleLabel.right - 38, 49)];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];
        
        UIView *sepLine = [RSUIView lineWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 1)];
        [self.contentView addSubview:sepLine];
    }
    return self;
}

@end
