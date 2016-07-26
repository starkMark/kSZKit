//
//  ZNLog.m
//  RYTong
//
//  Created by steven on 3/5/09.
//  Copyright 2009 RYTong. All rights reserved.
//

#import "SZLog.h"

@implementation SZLog
+ (NSString *)dateStringWithDate:(NSDate *)date formart:(NSString *)formart
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:formart];
  NSString *dataStr = [dateFormatter stringFromDate:date];
  
  return dataStr;
}

+ (void)file:(const char*)sourceFile function:(const char*)functionName lineNumber:(int)lineNumber format:(NSString*)format, ...
{
        va_list ap;
        NSString *print, *file, *function;
        va_start(ap,format);
        file = [[NSString alloc] initWithBytes: sourceFile length: strlen(sourceFile) encoding: NSUTF8StringEncoding];
        
        function = [NSString stringWithUTF8String: functionName];
  
        print = [[NSString alloc] initWithFormat: format arguments: ap];

        printf("\n调试信息：%s 执行代码：%s [%d] 运行方法：%s \n打印信息：%s\r\n",[[self dateStringWithDate:[NSDate date] formart:@"yyyy-MM-dd HH-mm-ss"] UTF8String],[[file lastPathComponent] UTF8String],__LINE__,[function UTF8String],[print UTF8String]);
  
        va_end(ap);
  
  //  DEBUG
  [FunctionUtility shareSingleTon].deBugConsle = [NSString stringWithFormat:@"%@\n调试信息：%s 执行代码：%s [%d] 运行方法：%s \n打印信息：%s\r\n",[FunctionUtility shareSingleTon].deBugConsle,[[self dateStringWithDate:[NSDate date] formart:@"yyyy-MM-dd HH-mm-ss"] UTF8String],[[file lastPathComponent] UTF8String],__LINE__,[function UTF8String],[print UTF8String]];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"consoleRefresh" object:nil];

}


@end