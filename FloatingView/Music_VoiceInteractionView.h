//
//  Music_VoiceInteractionView.h
//  MobileAir
//
//  Created by syj on 2019/5/10.
//  Copyright © 2019 syj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Music_VoiceInteractionView : UIView
- (instancetype)initWithCompleteBlock:(void(^)(void))completeBlock;
- (void)show;
@end

NS_ASSUME_NONNULL_END
