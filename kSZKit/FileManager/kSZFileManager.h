//
//  kSZFileManager.h
//  JCProject
//
//  Created by pg on 16/7/15.
//  Copyright © 2016年 StarkShen. All rights reserved.
//

typedef void (^executeBlock)(NSData *data,NSURLResponse *response,NSError *error);

#import <Foundation/Foundation.h>

@interface kSZFileManager : NSObject

/**
 *  获取沙盒Library的文件目录。
 */
+ (NSString *)LibraryDirectory;

/**
 *  获取沙盒Document的文件目录。
 */
+ (NSString *)DocumentDirectory;

/**
 *  获取沙盒Preference的文件目录。
 */
+ (NSString *)PreferenceDirectory;

/**
 *  获取沙盒Caches的文件目录。
 */
+ (NSString *)CachesDirectory;

/**
 *  获取bundle文件目录
 *  程序所有资源文件
 */
+ (NSString *)AppBundleDirectory;

/**
 *  检查指定路径是否存在某个文件
 *  @fileName : 文件名称
 *  @path : 指定路径
 */
+ (BOOL)checkfile:(NSString *)fileName ExistInPath:(NSString *)path;

/**
 *  计算path路径下文件的文件大小
 *  @path : 指定路径
 */
+ (double)sizeWithFilePaht:(NSString *)path;

/**
 *  删除文件
 *  删除path路径下的文件
 *  @path : 指定路径
 */
+ (void)clearCachesWithFilePath:(NSString *)path;

/**
 *  拷贝文件到路径
 *  @fileName 文件名
 *  @path 路径
 */
+ (void)copeFile:(NSString *)fileName toPath:(NSString *)path;
/**
 *  从原路径拷贝到新路径
 *  @location 文件位置
 *  @fileName 文件名
 *  @path 新存放路径
 */
+ (void)copeFile:(NSString *)fileName fromLocation:(NSURL *)location toPath:(NSString *)path;
/**
 *  创建文件夹
 *  @fileName 文件名
 *  @path 路径
 */
+ (void)createFile:(NSString *)fileName inPath:(NSString *)path;



/**
 *  文件下载
 *  @fileURL   下载地址
 *  @locationPath 存放路径
 *  文件名默认使用 lastPathComponent
 */
+ (void)downLoadDirectoryFromURL:(NSURL *)fileURL toLocationPath:(NSString *)locationPath;


/**
 *  文件提交
 *  @data     文件数据
 *  @uploadURL  上传地址
 */
+ (void)uploadData:(NSData *)uplaodData toNetPathURL:(NSURL *)uploadURL completionHandler:(executeBlock)executeBlock;


@end
