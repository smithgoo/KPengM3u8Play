//
//  DownLoadTableViewCell.m
//  KpengIjkPlayer
//
//  Created by 王朋 on 2019/5/9.
//  Copyright © 2019 王朋. All rights reserved.
//

#import "DownLoadTableViewCell.h"
#import "KPm3u8DownLoad.h"
@implementation DownLoadModel

-(void)setDownLoadUrl:(NSString *)downLoadUrl {
    _dw =[[KPm3u8DownLoad alloc] init];
    _dw.delegate =self;
    [_dw m3u8DownLoadAction:downLoadUrl];
}



- (void)downloadActionPresent:(float)present downloadFlag:(BOOL)finish fileTotal:(NSInteger)fileCount {
    if (_downLoadStatusCallBack) {
        _downLoadStatusCallBack(present,finish,fileCount);
    }
}
@end
@implementation DownLoadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)bdingModel:(DownLoadModel*)model {
   
    self.title.text =model.title;
    self.statusLab.text =model.statusStr;
    model.downLoadUrl =model.m3u8Url;
    model.downLoadStatusCallBack = ^(float present, BOOL finish, NSInteger fileSizeCount) {
        if (present ==1) {
            self.statusLab.text =@"下载完成";
            self.fielSize.text =[NSString stringWithFormat:@"%ld/%ld",(NSInteger)(present*fileSizeCount),fileSizeCount];
        }
    };
    model.dw.downLoadStatusCallBack = ^(NSString * _Nonnull status) {
        self.statusLab.text =status;
    };
}

@end
