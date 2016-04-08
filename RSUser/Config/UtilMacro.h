//
//  UtilMacro.h
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#ifndef UtilMacro_h
#define UtilMacro_h

#ifdef DEBUG
#define HHDPRINT(xx, ...)  NSLog(@"打印开始: %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#elif RELEASE
#define HHDPRINT(xx, ...)  NSLog(@"打印开始: %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HHDPRINT(xx, ...)  ((void)0)
#endif

#define MAINWINDOW [UIApplication sharedApplication].keyWindow


#endif /* UtilMacro_h */
