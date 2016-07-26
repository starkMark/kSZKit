//
//  kSZSignalHandler.h
//  JCProject
//
//  Created by pg on 16/7/13.
//  Copyright © 2016年 StarkShen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kSZSignalHandler : NSObject

/**
 *   注册信号 SignalHandler
 */
void RegisterUncaughtExceptionHandler(void);
/**
 *   shareInstance
 */
+ (instancetype)shareInstance;
/**
 *  异常处理回调
 */
void HandleException(NSException *exception);
void SignalHandler(int signal);
/** 
 *  获取CallTrace及设备信息
 */
+ (NSArray *)backtrace;

- (void)handleException:(NSException *)exception;
@end
