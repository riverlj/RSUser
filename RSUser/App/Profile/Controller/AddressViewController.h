//
//  AddressViewController.h
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewController.h"
#import "AddressModel.h"

@interface AddressViewController : RSTableViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>
@property(nonatomic, strong) AddressModel *model;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIButton *doneToolbar;
@property(nonatomic, strong) NSMutableArray *buildings;
@end
