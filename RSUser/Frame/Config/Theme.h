//
//  Theme.h
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#ifndef Theme_h
#define Theme_h

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define TABBARHEIGHT  64

#define Font(x) [UIFont systemFontOfSize:x]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]

#define RGB(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
/**
 *
 * Theme 基色
 */
#define RS_Theme_Color  [NSString colorFromHexString:@"f9443e"]
/*view的背景颜色*/
#define RS_Background_Color [NSString colorFromHexString:@"f8f8f8"]
/*导航按钮的默认状态*/
#define RS_TabBar_Title_Color [NSString colorFromHexString:@"7d7d7d"]
/*按钮上的文字*/
#define RS_TabBar_count_Color [NSString colorFromHexString:@"ffffff"]
/*用于分割线，标签描边*/
#define RS_Line_Color  [NSString colorFromHexString:@"e5e5e5"]
/*主要文字颜色*/
#define RS_Main_Text_Color  [NSString colorFromHexString:@"000000"]
/*二级重要文字颜色*/
#define RS_SubMain_Text_Color  [NSString colorFromHexString:@"515151"]
/*次要文字*/
#define RS_Sub_Text_Color  [NSString colorFromHexString:@"cccccc"]
/*白色*/
#define RS_White_Color RGB(255, 255, 255)

/**餐品名称*/
#define RS_MainLable_Text_Color  [NSString colorFromHexString:@"222222"]
/**餐品数量*/
#define RS_NumbLabel_Text_Color  [NSString colorFromHexString:@"666666"]

#define RS_Button_Bg_Color [NSString colorFromHexString:@"ffa628"]

#define RS_Clear_Clor [UIColor clearColor]


/*主要字体*/
#define RS_Main_FontSize BoldFont(24)
#define RS_Button_Font Font(16)
#define RS_SubButton_Font Font(12)

#define RS_MainLable_Font Font(15)
#define RS_PriceLable_Font Font(12)
#define RS_SubLable_Font Font(12)
#define RS_CountLable_Font Font(17)
#define RS_CostPriceLable_Font Font(9)

#define RS_Price_FontSize BoldFont(20)


/**
 *  颜色
 */
#define RS_COLOR_C1 [NSString colorFromHexString:@"222222"]
#define RS_COLOR_C2 [NSString colorFromHexString:@"515151"]
#define RS_COLOR_C3 [NSString colorFromHexString:@"7d7d7d"]
#define RS_COLOR_C4 [NSString colorFromHexString:@"cccccc"]
#define RS_COLOR_C5 [NSString colorFromHexString:@"e5e5e5"]
#define RS_COLOR_C6 [NSString colorFromHexString:@"f8f8f8"]
#define RS_COLOR_C7 [NSString colorFromHexString:@"ffffff"]
#define RS_COLOR_C8 [NSString colorFromHexString:@"ffa53a"]

/**
 *   字体
 */
#define RS_FONT_F1 Font(18)
#define RS_FONT_F2 Font(15)
#define RS_FONT_F3 Font(14)
#define RS_FONT_F4 Font(12)
#define RS_FONT_F5 Font(10)


#endif /* Theme_h */
