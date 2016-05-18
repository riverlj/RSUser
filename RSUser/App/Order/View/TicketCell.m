//
//  TicketCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-05-04.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "TicketCell.h"
#import "TicketModel.h"




@implementation TicketTextFiled
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderStyle = UITextBorderStyleNone;
    }
    return self;
}
@end

@interface TicketCell()
{
    TicketTextFiled *textField;
}

@end
@implementation TicketCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        }
    return self;
}

- (void)initView
{
    _nameLabel = [RSLabel labelOneLevelWithFrame:CGRectZero Text:@""];
    [self.contentView addSubview:_nameLabel];
    
    _checkedImageView = [RSImageView imageViewWithFrame:CGRectMake(SCREEN_WIDTH-36, 14.5, 100, 20) ImageName:@"ticket_one_no_cheked"];
    [_checkedImageView addTapAction:@selector(checkedImageViewAction) target:self];
    _checkedImageView.contentMode = UIViewContentModeRight;
    [self.contentView addSubview:_checkedImageView];
    
    _lineView = [RSLineView lineViewHorizontal];
    _lineView.x = 18;
    _lineView.width = SCREEN_WIDTH - 36;
    [self.contentView addSubview:_lineView];
    
    _radiosContentView = [[UIView alloc]init];
    _radiosContentView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 49);
    _radiosContentView.backgroundColor = RS_Clear_Clor;
    [self.contentView addSubview:_radiosContentView];
    
    _radios = [[RSRadioGroup alloc]init];

}
-(void) setModel:(TicketModel *)model
{
    [super setModel:model];
    
    _ticketModel = model;
    
    [self.contentView removeAllSubviews];
    [self initView];
    
    _nameLabel.text = model.name;
    CGSize nameLabelSize = [_nameLabel sizeThatFits:CGSizeMake(1000, 1000)];
    _nameLabel.frame = CGRectMake(18, 0, nameLabelSize.width, 49);
    
    _lineView.y = 49;
    
    if (model.ismodelSelected == 1) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _checkedImageView.image = [UIImage imageNamed:@"ticket_one_cheked"];
        
        
        //单层
        if ([model.type isEqualToString: @"radio"] && model.children.count == 0)
        {
            _lineView.hidden = YES;
            model.cellHeight = 49;
        }
        
        //双层，文本框
        if ([model.type isEqualToString: @"text"])
        {
            [self creatTextfield:model];
            
            model.cellHeight = 99;
        }
        
        //双层，单选框
        if ([model.type isEqualToString: @"radio"] && model.children.count > 0)
        {
            [self creatRadios:model.children];
            model.cellHeight = 99;
        }

    }else{
        _checkedImageView.image = [UIImage imageNamed:@"ticket_one_no_cheked"];
        
        model.cellHeight = 49;
    }
    
    self.height = model.cellHeight;
    self.contentView.height = self.height;
    
    _checkedImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH-18, 49);
}

- (void)creatRadios:(NSArray*)models
{
    CGSize lastSize = CGSizeMake(0, 0);
    CGFloat startx = 18;
    for (int i=0; i<models.count; i++) {
        TicketModel *model = models[i];
        RSButton *button = [RSButton buttonWithFrame:CGRectMake(startx+lastSize.width, 0, 100, 49) ImageName:@"ticket_two_no_checked" Text:model.name TextColor:RS_COLOR_C3];
        button.titleLabel.font = RS_FONT_F4;
        [button setImage:[UIImage imageNamed:@"ticket_two_checked"] forState:UIControlStateSelected];
        button.tag = i;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_radios addObj:button];
        CGSize buttonSize = [button sizeThatFits:CGSizeMake(1000, 1000)];
        button.width = buttonSize.width;
        button.x += 20;
        lastSize = buttonSize;
        startx = button.x;
        [button addTarget:self.target action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_radios addObj:button];
        [_radiosContentView addSubview:button];
    }
    
}

- (void)checkedImageViewAction
{
    self.ticketModel.isSelectable = YES;
    if (self.checkItemDelagete && [self.checkItemDelagete respondsToSelector:@selector(checkeTicketModel:)]) {
        [self.checkItemDelagete checkeTicketModel:self.ticketModel.ticketId];
    }
}

- (void)creatTextfield:(TicketModel *)model
{
    textField = [[TicketTextFiled alloc]initWithFrame:CGRectMake(79, 50, SCREEN_WIDTH-158, 49)];
    textField.placeholder = model.placeholder;
    textField.textColor = RS_COLOR_C3;
    textField.font = RS_FONT_F4;
    [self.contentView addSubview:textField];
}

- (void)setTarget:(id)target
{
    _target = target;
    textField.delegate = _target;
    
}
@end
