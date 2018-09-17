//
//  JXGestureDrawRectView.h
//  JXGesturePswView
//
//  Created by 徐沈俊杰 on 2018/9/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DrawRectFinishedBlock)(NSString *gesturePassword);

@interface JXGestureDrawRectView : UIView

@property (nonatomic, strong) DrawRectFinishedBlock drawRectFinishedBlock;

@end
