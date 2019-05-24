//
//  ViewController.m
//  FloatingView
//
//  Created by syj on 2019/5/24.
//  Copyright © 2019 syj. All rights reserved.
//

#import "ViewController.h"
#import "FloatingMicrophoneManager.h"
#import "Music_VoiceInteractionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FloatingMicropConfig *config = [FloatingMicropConfig new];
    [FloatingMicrophoneManager sharedManager].config = config;
    [[FloatingMicrophoneManager sharedManager] addFoatingMicInView:[UIApplication sharedApplication].keyWindow];
    s__WEAK_SELF
    [FloatingMicrophoneManager sharedManager].tapFloatingMicrophoneBlock = ^{
        NSLog(@"点击");
        [weakSelf showInteractionView];
    };
    [[FloatingMicrophoneManager sharedManager] showFloatingMicrophone:YES];
    
}

- (void)showInteractionView {
    Music_VoiceInteractionView *viView = [[Music_VoiceInteractionView alloc] initWithCompleteBlock:^{
        NSLog(@"交互界面消失");
    }];
    [viView show];
}



@end
