//
//  ChooseSchoolViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/14.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ChooseSchoolViewController.h"
#import "RSSearchView.h"
#import "RSFileStorage.h"
#import "CartModel.h"

@interface ChooseSchoolViewController()<UISearchBarDelegate>
{
    UISearchBar *mSearchBar;
    NSMutableArray *universityArr;
    UIImageView *imageView;
}
@property (nonatomic, strong)RSLabel *clearHistoryLabel;

@end

@implementation ChooseSchoolViewController
#pragma mark 生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地址选择";
    self.models = [NSMutableArray array];
    
    RSSearchView *searchView = [[RSSearchView alloc]init];
    [self.view addSubview:searchView];
    self.tableView.frame = CGRectMake(0, searchView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT- searchView.bottom);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    imageView = [[UIImageView alloc]initWithFrame:self.tableView.frame];
    imageView.y = imageView.y - 56;
    imageView.image = [UIImage imageNamed:@"icon_logo"];
    imageView.contentMode = UIViewContentModeCenter;
    
    @weakify(self)
    [[[[[[searchView.searchTextField rac_textSignal]
       filter:^BOOL(NSString *searchKey) {
           if (searchKey.length == 0)
           {
               NSArray *array = [self getSchoolArray];
               [self.models removeAllObjects];
               self.models = [NSMutableArray arrayWithArray:array];
               [self setLogoImage];
               [self setTableFooterView];
               [self.tableView reloadData];
               return NO;
           }
           else
           {
               self.tableView.tableFooterView = [UIView new];
               [self setLogoImage];
               return YES;
           }
    }]
      throttle:0.05
    ]
      flattenMap:^id(NSString *searchKey) {
        @strongify(self)
          return [self searchWithKeyword:searchKey];
    }]
     deliverOnMainThread
    ]
     subscribeNext:^(NSArray *value) {
         [self.models removeAllObjects];
         [self.models addObjectsFromArray:value];
         [self.tableView reloadData];
    }];
    
    [[[searchView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(id value) {
        return searchView.searchTextField.text.length == 0 ? NO : YES;
    }]subscribeNext:^(id x) {
        @strongify(self)
        searchView.searchTextField.text = @"";
        [searchView.searchTextField endEditing:YES];
        [self.models removeAllObjects];
        NSArray *array = [self getSchoolArray];
        self.models = [NSMutableArray arrayWithArray:array];
        [self setLogoImage];
        [self setTableFooterView];
        [self.tableView reloadData];
    }];
    
}

#pragma mark 界面控件
- (void)setTableFooterView
{
    if (self.models.count == 0)
    {
        self.tableView.tableFooterView = [UIView new];
        return;
    }
    self.tableView.tableFooterView = self.clearHistoryLabel;
    
}

-(RSLabel *)clearHistoryLabel
{
    if (_clearHistoryLabel)
    {
        return _clearHistoryLabel;
    }
    _clearHistoryLabel = [RSLabel lableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46) bgColor:[UIColor whiteColor] textColor:RS_Theme_Color];
    _clearHistoryLabel.textAlignment = NSTextAlignmentLeft;
    _clearHistoryLabel.text = @"     清空历史记录";
    _clearHistoryLabel.font = RS_FONT_F2;
    [_clearHistoryLabel addTapAction:@selector(clearSchools) target:self];
    return _clearHistoryLabel;
}

- (void)setLogoImage
{
    if (self.models.count == 0)
    {
        [self.view addSubview:imageView];
        [self.view sendSubviewToBack:imageView];
    }
    else
    {
        [imageView removeFromSuperview];
    }
}

#pragma mark 搜索
- (RACSignal *)searchWithKeyword:(NSString *)searchKey
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [LocationModel getSearchResultWithKey:searchKey Result:^(NSArray *successArray) {
            [subscriber sendNext:successArray];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

#pragma tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel *model = self.models[indexPath.row];
    [LOCATIONMODEL setLocationModelWhithModel:model];
    [self saveSchoolArray];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark 数据管理
- (NSArray *)getSchoolArray
{
    NSArray *array = [LOCATIONMODEL getCommnitysFromDocument];
    NSMutableArray *mArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        LocationModel *model = [[LocationModel alloc]init];
        model.communtityId = [dic valueForKey:@"communtityId"];
        model.communtityName = [dic valueForKey:@"communtityName"];
        model.cellClassName = @"SchoolAddressCell";
        model.cellHeight = 44;
        [mArray addObject:model];
    }];
    
    return [mArray copy];
}

- (void)saveSchoolArray
{
    [LOCATIONMODEL save];
    
    NSMutableArray *array = [[Cart sharedCart] getCartGoods];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCountLabel" object:nil userInfo:nil];
    __block NSInteger num = 0;
    [array enumerateObjectsUsingBlock:^(CartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        num += obj.num;
    }];
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd", num];
}

- (void)clearSchools
{
    self.tableView.tableFooterView = [UIView new];
    [self.models removeAllObjects];
    [self setLogoImage];
    [self.tableView reloadData];
    [LOCATIONMODEL clear];
}

#pragma mark 返回
-(void)backUp
{
    NSLog(@"%@",COMMUNTITYID);
    if (!COMMUNTITYID)
    {
        [[RSToastView shareRSToastView] showToast:@"请选择所在学校"];
        return;
    }
    [LOCATIONMODEL save];
    [super backUp];
}

@end
