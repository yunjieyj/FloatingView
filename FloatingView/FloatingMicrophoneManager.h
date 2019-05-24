//
//  FloatingMicrophoneManager.h
//  HelloWord
//
//  Created by syj on 2019/4/26.
//  Copyright © 2019 008. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface FloatingMicropConfig : NSObject
@property (nonatomic, assign) CGFloat micWidth; //default 60
@property (nonatomic, assign) CGFloat micHeight; //default 60
@property (nonatomic, assign) CGFloat topMargin; //default 15
@property (nonatomic, assign) CGFloat leftpMargin; //default 15
@property (nonatomic, assign) CGFloat bottomMargin; //default 15
@property (nonatomic, assign) CGFloat rightMargin; //default 15
@property (nonatomic, assign) CGFloat stopTopY; //default   s_TopHeight
@property (nonatomic, assign) CGFloat stopBottomY; //default    s_TabBarHeight
@property (nonatomic, assign) CGRect originRect;
@end


@interface FloatingMicrophoneManager : NSObject

+ (FloatingMicrophoneManager *)sharedManager;
@property (nonatomic, strong) FloatingMicropConfig *config;

@property (nonatomic, copy) void (^tapFloatingMicrophoneBlock)(void);
@property (nonatomic, assign) BOOL canMove; //default YES

//- (instancetype)initWithFloatingMicropConfig:(FloatingMicropConfig *)config;

- (void)addFoatingMicInView:(UIView *)view;
- (void)showFloatingMicrophone:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
