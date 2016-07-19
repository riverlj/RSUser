//
//  BrandListCell.m
//  RSUser
//
//  Created by 李江 on 16/7/18.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BrandListCell.h"
#import "GoodListCell.h"
#import "BrandListModel.h"
#import "GoodListModel.h"

@interface BrandListCell()
{
    BrandListModel *_brandListModel;
}
@property (nonatomic, strong)UIImageView *logoimgView;
@property (nonatomic, strong)UILabel *brandNameLabel;

@property (nonatomic, strong)UITableView *brandtableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)UIView *lineView;


@property (nonatomic, strong)NSMutableArray *datasourceArray;




@end

@implementation BrandListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor greenColor];
        
        _brandtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _brandtableView.dataSource = self;
        _brandtableView.delegate = self;
        _brandtableView.tableHeaderView = self.headerView;
        _brandtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _brandtableView.scrollEnabled = NO;
        [self.contentView addSubview:_brandtableView];
    }
    return self;
}

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        
        //logo
        _logoimgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 10, 100, 100)];
        _logoimgView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:_logoimgView];

        //品牌名
        _brandNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, SCREEN_WIDTH-20-130, 125)];
        _brandNameLabel.textAlignment = NSTextAlignmentCenter;
        _brandNameLabel.textColor = RS_COLOR_C1;
        _brandNameLabel.font = RS_FONT_F1;
        [_headerView addSubview:_brandNameLabel];
    
    }
    return _headerView;
}

-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake((SCREEN_WIDTH-95)/2, 15, 95, 27);
        [moreButton setBackgroundImage:[UIImage imageNamed:@"brand_moreBtn"] forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:moreButton];
    }
    return _footerView;
}

-(void)setModel:(BrandListModel *)model
{
    _brandListModel = model;
    [_logoimgView sd_setImageWithURL:[NSURL URLWithString:model.logoimg]];
    _brandNameLabel.text = model.name;
    _datasourceArray = [model.products mutableCopy];

    model.cellHeight = 110 + 93*(int)_datasourceArray.count;
    if (model.hasmore) {
         model.cellHeight += 52;
        _brandtableView.tableFooterView = self.footerView;
    }
    _brandtableView.height = model.cellHeight;
    [_brandtableView reloadData];
    
}

-(void)moreBtnClicked{
    _brandListModel.clickMoreBtnBlock(_brandListModel);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandGoodlistCell"];
    if (!cell) {
        cell = [[GoodListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brandGoodlistCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row != _datasourceArray.count-1 || _brandListModel.hasmore) {
        RSLineView *lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(18, 92, SCREEN_WIDTH-36, 1) Color:RS_Line_Color];
        [cell addSubview:lineView];
    }
    [cell setModel:_datasourceArray[indexPath.row]];
    return cell;
}

@end
