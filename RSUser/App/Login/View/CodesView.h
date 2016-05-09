//
//  CodesView.h
//  RSUser
//
//  Created by 李江 on 16/5/5.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodesView : UIScrollView
-(id) initWithOkBlock:(dispatch_block_t)okBlock;
- (void)show;
- (NSInteger)readCode;
+ (CodesView *)shareCodesView;
@end
