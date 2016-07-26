//
//  kSZNetProtocol.h
//  JCProject
//
//  Created by pg on 16/7/21.
//  Copyright © 2016年 StarkShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define URLProtocolHandledKey @"URLProtocolHandledKey"
@interface kSZNetProtocol : NSURLProtocol<NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLConnection *connection;//connection 发起的请求
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;//session 发起的请求
@end
