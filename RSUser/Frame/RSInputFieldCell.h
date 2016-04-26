//
//  RSInputFieldCell.h
//  RSUser
//
//  Created by lishipeng on 16/4/26.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewCell.h"
#import "RSPlaceHolderTextView.h"

@interface RSInputFieldCell : RSTableViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextField *textField;
@end
