//
//  AssessmentViewController.m
//  RSUser
//
//  Created by 李江 on 16/10/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AssessmentViewController.h"
#import "AssessmentModel.h"

@interface AssessmentViewController ()
{
    UIView *bottomView;
}
@end

@implementation AssessmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加评价";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.models = [[NSMutableArray alloc] init];
    AssessmentModel *asset = [[AssessmentModel alloc]init];
    [self.models addObject:asset];
    [self.models addObject:asset];
    [self.models addObject:asset];
    [self.tableView reloadData];
    
    self.tableView.height -= 57;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-57-64, SCREEN_WIDTH, 57)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIView *line = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) Color:RS_Line_Color];
    [bottomView addSubview:line];
    
    UIButton *button = [RSButton themeBackGroundButton:CGRectMake(15, line.bottom + 10, SCREEN_WIDTH-30, 38) Text:@"确认评价"];
    button.titleLabel.font = Font(15);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[RSToastView shareRSToastView] showToast:@"提交评价"];
    }];
    [bottomView addSubview:button];
    
    [self.view addSubview:bottomView];
    
    
}
@end
