//
//  AddressesViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-25.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "AddressesViewController.h"
#import "AddressModel.h"
#import "AddressViewController.h"
#import "AddressDetailCell.h"

@interface AddressesViewController()
{
    AddressModel *selectModel;
}
@end

@implementation AddressesViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self beginHttpRequest];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"/address/list";
    self.title = @"我的收货地址";
    self.useHeaderRefresh = YES;
    self.tableView.tableHeaderView = [self headView];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 18.0f);
    [customButton setImage:[UIImage imageNamed:@"icon_trash"] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(didClickDelete) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customButton];
}

-(void) afterHttpSuccess:(NSArray *)data
{
    NSArray *temp = [[MTLJSONAdapter modelsOfClass:[AddressModel class] fromJSONArray:data error:nil] mutableCopy];
    [self.models addObjectsFromArray:temp];
    for(AddressModel *temp in self.models) {
        temp.cellClassName = @"AddressDetailCell";
        if(temp.checked) {
            selectModel = temp;
        }
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSTableViewCell *cell = (RSTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressDetailCell *cell = (AddressDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.editBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(UIView *) headView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *addImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 18, 18)];
    addImg.image = [UIImage imageNamed:@"icon_add"];
    [view addSubview:addImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
    label.textColor = RS_TabBar_Title_Color;
    label.font = RS_MainLable_Font;
    label.left = addImg.right + 10;
    label.centerY = addImg.centerY;
    label.text = @"新增收货地址";
    [view addSubview:label];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    sepLine.bottom = 64;
    sepLine.backgroundColor = RS_Background_Color;
    [view addSubview:sepLine];
    [view addTapAction:@selector(editAddress:) target:self];
    return view;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *model = (AddressModel *)[self getModelByIndexPath:indexPath];
    if(model) {
        if(!model.checked) {
            [model select:^{
                if(selectModel) {
                    selectModel.checked = NO;
                }
                model.checked = YES;
                selectModel = model;
                [self.tableView reloadData];
                if(self.selectReturn) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}

//删除地址
-(void)didClickDelete
{
    if(selectModel) {
        RSAlertView *alert = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"你确定要删除该地址？" leftButtonTitle:@"确定" rightButtonTitle:@"取消"];
        alert.leftBlock = ^(){
            [selectModel delete:^{
                [self.models removeObject:selectModel];
                selectModel = nil;
                [self.tableView reloadData];
            }];
        };
        [alert show];
    }
}


//编辑地址
-(void) editAddress:(id)sender
{
    NSInteger selectId = 0;
    if([sender isKindOfClass:[UIButton class]]) {
        selectId = ((UIButton *)sender).tag;
    }
    AddressModel *model;
    for(AddressModel *temp in self.models) {
        if([temp.addressId integerValue] == selectId) {
            model = temp;
            break;
        }
    }
    AddressViewController *vc = [AddressViewController new];
    vc.model = model;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];

}
@end