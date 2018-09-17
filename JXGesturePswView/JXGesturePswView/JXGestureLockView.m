//
//  JXGesturePswView.m
//  JXGesturePswView
//
//  Created by 徐沈俊杰 on 2018/9/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXGestureLockView.h"
#import "JXGestureDrawRectView.h"
#import "Masonry.h"

#define kSCALE [UIScreen mainScreen].bounds.size.width/375
#define kTO_SCALE(x) kSCALE*x

#define kGesturesPsw @"kGesturesPsw"

@interface JXGestureLockView()

@property (nonatomic, strong) GesturePswBlock gesturePswBlock;
/**
 当前处理密码类型
 */
@property (nonatomic, assign) JXGesturePswType gesturePswType;
/**
 手势密码绘制视图
 */
@property (nonatomic, strong) JXGestureDrawRectView *gestureDrawRectView;
/**
 当前创建的手势密码
 */
@property (nonatomic, strong) NSString *curentGesturePassword;
/**
 手势密码状态提示
 */
@property (nonatomic, strong) UILabel *statusLabel;
/**
 重置手势密码按钮
 */
@property (nonatomic, strong) UIButton *resetGesturesPswBtn;

@end

@implementation JXGestureLockView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame GestureType:(JXGesturePswType)gesturePswType andGesturePswBlock:(GesturePswBlock)gesturePswBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.gesturePswType = gesturePswType;
        if (gesturePswBlock) {
            self.gesturePswBlock = gesturePswBlock;
        }
        
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

#pragma mark - Events Response
- (void)resetGesturesPswBtnPressed:(UIButton *)sender {
    self.curentGesturePassword = @"";
    self.statusLabel.text = @"请绘制手势密码";
    self.resetGesturesPswBtn.hidden = YES;
}

#pragma mark - Method
- (void)addSubviews {
    [self addSubview:self.gestureDrawRectView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.resetGesturesPswBtn];
}

- (void)setupFrame {
    [self.gestureDrawRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenWidth));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.gestureDrawRectView.mas_top).offset(kTO_SCALE(-20));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kTO_SCALE(50)));
    }];
    
    [self.resetGesturesPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.gestureDrawRectView.mas_bottom).offset(kTO_SCALE(20));
        make.size.mas_equalTo(CGSizeMake(kTO_SCALE(100), kTO_SCALE(50)));
    }];
}

/**
 手势密码完成后按类型操作

 @param type 手势密码类型
 @param gesturePassword 手势密码
 */
- (void)handleWithType:(JXGesturePswType)type password:(NSString *)gesturePassword {
    switch (type) {
        case JXGesturePswTypeCreate://创建手势密码
            [self createGesturesPassword:gesturePassword];
            break;
        case JXGesturePswTypeUnlock://解锁手势密码
            [self validateGesturesPassword:gesturePassword];
            break;
    }
}


/**
 创建手势密码

 @param gesturesPassword 手势密码
 */
- (void)createGesturesPassword:(NSString *)gesturesPassword {
    //第一次进入  绘制手势密码
    if (self.curentGesturePassword.length == 0) {

        //未连接四个点
        if (gesturesPassword.length < 4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入";
            [self shakeAnimationForView:self.statusLabel];

            return;
        }

        //第一次绘制成功，显示重置手势密码按钮
        if (self.resetGesturesPswBtn.hidden == YES) {
            self.resetGesturesPswBtn.hidden = NO;
        }
        
        
        self.curentGesturePassword = gesturesPassword;
//        [self.unlockPreviewView setGesturesPassword:gesturesPassword];
        self.statusLabel.text = @"请再次绘制手势密码";
        return;
    }
    
    //第二次进入  核实手势密码
    if ([self.curentGesturePassword isEqualToString:gesturesPassword]) {//绘制成功
        //保存手势密码
        [self saveGesturesPassword:gesturesPassword];
        if (self.gesturePswBlock) {
            self.gesturePswBlock(YES);
        }
        
    } else {//重新绘制
        self.statusLabel.text = @"与上一次绘制不一致，请重新绘制";
        [self shakeAnimationForView:self.statusLabel];
    }
}


/**
 验证手势密码

 @param gesturesPassword 手势密码
 */
- (void)validateGesturesPassword:(NSString *)gesturesPassword {
    static NSInteger errorCount = 5;
    
    if ([gesturesPassword isEqualToString:[self getGesturesPassword]]) {
        errorCount = 5;
        if (self.gesturePswBlock) {
            self.gesturePswBlock(YES);
        }
//        [self hide];
    }else {
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登陆", nil];
//            [alertView show];
            errorCount = 5;
            
            return;
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        [self shakeAnimationForView:self.statusLabel];
    }
}


/**
 抖动动画
 */
- (void)shakeAnimationForView:(UIView *)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

/**
 删除手势密码
 */
- (void)deleteGesturesPassword{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGesturesPsw];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 保存手势密码
 */
- (void)saveGesturesPassword:(NSString *)gesturesPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:kGesturesPsw];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 获取手势密码
 */
- (NSString *)getGesturesPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kGesturesPsw];
}

#pragma Setting And Getting
- (void)setGesturePswType:(JXGesturePswType)gesturePswType {
    _gesturePswType = gesturePswType;
    
    __weak typeof(self) weakSelf = self;
    [self.gestureDrawRectView setDrawRectFinishedBlock:^(NSString *gesturePassword) {
        [weakSelf handleWithType:weakSelf.gesturePswType password:gesturePassword];
    }];
}

- (JXGestureDrawRectView *)gestureDrawRectView {
    if (!_gestureDrawRectView) {
        _gestureDrawRectView = [[JXGestureDrawRectView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth)];
    }
    
    return _gestureDrawRectView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 50)];
        _statusLabel.backgroundColor = [UIColor blueColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _statusLabel;
}

- (UIButton *)resetGesturesPswBtn {
    if (!_resetGesturesPswBtn) {
        _resetGesturesPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetGesturesPswBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        _resetGesturesPswBtn.hidden = YES;
        [_resetGesturesPswBtn addTarget:self action:@selector(resetGesturesPswBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _resetGesturesPswBtn;
}

- (NSString *)curentGesturePassword {
    if (!_curentGesturePassword) {
        _curentGesturePassword = [[NSString alloc] init];
    }
    
    return _curentGesturePassword;
}
@end
