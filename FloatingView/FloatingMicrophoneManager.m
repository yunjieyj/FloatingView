//
//  FloatingMicrophoneManager.m
//  HelloWord
//
//  Created by syj on 2019/4/26.
//  Copyright © 2019 008. All rights reserved.
//

#import "FloatingMicrophoneManager.h"


// ------------- FloatingMicropConfig ------------
@interface FloatingMicropConfig ()

@end

@implementation FloatingMicropConfig
- (instancetype)init {
    if (self = [super init]) {
        self.micWidth = 60;
        self.micHeight = 60;
        self.topMargin = 15;
        self.leftpMargin = 15;
        self.bottomMargin = 15;
        self.rightMargin = 15;
        self.stopTopY = s_TopHeight;
        self.stopBottomY = s_TabBarHeight;
        self.originRect = CGRectMake(s_ScreenWidth - self.micWidth - self.rightMargin, s_ScreenHeight*3/4, self.micWidth, self.micHeight);
    }
    return self;
}

@end


// ------------- FloatingMicrophoneManager ------------
@interface FloatingMicrophoneManager()
@property (nonatomic, strong) UIImageView *floatingMic;
@property (nonatomic, strong) UIView *panSuperView;
@property (nonatomic, assign) CGPoint startPoint; //起始坐标

@end

@implementation FloatingMicrophoneManager

#pragma mark - Singleton
+ (FloatingMicrophoneManager *)sharedManager {
    static FloatingMicrophoneManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
    });
    return sharedManager;
}


- (instancetype)init {
    if (self = [super init]) {
        self.config = [[FloatingMicropConfig alloc] init];
        self.canMove = YES;
    }
    return self;
}

- (void)setConfig:(FloatingMicropConfig *)config {
    _config = config;
}

- (void)addFoatingMicInView:(UIView *)view {
    if (self.floatingMic) {
        [self.floatingMic removeFromSuperview];
        self.floatingMic = nil;
    }
    self.floatingMic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_ic"]];
    self.floatingMic.contentMode = UIViewContentModeCenter;
    self.floatingMic.frame = self.config.originRect;
    self.floatingMic.userInteractionEnabled = YES;
    [view addSubview:self.floatingMic];
    self.floatingMic.hidden = YES;
    self.panSuperView = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFloatingMic:)];
    [self.floatingMic addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFloatingMic:)];
    [self.floatingMic addGestureRecognizer:pan];
    
}

//点击mic
- (void)tapFloatingMic:(UITapGestureRecognizer *)tap {
    if (self.tapFloatingMicrophoneBlock) {
        self.tapFloatingMicrophoneBlock();
    }
}

- (void)panFloatingMic:(UIPanGestureRecognizer *)pan {
    if (!self.canMove) return;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [pan locationInView:pan.view];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint = [pan locationInView:pan.view];
        CGFloat deltaX = newPoint.x - self.startPoint.x;
        CGFloat deltaY = newPoint.y - self.startPoint.y;
        CGFloat newCenterX = pan.view.center.x + deltaX;
        CGFloat newCenterY = pan.view.center.y + deltaY;
        
        //        CGFloat topDistanceLimit = 0;  //s_TopHeight
        //        CGFloat bottomDistanceLimit = s_ScreenHeight - s_TabBarHeight - s_TopHeight;
        //        if (newCenterY - self.config.micHeight/2 - self.config.topMargin <= topDistanceLimit ) { //限制移动范围
        //            newCenterY = topDistanceLimit + self.config.micHeight/2 + self.config.topMargin;
        //        }else if (newCenterY + self.config.micHeight/2 + self.config.bottomMargin >= bottomDistanceLimit) {
        //            newCenterY = bottomDistanceLimit- self.config.micHeight/2 - self.config.bottomMargin;
        //        }
        
        pan.view.center = CGPointMake(newCenterX, newCenterY);
        
        [pan setTranslation:CGPointZero inView:self.panSuperView];
        
    }else {
        CGFloat newX = self.config.leftpMargin + self.config.micWidth/2.0;
        if (pan.view.center.x > s_ScreenWidth/2.0) {
            newX = s_ScreenWidth - self.config.micWidth/2 - self.config.rightMargin;
        }
        
        CGPoint newPoint = [pan locationInView:pan.view];
        CGFloat deltaY = newPoint.y - self.startPoint.y;
        CGFloat newCenterY = pan.view.center.y + deltaY;
        CGFloat topDistanceLimit = self.config.stopTopY;
        CGFloat bottomDistanceLimit = s_ScreenHeight - self.config.stopBottomY;
        if (newCenterY - self.config.micHeight/2 - self.config.topMargin <= topDistanceLimit ) { //限制移动范围
            newCenterY = topDistanceLimit + self.config.micHeight/2 + self.config.topMargin;
        }else if (newCenterY + self.config.micHeight/2 + self.config.bottomMargin >= bottomDistanceLimit) {
            newCenterY = bottomDistanceLimit- self.config.micHeight/2 - self.config.bottomMargin;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.floatingMic.centerX = newX;
            self.floatingMic.centerY = newCenterY;
        }];
        
    }
}

- (void)showFloatingMicrophone:(BOOL)isShow {
    self.floatingMic.hidden = !isShow;
}
@end
