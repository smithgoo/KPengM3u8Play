//
//  KPm3u8DownLoad.h
//
//  Created by kpeng on 30/4/19.
//  Copyright © 2019 123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYDownLoadDataManager.h"
#import "TYDownLoadUtility.h"
NS_ASSUME_NONNULL_BEGIN
@protocol KPm3u8DownLoadDelegate <NSObject>
- (void)downloadActionPresent:(float)present downloadFlag:(BOOL)finish fileTotal:(NSInteger)fileCount;
@end

@interface KPm3u8DownLoad : NSObject
@property (nonatomic,assign) id<KPm3u8DownLoadDelegate> delegate;
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic,assign) NSInteger DownLoadStatus;//1 是下载 0 是暂停
+ (KPm3u8DownLoad *)manager;

@property (nonatomic,copy) void(^downLoadStatusCallBack)(NSString *status);

- (void)m3u8DownLoadAction:(NSString*)url;

- (void)m3u8DownLoadsuspended;

- (void)m3u8DownLoadcontinue;

- (void)m3u8DownLoadcancel;
@property (nonatomic,strong) TYDownloadModel *downloadModel;

@end

NS_ASSUME_NONNULL_END
