//
//  RecordSoundWaveAnimationView.m
//  CCVoiceMicAnimationDemo
//
//  Created by syj on 2019/5/15.
//  Copyright © 2019 syj. All rights reserved.
//

#import "RecordSoundWaveAnimationView.h"
#define ALPHA 0.015f                 // 音频振幅调解相对值 (越小振幅就越高)

@interface RecordSoundWaveAnimationView ()
@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, assign) CGFloat levelWidth;
@property (nonatomic, assign) CGFloat levelMargin;

@property (nonatomic, strong) UIView *levelContentView; //振幅所有视图的载体
@property (nonatomic, strong) CAShapeLayer *levelLayer; //振幅layer
@property (nonatomic, strong) UIBezierPath *levelPath;  //画振幅的path
@property (nonatomic, strong) NSMutableArray *currentLevelsArray; // 当前振幅数组
@property (nonatomic, strong) CADisplayLink *levelTimer; //振幅计时器
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation RecordSoundWaveAnimationView

- (id)init {
    if(self = [super init]) {
        [self initUI];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI {
    self.backgroundColor = UIColor.clearColor;
    self.numberOfItems = 19;
    self.levelWidth = 5.0;
    self.levelMargin = 6.0;
    
    UIView *levelContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:levelContentView];
    self.levelContentView = levelContentView;
    
    
    CAShapeLayer *levelLayer = [CAShapeLayer layer];
//    levelLayer.backgroundColor = [UIColor cyanColor].CGColor;
    levelLayer.strokeColor = UIColor.whiteColor.CGColor;
    levelLayer.fillColor = [[UIColor clearColor] CGColor];
    levelLayer.lineWidth = self.levelWidth;
    levelLayer.lineCap = kCALineCapRound; //线条拐角
    levelLayer.lineJoin = kCALineJoinRound; //终点处理
    CGFloat levelLayerWidth = self.numberOfItems * (self.levelWidth + self.levelMargin) + self.levelMargin - self.levelWidth;
    CGFloat levelLayerHeight = levelContentView.frame.size.height;
    levelLayer.frame = CGRectMake(levelContentView.frame.size.width/2.0 - levelLayerWidth/2.0 , 0, levelLayerWidth, levelLayerHeight);
    [levelContentView.layer addSublayer:levelLayer]; //有gradientLayer作为遮罩时可以不用add
    self.levelLayer = levelLayer;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = levelContentView.bounds;
    gradientLayer.colors = @[(id)[UIColor colorWithRed:37/255.0 green:166/255.0 blue:149/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:55/255.0 green:222/255.0 blue:107/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:37/255.0 green:166/255.0 blue:149/255.0 alpha:1].CGColor];
    gradientLayer.locations = @[@(0),@(0.5),@(1)]; //设置渐变位置
    gradientLayer.startPoint = CGPointMake(0, 0); //设置起始点
    gradientLayer.endPoint = CGPointMake(1, 0); //设置结束点
    [gradientLayer setMask:self.levelLayer];
    [self.levelContentView.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    [self updateLevelLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


- (void)setItemLevelCallback:(void (^)(void))itemLevelCallback {
    NSLog(@"setItemLevelCallback");
    _itemLevelCallback = itemLevelCallback;
//    [self start];
}

- (void)setLevel:(float)level {
    
//    double aveChannel = pow(10, (ALPHA * level));
//    if (aveChannel < 0) {
//        aveChannel = 0 ;
//    }else if (aveChannel > 1){
//        aveChannel = 1;
//    }
//    level = aveChannel;
    
    level = (level+37.5)*3.2 / self.levelLayer.frame.size.height;
    if( level < 0 ) level = 0;
    if (level > (1 - self.levelWidth/self.levelLayer.frame.size.height)) { //防止高度最高时圆角被遮挡
        level = (1 - self.levelWidth/self.levelLayer.frame.size.height);
    }
    
    NSLog(@"setLevel:%f", level); // 0 ~ 1
    
    float aa0 = (0 + arc4random()%4/10.0)/10.0;
    float aa1 = (0.1 + arc4random()%7/10.0)/10.0;
    float aa2 = (0.2 + arc4random()%7/10.0)/10.0;
    float aa3 = (0.7 + arc4random()%6/10.0)/10.0;
    float aa4 = (1.5 + arc4random()%8/10.0)/10.0;
    float aa5 = (3.1 + arc4random()%8/10.0 )/10.0; //(3.1 0~0.7)/10.0
    float aa6 = (4.0 + arc4random()%16/10.0 )/10.0;
    float aa7 = (5.7 + arc4random()%16/10.0 )/10.0;
    float aa8 = (7.0 + arc4random()%20/10.0 )/10.0; //(7 +  0~1.9)/10.0
    self.currentLevelsArray = [NSMutableArray arrayWithArray:@[@(level*aa0),@(level*aa1),@(level*aa2),@(level*aa3),@(level*aa4),@(level*aa5),@(level*aa6),@(level*aa7),@(level*aa8),@(level*1),@(level*aa8),@(level*aa7),@(level*aa6),@(level*aa5),@(level*aa4),@(level*aa3),@(level*aa2),@(level*aa1),@(level*aa0)]];
    
    [self updateLevelLayer];
}

- (void)drawRect:(CGRect)rect {
    
}

#pragma mark - update
- (void)updateLevelLayer {
    self.levelPath = [UIBezierPath bezierPath];
    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i = 0; i < self.currentLevelsArray.count; i++) {
        CGFloat x = i * (self.levelWidth + self.levelMargin) + self.levelMargin;
        CGFloat pathH = [self.currentLevelsArray[i] floatValue] * height;
        CGFloat startY = height / 2.0 - pathH / 2.0;
        CGFloat endY = height / 2.0 + pathH / 2.0;
        [self.levelPath moveToPoint:CGPointMake(x, startY)];
        [self.levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    
    self.levelLayer.path = self.levelPath.CGPath;
}


- (void)start {
    if (self.levelTimer == nil) {
        self.levelTimer = [CADisplayLink displayLinkWithTarget:_itemLevelCallback selector:@selector(invoke)];
        if (@available(iOS 10.0, *)) {
            self.levelTimer.preferredFramesPerSecond = 10;
        } else {
            self.levelTimer.frameInterval = 6;
        }
        [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stop {
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    [self resetCAShaplayer];
}

- (void)resetCAShaplayer {
    [_currentLevelsArray removeAllObjects];
    for (int i = 0 ; i < _numberOfItems; i ++) {
        [_currentLevelsArray addObject:@(0)];
    }
    [self updateLevelLayer];
    
    //增加动画
//    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 0.3;
//    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
//    pathAnimation.autoreverses=NO;
//    self.levelLayer.path = self.levelPath.CGPath;
//    [self.levelLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}


- (NSMutableArray *)currentLevelsArray {
    if (_currentLevelsArray == nil) {
        _currentLevelsArray = [NSMutableArray array];
        for (int i = 0 ; i < _numberOfItems; i ++) {
            [_currentLevelsArray addObject:@(0)];
        }
    }
    return _currentLevelsArray;
}


@end
