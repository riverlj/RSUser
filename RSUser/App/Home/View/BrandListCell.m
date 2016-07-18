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

@property (nonatomic, strong)UIImageView *logoimgView;
@property (nonatomic, strong)UILabel *brandNameLabel;

@property (nonatomic, strong)UITableView *brandtableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)NSMutableArray *datasourceArray;




@end

@implementation BrandListCell 

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _brandtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _brandtableView.dataSource = self;
        _brandtableView.delegate = self;
        _brandtableView.tableHeaderView = self.headerView;
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

-(void)setModel:(BrandListModel *)model
{
    [_logoimgView sd_setImageWithURL:[NSURL URLWithString:model.logoimg]];
    _brandNameLabel.text = model.name;
    _datasourceArray = [model.products mutableCopy];
    if (_datasourceArray.count > 3) {
        model.cellHeight = 110 + 93*3 + 52;
    }else{
        model.cellHeight = 110 + 93 * _datasourceArray.count;
    }
    _brandtableView.height = model.cellHeight;
    [_brandtableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasourceArray.count > 3 ? 3 : _datasourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandGoodlistCell"];
    if (!cell) {
        cell = [[GoodListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brandGoodlistCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_datasourceArray[indexPath.row]];
    return cell;
}
@end
