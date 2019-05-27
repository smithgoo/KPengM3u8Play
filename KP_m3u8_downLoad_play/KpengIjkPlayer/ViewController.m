//
//  ViewController.m
//  KpengIjkPlayer
//
//  Created by 王朋 on 2019/5/9.
//  Copyright © 2019 王朋. All rights reserved.
//

#import "ViewController.h"
#import "KPIjkVideoView.h"
#import "DownLoadViewController.h"
#import "KPNormalDownLoad.h"
#import "KPm3u8DownLoad.h"
#import <HTTPServer.h>
#define simpleUrl @"https://iqiyi.com-l-iqiyi.com/20190210/21492_1ca43cc4/index.m3u8"
@interface ViewController ()<KPIjkVideoViewDelegate,KPm3u8DownLoadDelegate>
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) KPIjkVideoView *videoPlayer;


@end

@implementation ViewController
    
 

    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];

    // Do any additional setup after loading the view.
    // 如果是iphoneX这种刘海的 自己去适配

    UIButton *btn = [UIButton new];
    [self.view addSubview:btn];
    btn.frame =CGRectMake((self.view.bounds.size.width-100)/2, 300, 100, 100);
    [btn setTitle:@"下载" forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)downLoad:(UIButton*)sender {
    
    KPm3u8DownLoad *md = [KPm3u8DownLoad new];
    md.delegate =self;
    [md m3u8DownLoadAction:@"http://fastwebcache.yod.cn/hls-enc-test/jialebi/stream.m3u8"];

//http://xz3-8.okzyxz.com/20190511/8470_a043b17b/Iron.Sky.The.Coming.Race..mp4

    
    /*DownLoadViewController *dw =[DownLoadViewController new];
    [self presentViewController:dw animated:YES completion:nil];*/
}


- (void)downloadActionPresent:(float)present downloadFlag:(BOOL)finish fileTotal:(NSInteger)fileCount {
    NSLog(@"%f",present);
    if (present>=1) {
        if (!_videoPlayer) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self initVideoPlayer];
            });
           
        }
    }
}

- (void)initVideoPlayer {
    NSString *playUrl = @"http://127.0.0.1:9479/stream.m3u8";
    _videoPlayer = [[KPIjkVideoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.width*9/16) delegate:self playUrl:self.url.length>0?self.url:playUrl title:@"毒液"];
    [self.view addSubview:_videoPlayer];
 
}


#pragma mark -- ijk 封装完成之后在 控制器要实现的代理方法 begin  当然可以再简化
- (void)KPVideoPlayerDistory {
    [_videoPlayer.player stop];
    [_videoPlayer.player shutdown];
    [_videoPlayer.player.view removeFromSuperview];
    _videoPlayer = nil;
 
}

- (void)playerBackAction {
    if (!_videoPlayer.isFullScreen) {
        [_videoPlayer.player stop];
        [_videoPlayer.player shutdown];
        [_videoPlayer.player.view removeFromSuperview];
        _videoPlayer = nil;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
    }
    
}

- (void)exchangeAction:(UIButton*)sender {
    [_videoPlayer exChangePlayMthod];
}


- (void)videoScreenFullScreenOrNot:(BOOL)isFullScreen {
    if (isFullScreen) {//小屏->全屏
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
    }else{//全屏->小屏
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
    }
    _videoPlayer.isFullScreen =isFullScreen;
    _videoPlayer.toolsView.isFullScreen =isFullScreen;
    
}


#pragma mark -与全屏相关的代理方法等

BOOL fullScreen;

static UIButton * btnFullScreen;

//点击了全屏按钮
-(void)btnFullScreenDidClick:(UIButton *)sender{
    
    fullScreen = !fullScreen;
    
    btnFullScreen = sender;
    
    if (fullScreen) {//小屏->全屏
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
        
        
    }else{//全屏->小屏
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            
        }];
        
    }
    [_videoPlayer.toolsView layoutSubviews];
}

#pragma mark------ijk 播放的代理方法
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeLeft||[UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeRight){
        UIWindow*window= [UIApplication sharedApplication].keyWindow;
        _videoPlayer.frame=CGRectMake(0, 0, size.width,size.height);
        _videoPlayer.player.view.frame=CGRectMake(0, 0, size.width,size.height);
        _videoPlayer.isFullScreen=YES;
        _videoPlayer.toolsView.isFullScreen =YES;
        [window addSubview:_videoPlayer];
        
    }else{
        //        if (KIsiPhoneX||KIsiPhoneXR||KIsiPhoneXS||KIsiPhoneXS_MAX) {
        //            _playerView.frame=CGRectMake(0, 30, size.width, size.width/16*9);
        //            _playerView.player.view.frame=CGRectMake(0, 30, size.width, size.width/16*9);
        //        } else {
        _videoPlayer.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        _videoPlayer.player.view.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        //        }
        _videoPlayer.isFullScreen=NO;
        _videoPlayer.toolsView.isFullScreen =NO;
        [self.view addSubview:_videoPlayer];
        
    }
    
}

#pragma mark -- ijk 封装完成之后在 控制器要实现的代理方法 end




@end
