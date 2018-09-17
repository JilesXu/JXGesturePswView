//
//  JXGesturePswView.h
//  JXGesturePswView
//
//  Created by 徐沈俊杰 on 2018/9/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, JXGesturePswType) {
    JXGesturePswTypeCreate = 1 << 0,     //创建手势密码
    JXGesturePswTypeUnlock = 1 << 1,     //解锁手势密码
};

typedef void(^GesturePswBlock)(BOOL isSuccess);

@interface JXGestureLockView : UIView

- (instancetype)initWithFrame:(CGRect)frame GestureType:(JXGesturePswType)gesturePswType andGesturePswBlock:(GesturePswBlock)gesturePswBlock;

@end
