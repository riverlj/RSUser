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
        _logoimgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        _logoimgView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:_logoimgView];

        //品牌名
        _brandNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_logoimgView.right + 18, 20, SCREEN_WIDTH-20-128, 40)];
        _brandNameLabel.textAlignment = NSTextAlignmentLeft;
        _brandNameLabel.textColor = RS_COLOR_C1;
        _brandNameLabel.font = RS_FONT_F1;
        [_headerView addSubview:_brandNameLabel];
        
        NSArray *colors = @[@"fa4a5e",@"00b7ee", @"2eca76"];
        NSArray *texts = @[@"品牌", @"品质" , @"超值"];
        for (int i=0; i<3; i++) {
            
            UIButton *button = [RSButton themeBorderButton:CGRectMake(_brandNameLabel.left + 58 * i, _brandNameLabel.bottom + 8, 46, 15) Text:texts[i]];
            UIColor *color = [NSString colorFromHexString:[NSString stringWithFormat:@"%@",colors[i]]];
            button.layer.borderColor = color.CGColor;
            [button setTitleColor:color forState:UIControlStateNormal];
            button.titleLabel.font = Font(10);
            [_headerView addSubview:button];
        }
    
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
    
    CGFloat cellheight = 110;
    for (int i=0; i<_datasourceArray.count; i++) {
        GoodListModel *goodlistmodel = _datasourceArray[i];
        GoodListCell *cell = [[GoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setModel:goodlistmodel];
        cellheight += goodlistmodel.cellHeight;
        
    }

//    model.cellHeight = 110 + 118*(int)_datasourceArray.count;
    if (model.hasmore) {
         cellheight += 52;
        _brandtableView.tableFooterView = self.footerView;
    }else{
        GoodListModel *model = [_datasourceArray lastObject];
        model.hiddenLine = YES;
    }
    
    model.cellHeight = cellheight;
    _brandtableView.height = cellheight;
    [_brandtableView reloadData];
    
}

-(void)moreBtnClicked{
    _brandListModel.clickMoreBtnBlock(_brandListModel);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodListModel *goodlistmodel = _datasourceArray[indexPath.row];
    GoodListCell *cell = [[GoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setModel:goodlistmodel];
    
    return goodlistmodel.cellHeight;
    
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
//    if (indexPath.row != _datasourceArray.count-1 || _brandListModel.hasmore) {
//        RSLineView *lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(10, 92, SCREEN_WIDTH-36, 1) Color:RS_Line_Color];
//        [cell addSubview:lineView];
//    }
    GoodListModel *goodlistmode = _datasourceArray[indexPath.row];
    [cell setModel:goodlistmode];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RSModel *model = _datasourceArray[indexPath.row];
    
    if ([model isKindOfClass:[GoodListModel class]]) {
        GoodListModel *goodListModel = (GoodListModel*)model;
        NSString *path = [NSString stringWithFormat:@"RSUser://goodinfo?communityid=%@&productid=%ld",COMMUNTITYID, goodListModel.comproductid];
        UIViewController *vc = [RSRoute getViewControllerByPath:path];
        [[AppConfig getAPPDelegate].crrentNavCtl pushViewController:vc animated:YES];
    }
}

@end
