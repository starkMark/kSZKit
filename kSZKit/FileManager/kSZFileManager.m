//
//  kSZFileManager.m
//  JCProject
//
//  Created by pg on 16/7/15.
//  Copyright © 2016年 StarkShen. All rights reserved.
/*
 - (BOOL)isReadableFileAtPath:(NSString *)path;
 - (BOOL)isWritableFileAtPath:(NSString *)path;
 - (BOOL)isExecutableFileAtPath:(NSString *)path;
 - (BOOL)isDeletableFileAtPath:(NSString *)path;
 */


#import "kSZFileManager.h"

@implementation kSZFileManager

#pragma mark - 获取文件路径
/**
 *  获取沙盒Library的文件目录。
 */
+ (NSString *)LibraryDirectory{

  return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取沙盒Document的文件目录。
 */
+ (NSString *)DocumentDirectory{

  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取沙盒Preference的文件目录。
 */
+ (NSString *)PreferenceDirectory{

  return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取沙盒Caches的文件目录。
 */
+ (NSString *)CachesDirectory{

  return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  获取bundle文件目录
 *  程序所有资源文件
 */
+ (NSString *)AppBundleDirectory{
  
  return [[NSBundle mainBundle] bundlePath];
}

#pragma mark - 检查指定路径是否存在某个文件
/**
 *  检查指定路径是否存在某个文件
 *  @fileName : 文件名称
 *  @path : 指定路径
 */
+ (BOOL)checkfile:(NSString *)fileName ExistInPath:(NSString *)path{

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *filePath = [path stringByAppendingPathComponent:fileName];
  return [fileManager fileExistsAtPath:filePath];
  
}

/**
 *  计算path路径下文件的文件大小
 *  @path : 指定路径
 */
+ (double)sizeWithFilePaht:(NSString *)path{

  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  //  检测路径合理性
  BOOL dir = NO;
  BOOL exits = [fileManager fileExistsAtPath:path isDirectory:&dir];
  if (!exits) return 0;
  
  //  判断是否为文件夹
  if(dir){
    //  获取文件夹下面所有子路径(直接\间接子路径)
    NSArray *subpaths = [fileManager subpathsAtPath:path];
    int totalSize = 0;
    for (NSString *subpath in subpaths) {
      NSString *fullsubpath = [path stringByAppendingString:subpath];
      
      BOOL dir = NO;
      [fileManager fileExistsAtPath:fullsubpath isDirectory:&dir];
      if (!dir) {
        //  文件夹嵌套文件夹
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:fullsubpath error:nil];
        totalSize += [attrs[NSFileSize] intValue];
      }
    }
    return totalSize / (1000 * 1000.0);
  }else{
    //  文件
    NSDictionary *attrs = [fileManager attributesOfItemAtPath:path error:nil];
    return [attrs[NSFileSize] intValue] / (1000 * 1000.0);
  }
}


#pragma mark - 清除文件
/**
 *  删除文件
 *  删除path路径下的文件
 *  @path : 指定路径
 */
+ (void)clearCachesWithFilePath:(NSString *)path{
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager removeItemAtPath:path error:nil];
  
}

#pragma mark - 拷贝文件到指定路径
/**
 *  拷贝文件到路径
 *  @fileName 文件名
 *  @path 路径
 */
+ (void)copeFile:(NSString *)fileName toPath:(NSString *)path{

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *filePath = [path stringByAppendingString:fileName];
 
  //  检测目标路径中是否有该文件
  if (![fileManager fileExistsAtPath:filePath]) {
    
    //  在Bundle里找到该文件
    NSString *dataPath = [[[NSBundle mainBundle] bundlePath]stringByAppendingString:fileName];
    
    NSError *error;
    
    if ([fileManager copyItemAtPath:dataPath toPath:filePath error:&error]) {
      
      NSLog(@"file copy success !");
    
    }else{
      
      NSLog(@"file copy error %@!",error);
    }
  }
}


#pragma mark - 文件读写
/**
 *  创建文件夹
 *  @fileName 文件名
 *  @path 路径
 */
+ (void)createFile:(NSString *)fileName inPath:(NSString *)path{
  
  NSString* filepath = [path stringByAppendingPathComponent:fileName];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createFileAtPath:filepath contents:nil attributes:nil];
  
}

/**
 *  从原路径拷贝到新路径
 *  @location 文件位置
 *  @fileName 存储文件名
 *  @path 新存放路径
 */
+ (void)copeFile:(NSString *)fileName fromLocation:(NSURL *)location toPath:(NSString *)path{
  NSURL *newFileLocation = [NSURL fileURLWithPath:path];
  newFileLocation = [newFileLocation URLByAppendingPathComponent:fileName];
  [[NSFileManager defaultManager] copyItemAtURL:location toURL:newFileLocation error:nil];
}

#pragma mark - 文件提交与下载

/**
 *  文件下载
 *  @fileURL   下载地址
 *  @locationPath 存放路径
 *  文件名默认使用 lastPathComponent
 */
+ (void)downLoadDirectoryFromURL:(NSURL *)fileURL toLocationPath:(NSString *)locationPath{
  // http://jc.com/file.zip
  NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //  下载成功
    NSURL *documentDirectoryPath = [NSURL fileURLWithPath:locationPath];
    NSURL *newFileLocation = [documentDirectoryPath URLByAppendingPathComponent:[[response URL] lastPathComponent]];//取文件名 lastPathComponent file.zip
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:newFileLocation error:nil];

  }];
  [downloadTask resume];
}


/**
 *  文件提交
 *  @data     文件数据
 *  @uploadURL  上传地址
 */
+ (void)uploadData:(NSData *)uplaodData toNetPathURL:(NSURL *)uploadURL completionHandler:(executeBlock)executeBlock{
  
  NSURLRequest *uploadRequest = [NSURLRequest requestWithURL:uploadURL];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:uploadRequest fromData:uplaodData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
  
      //  上传结束
    executeBlock(data,response,error);
    
  }];
  
  [uploadTask resume];
}

@end
