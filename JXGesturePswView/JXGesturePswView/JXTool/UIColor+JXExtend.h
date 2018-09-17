//
//  UIColor+JXExtend.h
//  JXBaseProject
//
//  Created by 徐沈俊杰 on 2018/9/10.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JXExtend)

/**
 颜色
 */
+ (UIColor *)getColor:(NSString *)hexColor;

/**
 颜色 含透明度
 */
+ (UIColor *)getColor:(NSString *)hexColor andAlpha:(CGFloat)alpha;

@end
