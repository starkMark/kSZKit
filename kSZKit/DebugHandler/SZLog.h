//
//  SZLog.h
//  RYTong
//
//  Created by steven on 3/5/09.
//  Copyright 2009 RYTong. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface SZLog : NSObject {}


+(void)file:(const char*)sourceFile function:(const char*)functionName lineNumber:(int)lineNumber format:(NSString*)format, ...;

#define SZLog(s, ...) [SZLog file:__FILE__ function: (char *)__FUNCTION__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
@end

