//
//  AddressCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-25.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "AddressDetailCell.h"
#import "AddressModel.h"

@implementation AddressDetailCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 5, SCREEN_WIDTH - 47 * 2, 17)];
        _nameLabel.textColor = RS_MainLable_Text_Color;
        _nameLabel.bottom = 67/2 - 5;
        _nameLabel.font = RS_MainLable_Font;
        [self.contentView addSubview:_nameLabel];
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom+10, _nameLabel.width, 15)];
        _addressLabel.font = RS_MainLable_Font;
        _addressLabel.textColor = RS_TabBar_Title_Color;
        [self.contentView addSubview:_addressLabel];
        _checkImg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 15, 15)];
        _checkImg.centerY = 67/2;
        [self.contentView addSubview: _checkImg];
        
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(_nameLabel.right, 0, SCREEN_WIDTH - _nameLabel.right, 67)];
        [_editBtn setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
        [self.contentView addSubview:_editBtn];
        
    }
    return self;
}

-(void) setModel:(AddressModel *)model
{
    [super setModel:model];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.name, model.mobile];
    _addressLabel.text = [NSString stringWithFormat:@"%@", model.address];
    [_addressLabel setGrowthText:model.address];
    if(model.checked) {
        _checkImg.image = [UIImage imageNamed:@"icon_checked"];
    } else {
        _checkImg.image = [UIImage imageNamed:@"icon_unchecked"];
    }
    _editBtn.tag = [model.addressId integerValue];
    self.height = _addressLabel.bottom + 13.5;
    _editBtn.height = self.height;
    _checkImg.centerY = self.height/2;
}
@end