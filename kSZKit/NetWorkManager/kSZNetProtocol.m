//
//  kSZNetProtocol.m
//  JCProject
//
//  Created by pg on 16/7/21.
//  Copyright © 2016年 StarkShen. All rights reserved.
//  AppDelegate     [NSURLProtocol registerClass:[kSZNetProtocol class]];注册


#import "kSZNetProtocol.h"

@implementation kSZNetProtocol
/**
 *  返回是否需要对URLRequest进行处理
 *  NO 则会使用系统默认的行为去处理
 *  YES 则会创建URLProtocol实例
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
  
  //  只处理http和https请求
  NSString *scheme = [[request URL] scheme];
  if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"jc"] == NSOrderedSame))
  {
    //  返回YES后会通过connection或session去获取数据，这时还会调用此方法，陷入无限循环
    //  看看是否已经处理过了，防止无限循环
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
      
      return NO;
    }

    return YES;
  }
  return NO;
}

/**
 *  返回URLRequest进行处理 (必须实现)
 *  可以直接返回，也可以对URLRequest进行相关操作
 *  如修改Host，全局添加Header等，并返回一个新的URLRequest
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
  
  NSMutableURLRequest *mutableRequest = [request mutableCopy];
  mutableRequest = [self redirectHostInRequest:mutableRequest];
  return mutableRequest;
}

/** 
 *  修改 Host
 */
+ (NSMutableURLRequest *)redirectHostInRequest:(NSMutableURLRequest *)request{
 
  if ([request.URL host].length == 0) {
    return request;
  }

  NSString *originUrlString = [request.URL absoluteString];
  NSString *originHostString = [request.URL host];
  NSRange hostRange = [originUrlString rangeOfString:originHostString];
 
  if (hostRange.location == NSNotFound) {
    
    return request;
  }
  
  NSString *ipStr = @"NewHostIP";
  NSString *urlStr = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ipStr];
  NSURL *newURL = [NSURL URLWithString:urlStr];
  request.URL = newURL;

  return request;
}

/**
 *  判断两个 Request 是否一致，如果相同的话可以使用缓存
 *  通常只需要调用父类实现
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
  
  return [super requestIsCacheEquivalent:a toRequest:b];

}


/**
 *  开始和取消 Request请求，可以标注已经处理过的请求
 */
- (void)startLoading{
  
  NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
  //  标注已经处理过的Request
  [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableRequest];
  self.connection = [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
//    self.sessionTask = [self.sessionTask dataTaskWithRequest:mutableRequest];
}

- (void)stopLoading{

}

//+ (void)removePropertyForKey:(NSString *)key inRequest:(NSMutableURLRequest *)request;
//+ (BOOL)registerClass:(Class)protocolClass;
//- (instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(nullable NSCachedURLResponse *)cachedResponse client:(nullable id <NSURLProtocolClient>)client NS_AVAILABLE(10_10, 8_0);


//+ (BOOL)canInitWithTask:(NSURLSessionTask *)task NS_AVAILABLE(10_10, 8_0){
//  return YES;
//}





#pragma mark - connection 请求
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
  [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [self.client URLProtocol:self didFailWithError:error];
}

@end
