//
//  JXUtilities.h
//  JXBaseProject
//
//  Created by 徐沈俊杰 on 2018/9/10.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXUtilities : NSObject

/**
 是否是有效的字典
 */
+ (BOOL)isValidDictionary:(id)object;
/**
 是否是有效的数组
 */
+ (BOOL)isValidArray:(id)object;
/**
 是否是有效的字符串
 */
+ (BOOL)isValidString:(id)object;
/**
 是否是有效的内存二进制数据
 */
+ (BOOL)isValidData:(id)object;

@end
