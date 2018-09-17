//
//  ExampleVC.m
//  JXGesturePswView
//
//  Created by 徐沈俊杰 on 2018/9/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "ExampleVC.h"
#import "JXGestureLockView.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kStatusHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

@interface ExampleVC ()

@property (nonatomic, strong) JXGestureLockView *gestureLockView;

@end

@implementation ExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.gestureLockView];
}

#pragma mark - Setting And Getting
- (JXGestureLockView *)gestureLockView {
    if (!_gestureLockView) {
        _gestureLockView = [[JXGestureLockView alloc] initWithFrame:CGRectMake(0, kStatusHeight, kScreenWidth, kScreenHeight) GestureType:JXGesturePswTypeCreate andGesturePswBlock:^(BOOL isSuccess) {
            NSLog(@"%d", isSuccess);
        }];
        _gestureLockView.backgroundColor = [UIColor redColor];
    }
    
    return _gestureLockView;
}


@end
