//
//  RecordSoundWaveAnimationView.h
//  CCVoiceMicAnimationDemo
//
//  Created by syj on 2019/5/15.
//  Copyright © 2019 syj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordSoundWaveAnimationView : UIView

@property (nonatomic, copy) void (^itemLevelCallback)(void);
@property (nonatomic, assign) float level;
- (void)start;
- (void)stop;
- (void)resetCAShaplayer;
@end

NS_ASSUME_NONNULL_END
