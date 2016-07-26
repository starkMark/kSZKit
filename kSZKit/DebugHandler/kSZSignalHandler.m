//
//  kSZSignalHandler.m
//  JCProject
//
//  Created by pg on 16/7/13.
//  Copyright © 2016年 StarkShen. All rights reserved.
//  [kSZSignalHandler registerSignalHandler];

#import "kSZSignalHandler.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>
#import <execinfo.h>
#import <sys/signal.h>

NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

volatile int32_t UncaughtExceptionCount = 0;//当前处理的异常个数
const int32_t UncaughtExceptionMaximum = 10;//最大能够处理的异常个数


/** 捕获异常信号的回调 */
void SignalHandler(int signal)
{
  int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
  if (exceptionCount > UncaughtExceptionMaximum) {
    return;
  }
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:@"signal"];
  
  //  创建一个OC异常对象
  NSException *exception = [NSException exceptionWithName:@"SignalExceptionName" reason:[NSString stringWithFormat:@"Signal %d was raised.\n",signal] userInfo:userInfo];
  
  //  处理异常消息
  [[kSZSignalHandler shareInstance] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
  
}
void HandleException(NSException *exception)
{
  int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
  if (exceptionCount > UncaughtExceptionMaximum) {
    return;
  }
  
  //  处理异常消息
  [[kSZSignalHandler shareInstance] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
  
  NSArray *callStack = [kSZSignalHandler backtrace];
  NSMutableDictionary *userInfo =
  [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
  [userInfo
   setObject:callStack
   forKey:UncaughtExceptionHandlerAddressesKey];
  
  [[[kSZSignalHandler alloc] init]
   performSelectorOnMainThread:@selector(handleException:)
   withObject:
   [NSException
    exceptionWithName:[exception name]
    reason:[exception reason]
    userInfo:userInfo]
   waitUntilDone:YES];

}

void RegisterUncaughtExceptionHandler(void)
{
  NSSetUncaughtExceptionHandler(&HandleException);
  //注册程序由于abort()函数调用发生的程序终止信号
  signal(SIGABRT, SignalHandler);
  
  //注册程序由于非法指令产生的程序终止信号
  signal(SIGILL, SignalHandler);
  
  //注册程序由于无效内存的引用导致的终止信号
  signal(SIGSEGV, SignalHandler);
  
  //注册程序由于浮点数异常导致的终止信号
  signal(SIGFPE, SignalHandler);
  
  //注册程序由于内存地址未对齐导致的终止信号
  signal(SIGBUS, SignalHandler);
  
  //注册程序由于消息发送失败导致的
  signal(SIGPIPE, SignalHandler);
}


@implementation kSZSignalHandler

static kSZSignalHandler *signalHandler = nil;
+ (instancetype)shareInstance{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (signalHandler == nil) {
      
      signalHandler = [[kSZSignalHandler alloc] init];
    }
  });
  return signalHandler;
}

BOOL isDismissed = NO;
//  异常处理方法
- (void)handleException:(NSException *)exception{
  
  CFRunLoopRef runLoop = CFRunLoopGetCurrent();
  CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
  
  //处理异常信息
  [self handleSignalWithException:exception];
  
  //  接收到异常消息时，让程序开始runLoop，防止程序挂掉
  while (!isDismissed) {
    for (NSString *mode in (__bridge NSArray *)allModes) {
      CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
    }
  }
  
  CFRelease(allModes);
  NSSetUncaughtExceptionHandler(NULL);
  
  /*
   * SIG_DFL 与SIG_IGN 分别表示无返回值的函数指针
   * 指针分别是0和1，这两个指针值逻辑上讲是不可能出现的函数地址值
   * SIGNAL 信号类型
   SIGABRT–程序中止命令中止信号
   SIGALRM–程序超时信号
   SIGFPE–程序浮点异常信号
   SIGILL–程序非法指令信号
   SIGHUP–程序终端中止信号
   SIGINT–程序键盘中断信号
   SIGKILL–程序结束接收中止信号
   SIGTERM–程序kill中止信号
   SIGSTOP–程序键盘中止信号
   SIGSEGV–程序无效内存中止信号
   SIGBUS–程序内存字节未对齐中止信号
   SIGPIPE–程序Socket发送失败中止信号
   */
  
  signal(SIGABRT, SIG_DFL);
  signal(SIGILL, SIG_DFL);
  signal(SIGSEGV, SIG_DFL);
  signal(SIGFPE, SIG_DFL);
  signal(SIGBUS, SIG_DFL);
  signal(SIGPIPE, SIG_DFL);
  
}

#pragma mark - 信号异常处理
- (void)handleSignalWithException:(NSException *)exception{
  
  //  获取异常崩溃信息
  NSString *reason = [exception reason];
  NSString *name = [exception name];
  NSString *content = [NSString stringWithFormat:@"========异常错误报告========\n异常名称:%@\n异常原因:\n%@\n调用堆栈:\n%@\n",name,reason,[kSZSignalHandler backtrace]];
  
  NSArray *callStack = [exception callStackSymbols];//调用堆栈
  [callStack componentsJoinedByString:@"\n"]; //unuse

  //  处理崩溃信息
  /**
   //1.发送到邮箱
   NSMutableString *mailUrl = [NSMutableString string];
   [mailUrl appendString:@"apps@51jiecai.com"];
   [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
   [mailUrl appendFormat:@"&body=%@", content];
   NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
   */
  
  //2.复制到剪切板
  [self pasteboardToCopyWithInfo:content];
  
}

/** 复制到剪切板 */
- (void)pasteboardToCopyWithInfo:(NSString *)copyInfo{
  
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.string =  copyInfo;
  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"程序异常", nil) message:NSLocalizedString(@"检测到程序异常\r\n异常信息已复制到剪切板",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
  [alert show];
  
}



/** 获取CallTrace及设备信息 */
+ (NSArray *)backtrace{
  
  void *callstack[128];
  int frames = backtrace(callstack, 128);
  char **strs = backtrace_symbols(callstack, frames);
  
  int i;
  NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
  for (i = UncaughtExceptionHandlerSkipAddressCount;i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
    [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
  }
  free(strs);
  
  return backtrace;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
  if (buttonIndex == 0) {
    isDismissed = YES;
  }
}

@end
