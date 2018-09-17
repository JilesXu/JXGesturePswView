//
//  JXUtilities.m
//  JXBaseProject
//
//  Created by 徐沈俊杰 on 2018/9/10.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXUtilities.h"

@implementation JXUtilities

+ (BOOL)isValidDictionary:(id)object {
    return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
}

+ (BOOL)isValidArray:(id)object {
    return object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count;
}

+ (BOOL)isValidString:(id)object {
    return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

+ (BOOL)isValidData:(id)object {
    return object && [object isKindOfClass:[NSData class]] && ((NSData *)object).length;
}

@end
