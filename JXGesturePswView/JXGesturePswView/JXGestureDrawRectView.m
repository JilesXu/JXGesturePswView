//
//  JXGestureDrawRectView.m
//  JXGesturePswView
//
//  Created by 徐沈俊杰 on 2018/9/17.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXGestureDrawRectView.h"

#define kVerticalLineNum 3//总列数

@interface JXGestureDrawRectView()

@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation JXGestureDrawRectView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupFrame];
        self.backgroundColor = [UIColor greenColor];
    }
    
    return self;
}

#pragma mark - Events Response
- (void)panGestureDraged:(UIPanGestureRecognizer *)sender {
    self.currentPoint = [sender locationInView:self];
    
    //setNeedsDisplay会调用自动调用drawRect方法
    [self setNeedsDisplay];
    
    for (UIButton *button in self.subviews) {
        //判断给定的点是否被一个CGRect包含
        if (CGRectContainsPoint(button.frame, self.currentPoint) && button.selected == NO) {
            button.selected = YES;
            [self.selectedBtns addObject:button];
        }
    }
    
    //立即更新视图
    [self layoutIfNeeded];
    
    //手势结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        //保存输入密码
        __block NSMutableString *gesturePwd = [NSMutableString string];
        [self.selectedBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            [gesturePwd appendFormat:@"%ld",obj.tag - 1000];
            obj.selected = NO;
        }];
        
        [self.selectedBtns removeAllObjects];
        //手势密码绘制完成后回调
        if (self.drawRectFinishedBlock) {
            self.drawRectFinishedBlock(gesturePwd);
        }
    }
    
}

#pragma mark - Method
- (void)setupFrame {
    self.selectedBtns = [[NSMutableArray alloc] init];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDraged:)];
    [self addGestureRecognizer:pan];
    
    //创建9个按钮
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
        btn.tag = 1000+i;
        
        [self addSubview:btn];
    }
}


/**
 layoutIfNeeded后，或视图更新后调用
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat x = 0,y = 0,w = 0,h = 0;
    if (kScreenWidth == 320) {
        w = 50;
        h = 50;
    } else {
        w = 58;
        h = 58;
    }
    
    CGFloat margin = (self.bounds.size.width - kVerticalLineNum * w) / (kVerticalLineNum + 1);//间距
    CGFloat vertical = 0;
    CGFloat horizontal = 0;
    for (int i = 0; i < count; i++) {
        vertical = i % kVerticalLineNum;//计算第几列
        horizontal = i / kVerticalLineNum;//计算第几行
        
        x = margin + (w + margin) * vertical;
        y = margin + (w + margin) * horizontal;
        
        if (kScreenHeight == 480) {
            y = (w + margin) * horizontal;
        } else {
            y = margin + (w + margin) * horizontal;
        }
        
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

/**
 setNeedsDisplay调用之后立即绘制
 */
- (void)drawRect:(CGRect)rect {
    if (self.selectedBtns.count == 0) {
        return;
    }
    
    //把所有选中按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger count = self.selectedBtns.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.selectedBtns[i];
        
        if (i == 0) {//第一个点
            [path moveToPoint:btn.center];
        } else {//之后用线连接
            [path addLineToPoint:btn.center];
        }
    }
    //最后一条没有连接点的线条
    [path addLineToPoint:self.currentPoint];
    
    //设置线条颜色
    [[UIColor redColor] set];
    
    //lineJoinStyle：拐角样式
    //kCGLineJoinMiter：尖角
    //kCGLineJoinRound：圆角
    //kCGLineJoinBevel：缺角
    path.lineJoinStyle = kCGLineJoinRound;
    
    //线条宽度
    path.lineWidth = 8;
    
    [path stroke];
}
@end
