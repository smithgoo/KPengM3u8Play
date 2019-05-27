//
//  KPm3u8DownLoad.m
//
//
//  Created by kpeng on 30/4/19.
//  Copyright © 2019 123. All rights reserved.
//

#import "KPm3u8DownLoad.h"
#import <AFNetworking.h>
//#import "BaseInfo.h"
#import "WHCFileManager.h"
@implementation KPm3u8DownLoad
static id sharedInstance = nil;
+ (KPm3u8DownLoad *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//下载mm3u8文件解析ts
- (void)m3u8DownLoadAction:(NSString*)url {
    NSString *destinationPath = [self.documentPath stringByAppendingPathComponent:url.lastPathComponent];

    [self downLoadM3u8File:url
      destinationPath:destinationPath
             progress:nil
           completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
               if (!error) {
                   [self dealPlayList:url];
               } else {
                   NSLog(@"%@",error.debugDescription);
               }
           }];
    [self keyDownLoadAction:@"http://fastwebcache.yod.cn/hls-enc-test/jialebi/key.bin"];
}

//下载解密key
- (void)keyDownLoadAction:(NSString*)url {
    NSString *destinationPath = [[self videoPath] stringByAppendingPathComponent:url.lastPathComponent];
    
    [self downLoadM3u8File:url
           destinationPath:destinationPath
                  progress:nil
                completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    if (!error) {
                        
                     } else {
                        NSLog(@"%@",error.debugDescription);
                    }
                }];
}
    

// 处理m3u8文件
- (void)dealPlayList:(NSString*)url {
 
    // 读取m3u8文件内容
    NSString *filePath = [self.documentPath stringByAppendingPathComponent:url.lastPathComponent];
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSArray *array = [content componentsSeparatedByString:@"\n"];
    
    // 筛选出 .ts 文件
    NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:array.count];
   
    for (NSString *str in array) {
        if ([str containsString:@".ts"]) {
            [listArr addObject:str];
        }
    }
    
    NSString *firstStr = listArr.firstObject;
    NSString *videoName = [firstStr componentsSeparatedByString:@"."].firstObject;
//    self.tipLab.text = [NSString stringWithFormat:@"共有 %ld 个视频", listArr.count];
    // 下载 ts 文件
    [self downloadVideoWithArr:listArr andIndex:0 videoName:videoName url:url];
}

// 循环下载 ts 文件
- (void)downloadVideoWithArr:(NSArray *)listArr andIndex:(NSInteger)index videoName:(NSString *)videoName url:(NSString*)url{
    if (index >= listArr.count) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadActionPresent:downloadFlag:fileTotal:)]) {
            [self.delegate downloadActionPresent:1.0 downloadFlag:YES fileTotal:listArr.count];
            NSLog(@"下载完毕");
            [self copyFileToWhere:[[url componentsSeparatedByString:@"/"] lastObject]];
        }
        
        return;
    }

    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadActionPresent:downloadFlag:fileTotal:)]) {
        [self.delegate downloadActionPresent:(float)index/listArr.count downloadFlag:NO fileTotal:listArr.count];
    }
    // 拼接ts全路径，有的文件直接包含，不需要拼接
    NSString *downloadURL = [url stringByReplacingOccurrencesOfString:url.lastPathComponent withString:listArr[index]];
    downloadURL =[downloadURL substringToIndex:([downloadURL length]-1)];
    
    // 存储路径
    NSString *fileName = downloadURL.lastPathComponent;
    NSString *destinationPath = [self.videoPath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        [self downloadVideoWithArr:listArr andIndex:index+1 videoName:videoName url:url];
        return;
    }
    
    [self downloadURL:downloadURL
      destinationPath:destinationPath
             progress:nil
           completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
               if (!error) {
                   [self downloadVideoWithArr:listArr andIndex:index+1 videoName:videoName url:url];
               }
           }];
}


// 沙盒 document 路径
- (NSString *)documentPath  {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return docDir;
}



// 视频列表路径
- (NSString *)videoPath {
    NSString *vedioPath = [self.documentPath stringByAppendingPathComponent:@"VideoList"];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:vedioPath]) {
        [mgr createDirectoryAtPath:vedioPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
    return vedioPath;
}

- (void)copyFileToWhere:(NSString*)m3u8File {
    [WHCFileManager copyItemAtPath:[NSString stringWithFormat:@"%@/%@",[self documentPath],m3u8File] toPath:[NSString stringWithFormat:@"%@/%@",[self videoPath],m3u8File]];
}



// 下载方法
- (void)downloadURL:(NSString *)downloadURL
    destinationPath:(NSString *)destinationPath
           progress:(void (^)(NSProgress *downloadProgress))progress
         completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString * urlStr = downloadURL;
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *path = [self.documentPath stringByAppendingPathComponent:url.lastPathComponent];
    __block  NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
 
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
        });
        NSURL *filePathUrl = nil;
        if (destinationPath) {
            filePathUrl = [NSURL fileURLWithPath:destinationPath];
        }
        if (filePathUrl) {
            return filePathUrl;
        }
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:fullpath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        if (completion) {
             completion(response, filePath, error);
         }
    }];
    
    
    [downloadTask resume];

}

    // 下载方法
- (void)downloadKeyURL:(NSString *)downloadURL
    destinationPath:(NSString *)destinationPath
           progress:(void (^)(NSProgress *downloadProgress))progress
         completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString * urlStr = downloadURL;
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *path = [self.documentPath stringByAppendingPathComponent:url.lastPathComponent];
    __block  NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
        });
        NSURL *filePathUrl = nil;
        if (destinationPath) {
            filePathUrl = [NSURL fileURLWithPath:destinationPath];
        }
        if (filePathUrl) {
            return filePathUrl;
        }
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:fullpath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        if (completion) {
            completion(response, filePath, error);
        }
    }];
    
    
    [downloadTask resume];
    
}
    
    
    
- (void)downLoadM3u8File:(NSString *)downloadURL
destinationPath:(NSString *)destinationPath
progress:(void (^)(NSProgress *downloadProgress))progress
              completion:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completion {
        AFHTTPSessionManager *manage  = [AFHTTPSessionManager manager];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: downloadURL]];
        _downloadTask =
        [manage downloadTaskWithRequest:request
                               progress:^(NSProgress * _Nonnull downloadProgress) {
                                   if (progress) {
                                       progress(downloadProgress);
                                   }
                               }
                            destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    
                                NSURL *filePathUrl = nil;
                                if (destinationPath) {
                                    filePathUrl = [NSURL fileURLWithPath:destinationPath];
                                }
                                if (filePathUrl) {
                                    return filePathUrl;
                                }
                                NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
                                filePathUrl = [NSURL fileURLWithPath:fullpath];
                                return filePathUrl;
                            }
                      completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                          if (completion) {
                              completion(response, filePath, error);
                          }
                      }];
    
        [_downloadTask resume];
        _DownLoadStatus =1;
}

- (void)m3u8DownLoadsuspended {
    
    [_downloadTask suspend];
    _DownLoadStatus =0;
    if (_downLoadStatusCallBack) {
        _downLoadStatusCallBack(@"暂停中");
    }
}

- (void)m3u8DownLoadcontinue {
    [_downloadTask resume];
    _DownLoadStatus =1;
    if (_downLoadStatusCallBack) {
        _downLoadStatusCallBack(@"正在下载");
    }
}

- (void)m3u8DownLoadcancel {
    [_downloadTask cancel];
}
@end
