//
//  ChannelCell.m
//  RSUser
//
//  Created by 李江 on 16/7/15.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ChannelCell.h"

@implementation ChannelCell
{
    ChannelViewModel *_channelViewModel;
}

-(void)setModel:(ChannelViewModel *)model
{
    _channelViewModel = model;
    CGFloat cellHeight = 0;
    
    NSMutableArray *channelArray = model.channelsArray;
    
    CGFloat width = SCREEN_WIDTH / 4.0;
    CGFloat blankW = (width - 44)/2;
    
    for (int i=0; i<channelArray.count; i++) {
        ChannelModel *channelModel = channelArray[i];
        
        UIImageView *channelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        channelImageView.tag = i;
        [channelImageView addTapAction:@selector(itemClicked:) target:self];
        channelImageView.x = blankW + i%4 * width;
        channelImageView.y = 15 + i/4 * 91;
        if (i/4>=1) {
            channelImageView.y = i/4 * 91;
        }
        [channelImageView sd_setImageWithURL:[NSURL URLWithString:channelModel.path]];
        
        UILabel *channelTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        channelTitleLabel.font = RS_FONT_F4;
        channelTitleLabel.textColor = RS_COLOR_C1;
        channelTitleLabel.text = channelModel.title;
        CGSize fontsize = [channelTitleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        channelTitleLabel.x = channelImageView.centerX - fontsize.width/2;
        channelTitleLabel.y = channelImageView.bottom + 4;
        channelTitleLabel.width = fontsize.width;
        channelTitleLabel.height = fontsize.height;
        
        [self.contentView addSubview:channelImageView];
        [self.contentView addSubview:channelTitleLabel];
        
        cellHeight = 91 * (i/4+1) - 15 * (i/4);
        
    }
    
    model.cellHeight = cellHeight;
    
}

- (void)itemClicked:(UITapGestureRecognizer *)sender
{
    if (sender.view.tag == 0) {
        ChannelModel *channelModel = _channelViewModel.channelsArray[sender.view.tag];
        channelModel.clickChennelBlock(channelModel);
        
    }
    
}

@end
