//
//  RSSearchView.m
//  RSUser
//
//  Created by 李江 on 16/4/15.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSSearchView.h"

@implementation RSSearchView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        [self creatSearchTextFiled];
        [self creatSearchIcon];
        [self creatCancelBtn];
    }
    return self;
}

- (void)creatSearchTextFiled
{
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 9, SCREEN_WIDTH-85, 38)];
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.backgroundColor = [NSString colorFromHexString:@"f8f8f8"];
    _searchTextField.layer.borderWidth = 1;
    _searchTextField.layer.borderColor = RS_Line_Color.CGColor;
    _searchTextField.layer.cornerRadius = 6;
    _searchTextField.font = Font(14);
    _searchTextField.placeholder = @"请输入学校名称如：对外经济贸易大学";
    [self addSubview:_searchTextField];
}

- (void)creatSearchIcon
{
    _searchIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchIcon setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    _searchIcon.frame = CGRectMake(30, 13, 45, 12);
    _searchIcon.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    _searchTextField.leftView = _searchIcon;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;

}

- (void)creatCancelBtn
{
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(_searchTextField.right, 9, SCREEN_WIDTH-_searchTextField.right, 38);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[NSString colorFromHexString:@"515151"] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = Font(15);
    
    [self addSubview:_cancelBtn];
}


@end
