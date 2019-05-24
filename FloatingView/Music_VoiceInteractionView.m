//
//  Music_VoiceInteractionView.m
//  MobileAir
//
//  Created by syj on 2019/5/10.
//  Copyright © 2019 syj. All rights reserved.
//

#import "Music_VoiceInteractionView.h"
#import "RecordSoundWaveAnimationView.h"
#import <AVFoundation/AVFoundation.h>

@interface Music_VoiceInteractionView () <UIGestureRecognizerDelegate, AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView1;
@property (weak, nonatomic) IBOutlet UIView *bottomView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint2;
@property (nonatomic, copy) SyjHandleBlock doneBlock;
@property (weak, nonatomic) IBOutlet RecordSoundWaveAnimationView *soundWaveAnimationView;
@property (nonatomic, strong) CADisplayLink *levelTimer; //振幅计时器
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;

@end

@implementation Music_VoiceInteractionView

- (instancetype)initWithCompleteBlock:(void(^)(void))completeBlock {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.frame = CGRectMake(0, 0, s_ScreenWidth, s_ScreenHeight);
        
        //点击背景是否影藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.bottomViewConstraint1.constant = -self.height;
        self.bottomViewConstraint2.constant = self.height;
        self.backgroundColor = s_ColorAlpha(0, 0, 0, 0);
        [self layoutIfNeeded];
        
        if (completeBlock) {
            self.doneBlock = ^{
                
            };
        }
        
        
        s__WEAK_SELF
        self.soundWaveAnimationView.itemLevelCallback = ^{
            [weakSelf.audioRecorder updateMeters];
            float power= [weakSelf.audioRecorder averagePowerForChannel:0];
            weakSelf.soundWaveAnimationView.level = power;
        };
    }
    return self;
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.bottomViewConstraint1.constant = -self.height;
    self.bottomViewConstraint2.constant = self.height;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomViewConstraint1.constant = -40;
        self.bottomViewConstraint2.constant = 0;
        self.backgroundColor = s_ColorAlpha(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.audioRecorder record];
        [self.soundWaveAnimationView start];
    }];
}

- (void)dismiss {
    [self.audioRecorder stop];
    [self.soundWaveAnimationView stop];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomViewConstraint1.constant = -self.height;
        self.bottomViewConstraint2.constant = self.height;
        self.backgroundColor = s_ColorAlpha(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.bottomView2]) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}


/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        [self setAudioSession];
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}


- (void)setAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //AVAudioSessionCategoryPlayAndRecord用于录音和播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
}


/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}


/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
- (NSURL *)getSavePath {
    
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"AudioData"];
    NSLog(@"%@",path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
    }
    
    path = [path stringByAppendingPathComponent:@"myRecord.aac"];
    NSLog(@"file path:%@",path);
    NSURL *url=[NSURL fileURLWithPath:path];
    return url;
}

@end
