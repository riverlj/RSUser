//
//  Theme.h
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#ifndef Theme_h
#define Theme_h

#define kUIScreenHeigth  [UIScreen mainScreen].bounds.size.height
#define kUIScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kUITabBarHeight  64

#define Font(x) [UIFont systemFontOfSize:x]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]

#define RGB(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]

/*view的背景颜色*/
#define RS_Background_Color  RGB(239, 237, 233)
/*Theme 的基色*/
#define RS_Theme_Color       RGB(241, 57, 61)
/*tabBar标题的颜色*/
#define RS_TabBar_Title_Color [NSString colorFromHexString:@"7d7d7d"]

#define RS_TabBar_count_Color [NSString colorFromHexString:@"ffffff"]

//----------------上面要删掉-------------------------------------------------------


//TODO
#define RS_00_Color [NSString colorFromHexString:@"000000"]
#define RS_33_Color [NSString colorFromHexString:@"333333"]
#define RS_99_Color [NSString colorFromHexString:@"999999"]
#define RS_66_color [NSString colorFromHexString:@"666666"]
#define RS_e5_color [NSString colorFromHexString:@"e5e5e5"]
#define RS_cc_Color [NSString colorFromHexString:@"cccccc"]

#define RS_fb_color [NSString colorFromHexString:@"fb7911"]
#define RS_cf_color [NSString colorFromHexString:@"cfa972"]
#define RS_38_color [NSString colorFromHexString:@"de3838"]
#define RS_bd_color [NSString colorFromHexString:@"bdbdbd"]
#define RS_f8_color [NSString colorFromHexString:@"f8f8f8"]
#define RS_51_color [NSString colorFromHexString:@"515151"]
#define RS_ff7847_color [NSString colorFromHexString:@"ff7847"]
#define RS_5878ba_color [NSString colorFromHexString:@"5878ba"]

#endif /* Theme_h */
