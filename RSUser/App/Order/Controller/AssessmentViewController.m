//
//  AssessmentViewController.m
//  RSUser
//
//  Created by 李江 on 16/10/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AssessmentViewController.h"
#import "AssessmentModel.h"
#import "RSTitleImageModel.h"
#import "AssessmentCell.h"

@interface AssessmentViewController ()<AssessmentCellClickStar>
{
    UIView *bottomView;
    NSMutableArray *_deliveryAarray;
    NSMutableArray *_productsAarray;
}
@end

@implementation AssessmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加评价";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.height -= 57;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-57-64, SCREEN_WIDTH, 57)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIView *line = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) Color:RS_Line_Color];
    [bottomView addSubview:line];
    
    UIButton *button = [RSButton themeBackGroundButton:CGRectMake(15, line.bottom + 10, SCREEN_WIDTH-30, 38) Text:@"确认评价"];
    button.titleLabel.font = Font(15);
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self submitRate];

    }];
    [bottomView addSubview:button];
    
    [self.view addSubview:bottomView];
    
    self.sections = [NSMutableArray array];
    self.models = [[NSMutableArray alloc] init];
    _deliveryAarray = [[NSMutableArray alloc] init];
    _productsAarray = [[NSMutableArray alloc] init];
    [self.models addObject:_deliveryAarray];
    [self.models addObject:_productsAarray];
    
    RSTitleImageModel *titleImageModel = [[RSTitleImageModel alloc] init];
    titleImageModel.imageName = @"icon_assessment_car";
    titleImageModel.title = @"送餐员评价";
    titleImageModel.linehidden = YES;
    titleImageModel.cellClassName = @"AssessmentHeaderCell";
    [_deliveryAarray addObject:titleImageModel];
    
    titleImageModel = [[RSTitleImageModel alloc] init];
    titleImageModel.imageName = @"icon_assessment_good";
    titleImageModel.title = @"餐品评价";
    titleImageModel.linehidden = NO;
    titleImageModel.cellClassName = @"AssessmentHeaderCell";
    [_productsAarray addObject:titleImageModel];
    
    __weak AssessmentViewController *selfWeak = self;
    [AssessmentModel getAssessmentWithOrderid:self.orderid success:^(AssessmentModel *assessmentModel) {
        //送餐员评价
        AssessmentGoodModel *assessmentGoodModel = assessmentModel.delivery;
        assessmentGoodModel.cellClassName = @"AssessmentCell";
        assessmentGoodModel.assessmenttype = AssessmentDelivery;
        [_deliveryAarray addObject:assessmentGoodModel];
        
        //商品评价
        NSArray *produts = assessmentModel.product;
        for (int i=0; i<produts.count; i++) {
            AssessmentGoodModel *temp = produts[i];
            temp.cellClassName = @"AssessmentCell";
            temp.assessmenttype = AssessmentGood;
            [_productsAarray addObject:temp];
        }
        [selfWeak.tableView reloadData];
        
    } failure:^{ }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:AssessmentCell.class]) {
        AssessmentCell *assessmentCell = (AssessmentCell*)cell;
        assessmentCell.assessmentCellClickStardelegate = self;
        return  assessmentCell;
    }
    return cell;
}

-(void)clickStart:(AssessmentGoodModel *)model {
    [self.tableView reloadData];
}

- (void)submitRate {
    
    AssessmentGoodModel *delivery = _deliveryAarray[1];
    NSArray *array = [delivery getSelectedTag];
    NSDictionary *pdelivery = @{
                               @"score" : delivery.currentkey,
                               @"tag" : array
                               };

    
    NSInteger rateCount = 0;
    NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
    for (int i=1; i<_productsAarray.count; i++) {
        AssessmentGoodModel *goodModel = _productsAarray[i];
        NSArray *fArray = [goodModel getSelectedTag];
        NSDictionary *tagDic = @{
                               @"score" : goodModel.currentkey,
                               @"tag" : fArray
                               };
        NSString *gid = [NSString stringFromNumber:goodModel.goodid];
        [goodDic setValue:tagDic forKey:gid];
        if (![goodModel.currentkey isEqualToString:@"0"]) {
            rateCount ++;
        }
    }
    
    if (rateCount == 0) {
        [[RSToastView shareRSToastView] showToast:@"至少评价一个商品"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.orderid forKey:@"orderid"];
    [params setValue:pdelivery forKey:@"delivery"];
    [params setValue:goodDic forKey:@"product"];
    
    __weak AssessmentViewController *selfWeak = self;
    [[RSToastView shareRSToastView] showHUD:@"提交中..."];
    [AssessmentModel submitRate:params success:^{
        [[RSToastView shareRSToastView] hidHUD];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodListChangedInOrderView" object:nil];
        [selfWeak.navigationController popToRootViewControllerAnimated:YES];
    } failure:^{
    }];
    
}

@end
