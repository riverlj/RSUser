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

#define RS_Theme_Color  [NSString colorFromHexString:@"f9443e"]
#define RS_Background_Color [NSString colorFromHexString:@"eeeeee"]
#define RS_Line_Color  RGBA(238,238,238,1)
#define RS_Clear_Clor [UIColor clearColor]
#define RS_COLOR_WHITE RGB(255, 255, 255)
#define RS_COLOR_NUMLABEL  [NSString colorFromHexString:@"666666"]

/**
 *   字体
 */
#define RS_FONT_F1 Font(18)
#define RS_FONT_F2 Font(15)
#define RS_FONT_F3 Font(14)
#define RS_FONT_F4 Font(12)
#define RS_FONT_F5 Font(10)

#define RS_BOLDFONT_F3 BoldFont(14)



//字体适配

#define RS_SIZE_SCALE [AppConfig fontSizeScale]

#define RS_FONT_10 Font(10*(RS_SIZE_SCALE))
#define RS_FONT_11 Font(11*(RS_SIZE_SCALE))
#define RS_FONT_12 Font(12*(RS_SIZE_SCALE))
#define RS_FONT_13 Font(13*(RS_SIZE_SCALE))
#define RS_FONT_14 Font(14*(RS_SIZE_SCALE))
#define RS_FONT_15 Font(15*(RS_SIZE_SCALE))
#define RS_FONT_16 Font(16*(RS_SIZE_SCALE))
#define RS_FONT_17 Font(17*(RS_SIZE_SCALE))
#define RS_FONT_18 Font(18*(RS_SIZE_SCALE))
#define RS_FONT_19 Font(19*(RS_SIZE_SCALE))
#define RS_FONT_20 Font(20*(RS_SIZE_SCALE))
#define RS_FONT_21 Font(21*(RS_SIZE_SCALE))

#define RS_BOLDFONT_16 BoldFont(16*(RS_SIZE_SCALE))
#define RS_BOLDFONT_18 BoldFont(18*(RS_SIZE_SCALE))
#define RS_BOLDFONT_21 BoldFont(21*(RS_SIZE_SCALE))


#endif /* Theme_h */
