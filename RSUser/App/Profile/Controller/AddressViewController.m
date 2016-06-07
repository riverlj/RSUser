//
//  AddressViewController.m
//  RSUser
//
//  Created by lishipeng on 16/4/25.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AddressViewController.h"
#import "RSInputFieldCell.h"
#import "LocationModel.h"
#import "ChooseSchoolViewController.h"
#import "BuildingModel.h"
#import <pop/POP.h>

@implementation AddressViewController
{
    NSMutableDictionary *cellList;
}
-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑收货地址";
    if([self.model isNewRecord]) {
        self.title = @"新增收货地址";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    cellList = [NSMutableDictionary dictionary];
    _buildings = [NSMutableArray array];
    
    RSInputFieldCell *cell = [[RSInputFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RSInputField"];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    cell.titleLabel.text = @"学校";
    cell.textField.placeholder = @"你的学校名称";
    cell.textField.userInteractionEnabled = NO;
    [cellList setObject:cell forKey:@"community"];
    [self.view addSubview:cell];
    
    cell = [[RSInputFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RSInputField"];
    cell.frame = CGRectMake(0, 49, SCREEN_WIDTH, 49);
    cell.titleLabel.text = @"楼栋";
    cell.textField.placeholder = @"请选择楼栋";
    cell.userInteractionEnabled = NO;
    cell.textField.inputView = self.pickerView;
    cell.textField.inputAccessoryView = self.doneToolbar;
    cell.textField.text = self.model.buildingname;
    cell.textField.clearButtonMode = UITextFieldViewModeNever;
    [cellList setObject:cell forKey:@"building"];
    [self.view addSubview:cell];
    
    cell = [[RSInputFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RSInputField"];
    cell.frame = CGRectMake(0, 49*2, SCREEN_WIDTH, 49);
    cell.titleLabel.text = @"寝室";
    cell.textField.placeholder = @"你的寝室号";
    [cellList setObject:cell forKey:@"addition"];
    cell.textField.returnKeyType = UIReturnKeyNext;
    cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cell.textField.delegate = self;
    cell.textField.text = self.model.addition;
    [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
        self.model.addition = text;
    }];
    [self.view addSubview:cell];
    
    cell = [[RSInputFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RSInputField"];
    cell.frame = CGRectMake(0, 49*3, SCREEN_WIDTH, 49);
    cell.titleLabel.text = @"收货人姓名";
    cell.textField.placeholder = @"收货人姓名";
    cell.textField.delegate = self;
    cell.textField.text = self.model.name;
    [cellList setObject:cell forKey:@"name"];
    cell.textField.returnKeyType = UIReturnKeyNext;
    [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
        self.model.name = text;
    }];
    [self.view addSubview:cell];
    
    cell = [[RSInputFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RSInputField"];
    cell.frame = CGRectMake(0, 49*4, SCREEN_WIDTH, 49);
    cell.titleLabel.text = @"联系电话";
    cell.textField.placeholder = @"收货人联系电话";
    cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    cell.textField.delegate = self;
    cell.textField.text = self.model.mobile;
    [cellList setObject:cell forKey:@"mobile"];
    [cell.textField.rac_textSignal subscribeNext:^(NSString *text) {
        self.model.mobile = text;
    }];
    cell.textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:cell];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(18, cell.bottom+20, SCREEN_WIDTH - 36, 42)];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.backgroundColor = RS_Theme_Color;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addTapAction:@selector(endedit) target:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWillChangeFrame
{
    [self endedit];
}


-(UIPickerView *) pickerView
{
    if(_pickerView) {
        return _pickerView;
    }
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 216, 0, SCREEN_WIDTH, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return _pickerView;
}

-(UIButton *) doneToolbar
{
    if(_doneToolbar) {
        return _doneToolbar;
    }
    _doneToolbar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [_doneToolbar setTitle:@"确定" forState:UIControlStateNormal];
    [_doneToolbar setBackgroundColor:RS_Theme_Color];
    [_doneToolbar addTarget:self action:@selector(selectBuilding) forControlEvents:UIControlEventTouchUpInside];
    return _doneToolbar;
}


-(AddressModel *)model
{
    if(_model) {
        return _model;
    }
    _model = [AddressModel new];
    return _model;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.model.addressId) {
        LocationModel *community = [LocationModel shareLocationModel];
        if(!community) {
            [self.navigationController pushViewController:[ChooseSchoolViewController new] animated:YES];
        }
        self.model.communityid = [community.communtityId integerValue];
        self.model.communityname = community.communtityName;
    }
    RSInputFieldCell *cell = [cellList objectForKey:@"community"];
    cell.textField.text = self.model.communityname;
    //获取楼栋list
    [self.model getBuildings:^(NSArray *data) {
        RSInputFieldCell *cell =  [cellList valueForKey:@"building"];
        cell.userInteractionEnabled = YES;
        self.buildings = [data mutableCopy];
    } failure:^{
    }];
    

    
}

-(void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.buildings count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    BuildingModel *temp = [self.buildings objectAtIndex:row];
    return temp.name;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self.buildings count] > 0) {
        BuildingModel *temp = [self.buildings objectAtIndex:row];
        self.model.buildingid = temp.buildingid;
        self.model.buildingname = temp.name;
        RSInputFieldCell *cell = [self getCellByKey:@"building"];
        cell.textField.text = temp.name;
    }
}

-(void)selectBuilding
{
    RSInputFieldCell *cell = [self getCellByKey:@"building"];
    [cell.textField endEditing:YES];
    cell = [self getCellByKey:@"addition"];
    [cell.textField becomeFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    for(NSString *key in cellList) {
        RSInputFieldCell *cell = [self getCellByKey:key];
        
        if(cell.textField == textField) {
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.centerY)];;
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.height/2 - cell.top + 64)];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = 0.3;
            [self.view pop_addAnimation:animation forKey:@"go"];
            break;
        }
    }
}

-(RSInputFieldCell *) getCellByKey:(NSString *)key
{
    RSInputFieldCell *cell = (RSInputFieldCell *)[cellList objectForKey:key];
    return cell;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if([self getCellByKey:@"addition"].textField == textField) {
        [[self getCellByKey:@"name"].textField becomeFirstResponder];
    }
    if([self getCellByKey:@"name"].textField == textField) {
        [[self getCellByKey:@"mobile"].textField becomeFirstResponder];
    }
    if([self getCellByKey:@"mobile"].textField == textField) {
        [self submit];
    }
    return YES;
}


//结束编辑
-(void) endedit
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.centerY)];;
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.centerX, self.view.height/2+64)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 0.2;
    [self.view pop_addAnimation:animation forKey:@"go"];
    for(NSString *key in cellList) {
        RSInputFieldCell *cell = (RSInputFieldCell *)[cellList objectForKey:key];
        [cell.textField resignFirstResponder];
    }
}

//提交到后台
-(void) submit
{
    [self endedit];
    BOOL result = [self.model checkValid:^{
    } failure:^(NSString *key, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
    if(result) {
        [self.model edit:^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endedit];
}
@end
