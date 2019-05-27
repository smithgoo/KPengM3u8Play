//
//  NowTimeSpeed.h
//
//  Created by kpeng on 7/12/18.
//  Copyright © 2018 123. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 88kB/s
extern NSString *const GSDownloadNetworkSpeedNotificationKey;
// 2MB/s
extern NSString *const GSUploadNetworkSpeedNotificationKey;
@interface NowTimeSpeed : NSObject
@property (nonatomic, copy, readonly) NSString*downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

@property (nonatomic,copy) void(^downloadSpeed)(NSString *speed);

@property (nonatomic,copy) void(^currentSpeed)(int speed);
+ (instancetype)shareNetworkSpeed;
- (void)start;
- (void)stop;
@end


NS_ASSUME_NONNULL_END

