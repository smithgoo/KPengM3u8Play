//
//  KPNormalDownLoad.h
//  KpengIjkPlayer
//
//  Created by 王朋 on 2019/5/12.
//  Copyright © 2019 王朋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KPNormalDownLoadDelegate <NSObject>
- (void)downloadActionPresent:(float)present downloadFlag:(BOOL)finish fileTotal:(NSInteger)fileCount;
@end

@interface KPNormalDownLoad : NSObject
@property (nonatomic,assign) id<KPNormalDownLoadDelegate> delegate;
@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic,assign) NSInteger DownLoadStatus;//1 是下载 0 是暂停
+ (KPNormalDownLoad *)manager;

@property (nonatomic,copy) void(^downLoadStatusCallBack)(NSString *status);

- (void)KPNormalDownLoadAction:(NSString*)url;

- (void)KPNormalDownLoadsuspended;

- (void)KPNormalDownLoadcontinue;

- (void)KPNormalDownLoadcancel;
@end

NS_ASSUME_NONNULL_END
