/*
 MBAudioRecorder
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <RFKit/RFRuntime.h>
#import <AVFoundation/AVFoundation.h>

// @MBDependency:2
/**
 录音，AVAudioRecorder 封装
 */
@interface MBAudioRecorder : NSObject

/**
 讲话声
 
 单声道，尽可能低的采样率、码率。适应长时间录制、网络播放；不建议拿来录音乐，也就听个调
 */
+ (nonnull NSDictionary<NSString *, id> *)settingsForVoIP;

/**
 低质量的声乐，适应长时间录制、网络播放
 
 单声道，32k 采样，VBR 码率，最高四十多 Kbps，失真较明显，一分钟 300KB 左右
 */
+ (nonnull NSDictionary<NSString *, id> *)settingsForLowMusic;

/// The audio settings for the audio recorder.
@property (copy, nullable) NSDictionary<NSString *, id> *settings;

/**
 指定目标，如果未设置会在临时目录生成一个地址
 建议使用 m4a 作为后缀
 */
@property (nullable) NSURL *recordFileURL;

/// 非空会在录音开始时设置 audio session 的 category
@property (nullable) AVAudioSessionCategory preferredSessionCategory;

/**
 开始录音
 
 如果已有录音正在录制，会报错；MBErrorOperationUnfinished
 */
- (BOOL)startRecordError:(NSError * __nullable *__nullable)outError NS_SWIFT_NAME( startRecord() );

/**
 停止录音
 
 如果未开始会报错 MBErrorOperationCanceled。不会修改 audio session 的 category
 */
- (void)stopRecordComplation:(nullable void (^)(BOOL, NSURL *__nullable, NSError *__nullable))complation;

@property (readonly, getter=isRecording) BOOL recording;
@property (nonatomic) BOOL paused;

@end
