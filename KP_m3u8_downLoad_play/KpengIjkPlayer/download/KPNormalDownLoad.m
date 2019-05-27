//
//  KPNormalDownLoad.m
//  KpengIjkPlayer
//
//  Created by 王朋 on 2019/5/12.
//  Copyright © 2019 王朋. All rights reserved.
//

#import "KPNormalDownLoad.h"
#import <AFNetworking.h>
static id sharedInstance = nil;

@implementation KPNormalDownLoad
+ (KPNormalDownLoad *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)KPNormalDownLoadAction:(NSString*)url {
    NSString *destinationPath = [[self videoPath] stringByAppendingPathComponent:url.lastPathComponent];
    [self downloadURL:url destinationPath:destinationPath progress:^(NSProgress *downloadProgress) {
        NSLog(@"progress___%f",downloadProgress.fractionCompleted);
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            NSLog(@"%@",error.debugDescription);
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
    NSString *vedioPath = [self.documentPath stringByAppendingPathComponent:@"VideoListNormal"];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:vedioPath]) {
        [mgr createDirectoryAtPath:vedioPath
       withIntermediateDirectories:YES
                        attributes:nil
                             error:nil];
    }
    return vedioPath;
}

// 下载方法
- (void)downloadURL:(NSString *)downloadURL
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
//                            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                            NSString *fullpath = [[self videoPath] stringByAppendingPathComponent:[downloadURL.lastPathComponent componentsSeparatedByString:@"."].firstObject];
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
