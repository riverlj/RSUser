//
//  TicketViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-05-04.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "TicketViewController.h"
#import "TicketModel.h"
#import "TicketCell.h"

@interface TicketViewController()<UITextFieldDelegate>
{
    NSString *reasontext;
}
@end

@implementation TicketViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
    self.url = @"/ticket/reason";
    
    self.sections = [NSMutableArray new];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self beginHttpRequest];
    self.tableView.height = self.tableView.height - 57;
    
    [self initBottomView];
    }


-(void) afterHttpSuccess:(NSArray *)data
{
    NSArray *temp = [[MTLJSONAdapter modelsOfClass:[TicketModel class] fromJSONArray:data error:nil] mutableCopy];
    for (int i=0; i<temp.count; i++)
    {
        TicketModel *ticketModel = temp[i];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:ticketModel];
        [self.models addObject:array];
    }
    
}

- (void)initBottomView
{
    UIButton *button = [RSButton themeBackGroundButton:CGRectMake(18, SCREEN_HEIGHT-64-57, SCREEN_WIDTH-36, 42) Text:@"提交"];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       // 提交
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        NSInteger reason = [self getSelectedTicketId];
        if (reason == -1) {
            [[RSToastView shareRSToastView] showToast:@"请选择反馈内容"];
            return ;
        }
        
        [params setValue:@(reason) forKey:@"reason"];
        [params setValue:reasontext forKey:@"reasontext"];
        [params setValue:self.deliveryid forKey:@"deliveryid"];
        
        [TicketModel createticket:params success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    [self.view addSubview:button];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketModel *model = self.models[indexPath.section][indexPath.row];
    
    if (model.isSelected == 1) {
        [self hideKeyboard];
        return;
    }
    
    [self clearTicketModelSelected];
    model.isSelected = 1;
    reasontext = @"";
    [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketCell *cell = (TicketCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.target = self;
    return cell;
}

- (void)clearTicketModelSelected
{
    for (int i=0; i<self.models.count; i++) {
        NSArray *array = self.models[i];
        for (int j=0; j<array.count; j++) {
            TicketModel *model = array[j];
            model.isSelected = 0;
        }
    }
}

- (NSInteger)getSelectedTicketId
{
    NSInteger ticketId = -1;
    for (int i=0; i<self.models.count; i++) {
        NSArray *array = self.models[i];
        for (int j=0; j<array.count; j++) {
            TicketModel *model = array[j];
            if (model.isSelected == 1) {
                ticketId = model.ticketId;
            }
        }
    }
    
    return ticketId;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self editing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    reasontext = textField.text;
}

-(void)editing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         self.tableView.contentInset = UIEdgeInsetsMake(-(textField.bottom-20), 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)hideKeyboard
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         self.tableView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
    [self.view endEditing:YES];
}

- (void)btnClicked:(UIButton *)sender
{
    [sender.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    sender.selected = YES;
    reasontext = sender.titleLabel.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
