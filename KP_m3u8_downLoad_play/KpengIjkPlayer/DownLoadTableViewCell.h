//
//  DownLoadTableViewCell.h
//  KpengIjkPlayer
//
//  Created by 王朋 on 2019/5/9.
//  Copyright © 2019 王朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPm3u8DownLoad.h"

NS_ASSUME_NONNULL_BEGIN
@interface DownLoadModel : NSObject<KPm3u8DownLoadDelegate>
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *statusStr;
@property (nonatomic,strong) NSString *fileSize;
@property (nonatomic,strong) NSString *m3u8Url;
@property (nonatomic,strong) NSString *downLoadUrl;

@property (nonatomic,copy) void(^downLoadStatusCallBack)(float present,BOOL finish ,NSInteger fileSizeCount);
@property (nonatomic,strong) KPm3u8DownLoad *dw;

@end

@interface DownLoadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *fielSize;
- (void)bdingModel:(DownLoadModel*)model;
@end

NS_ASSUME_NONNULL_END
