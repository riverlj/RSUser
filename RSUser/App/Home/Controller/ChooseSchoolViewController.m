//
//  ChooseSchoolViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/14.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ChooseSchoolViewController.h"
#import "RSSearchView.h"
@interface ChooseSchoolViewController()<UISearchBarDelegate>
{
    UISearchBar *mSearchBar;
    NSMutableArray *universityArr;
}
@end

@implementation ChooseSchoolViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地址选择";
    self.models = [NSMutableArray array];
    
    RSSearchView *searchView = [[RSSearchView alloc]init];
    [self.view addSubview:searchView];
    self.tableView.frame = CGRectMake(0, searchView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT- searchView.bottom);
    
    @weakify(self)
    [[[[[[searchView.searchTextField rac_textSignal]
       filter:^BOOL(NSString *searchKey) {
           if (searchKey.length == 0) {
               [self.models removeAllObjects];
               [self.tableView reloadData];
               return NO;
           }else{
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
    
    [[searchView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        searchView.searchTextField.text = @"";
        [searchView.searchTextField endEditing:YES];
        [self.models removeAllObjects];
        [self.tableView reloadData];
    }];
}

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

-(void)backUp
{
    if (!COMMUNTITYID)
    {
        RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"请选择所在学校" leftButtonTitle:@"我知道了" AndLeftBlock:^{
        }];
        [alertView show];
        return;
    }
    [super backUp];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
