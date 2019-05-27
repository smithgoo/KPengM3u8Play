//
//  KPIjkVideoView.m
//
//
//  Created by kpeng on 23/4/19.
//  Copyright © 2019 1232. All rights reserved.
//

#import "KPIjkVideoView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKMediaPlayer.h>
#import <IJKMediaFramework/IJKFFOptions.h>
#import "NowTimeSpeed.h"


@implementation KPIjkVideoGestures : UIView
-(id)initWithFrame:(CGRect)frame{
    
    
    if (self==[super initWithFrame:frame]) {
        
    }
    return self;
    
}
//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    //获取触摸开始的坐标
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    
    NSLog(@"获取触摸坐标%@",NSStringFromCGPoint(currentP));
    [self.delegate touchesBeganWith:currentP];
    
}
//触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    NSLog(@"获取触摸结束坐标%@",NSStringFromCGPoint(currentP));
    //    [self.touchDelegate touchesEndWithPoint:currentP];
}
//移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    NSLog(@"获取移动坐标%@",NSStringFromCGPoint(currentP));
    //    [self touchesMoveWithPoint:currentP];
    
    [self.delegate touchesMovedWith:currentP];
    
    
}
- (void)touchesMoveWithPoint:(CGPoint)point{
    
    
}
@end



//######################################################################################################################################################################################################



@implementation KPIjkVideoToolsView : UIView
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLockBtn)];
    [self addGestureRecognizer:tap];
    [self setUpUI];
    [self refreshMediaControl];
    self.volumeView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height * 9.0 / 16.0);
    [BrightnessView sharedBrightnessView];

    return self;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)hiddenLockBtn {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAll) object:nil];
    _toppanel.hidden =_bottomPanel.hidden =_lockedBtn.hidden =!_lockedBtn.hidden;
    if (_lockFlag) {
        _toppanel.hidden =_bottomPanel.hidden =YES;
    }else {
        [self performSelector:@selector(hideAll) withObject:nil afterDelay:4];
    }
    [self refreshMediaControl];
}

- (void)hideAll {
    _toppanel.hidden =_bottomPanel.hidden =_lockedBtn.hidden =YES;
}

-(void)setUpUI {
    _overlayPanel = [UIView new];
    [self addSubview:_overlayPanel];
    _imageCover = [UIImageView new];
    [_overlayPanel addSubview:_imageCover];
    
    _toppanel = [UIView new];
    [self addSubview:_toppanel];
    
    _bottomPanel = [UIView new];
    [self addSubview:_bottomPanel];
    
    _backBtn =[UIButton new];
    [_backBtn setImage:[UIImage imageNamed:@"ic_player_return"] forState:UIControlStateNormal];
    [_toppanel addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(videobackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [UILabel new];
    [_toppanel addSubview:_titleLabel];
    _titleLabel.font =[UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor whiteColor];
    
    
    _playBtn = [UIButton new];
    [_bottomPanel addSubview:_playBtn];
    [_playBtn setImage:[UIImage imageNamed:@"ic_palyer_stop_s"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"ic_palyer_play_s"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _beginTimeLab = [UILabel new];
    [_bottomPanel addSubview:_beginTimeLab];
    _beginTimeLab.font =[UIFont systemFontOfSize:15];
    _beginTimeLab.textColor = [UIColor whiteColor];
    _beginTimeLab.text = @"00:00";
    _beginTimeLab.textAlignment = NSTextAlignmentCenter;
    _beginTimeLab.textColor = [UIColor whiteColor];
    
    _totalTimeLab = [UILabel new];
    [_bottomPanel addSubview:_totalTimeLab];
    _totalTimeLab.font =[UIFont systemFontOfSize:15];
    _totalTimeLab.text = @"00:00";
    _totalTimeLab.textAlignment = NSTextAlignmentCenter;
    _totalTimeLab.textColor = [UIColor whiteColor];
    
    _fullScreenBtn = [UIButton new];
    [_bottomPanel addSubview:_fullScreenBtn];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"ic_big"] forState:UIControlStateNormal];
    [_fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _mediaProgressSlider = [[UISlider alloc] init];
    _mediaProgressSlider.minimumValue = 0.0;
    _mediaProgressSlider.maximumValue = 1.0;
    _mediaProgressSlider.minimumTrackTintColor = [UIColor whiteColor];
    _mediaProgressSlider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [_bottomPanel addSubview:_mediaProgressSlider];
    [_mediaProgressSlider setThumbImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateNormal];
    [_mediaProgressSlider addTarget:self action:@selector(slideTouchDown) forControlEvents:UIControlEventTouchDown];
    [_mediaProgressSlider addTarget:self action:@selector(slideTouchCancel) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    [_mediaProgressSlider addTarget:self action:@selector(slideTouchUpInside) forControlEvents:UIControlEventTouchUpInside];

    [_mediaProgressSlider addTarget:self action:@selector(slideValueChanged) forControlEvents:UIControlEventValueChanged];
    
    _lockedBtn = [UIButton new];
    [self addSubview:_lockedBtn];
    [_lockedBtn setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    [_lockedBtn setImage:[UIImage imageNamed:@"locked"] forState:UIControlStateSelected];
    [_lockedBtn addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [_overlayPanel addSubview:_activityIndicator];
    //设置小菊花颜色
    _activityIndicator.color = [UIColor whiteColor];
    //设置背景颜色
    _activityIndicator.backgroundColor = [UIColor clearColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    _activityIndicator.hidesWhenStopped = NO;
    [_activityIndicator startAnimating];
    [self setShowActivite:YES];
    
    _speedLab =[UILabel new];
    _speedLab.textAlignment =NSTextAlignmentCenter;
    _speedLab.font =[UIFont systemFontOfSize:14];
    _speedLab.textColor =[UIColor whiteColor];
    [_overlayPanel addSubview:_speedLab];
    
    
    _gesturesView =[KPIjkVideoGestures new];
    _gesturesView.delegate =self;
    [_overlayPanel addSubview:_gesturesView];
    
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _overlayPanel.frame =self.bounds;
    _imageCover.frame = self.bounds;
    _toppanel.frame =CGRectMake(0, 0, self.width, 50);
    _bottomPanel.frame =CGRectMake(0, self.height-50, self.width, 50);
    _backBtn.frame =CGRectMake(10, 5, 40, 40);
    _titleLabel.frame =CGRectMake(70, 5, self.width-80, 40);
    _playBtn.frame = CGRectMake(10, 5, 40, 40);
    _fullScreenBtn.frame =CGRectMake(self.width-50, 5, 40, 40);
    _beginTimeLab.frame =CGRectMake(10+40+3, 5, 70, 40);
    _totalTimeLab.frame =CGRectMake(self.width-10-3-40-70, 5, 70, 40);
    _mediaProgressSlider.frame =CGRectMake(10+40+3+70, 0, self.width-2*(10+40+3+70), 50);
    _lockedBtn.frame =CGRectMake(10, (self.height-40)/2, 40, 40);
    //设置小菊花的frame
    _activityIndicator.frame= CGRectMake((self.width-100)/2, (self.height-100)/2, 100, 100);
    _speedLab.frame =CGRectMake((self.width-100)/2, CGRectGetMaxY(_activityIndicator.frame)-20, 100, 30);
    _gesturesView.frame =self.bounds;
    
    if (_isFullScreen) {
        [_fullScreenBtn setImage:[UIImage imageNamed:@"ic_small"] forState:UIControlStateNormal];
    } else {
        [_fullScreenBtn setImage:[UIImage imageNamed:@"ic_big"] forState:UIControlStateNormal];
    }
    
}

- (void)slideTouchDown
{
    self.globelSlideValue =self.mediaProgressSlider.value;
    [self beginDragMediaSlider];
}

- (void)slideTouchCancel
{
//    self.thumbnailsView.hidden =YES;
    [self endDragMediaSlider];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSliderCancelValueChanged)]) {
        [self.delegate didSliderCancelValueChanged];
    }
}

- (void)slideTouchUpInside
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSliderTouchUpInside)]) {
        [self.delegate didSliderTouchUpInside];
    }
}

- (void)slideValueChanged
{
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.mediaProgressSlider.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
    }
    NSInteger DragTime= position-self.globelSlideValue;
    //获取缩略图的时间是dragtime +self.delegatePlayer.currentPlaybackTime

    //    NSInteger currentNeedTime =DragTime +self.delegatePlayer.currentPlaybackTime;
//    [self getThumbViewWith:DragTime currentTime:(position+DragTime)];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSliderValueChanged)]) {
        [self.delegate didSliderValueChanged];
    }
    
}

- (void)beginDragMediaSlider
{
    _isMediaSliderBeingDragged = YES;
}

- (void)endDragMediaSlider
{
//    self.thumbnailsView.hidden =YES;
    _isMediaSliderBeingDragged = NO;
}

//开始拖动的时候完成缩略图的展示
- (void)continueDragMediaSlider
{
    [self refreshMediaControl];
}


- (void)lockAction:(UIButton*)sender {
    sender.selected =!sender.selected;
    self.lockFlag =sender.selected;
    if (!self.lockFlag) {
        _toppanel.hidden =_bottomPanel.hidden=_lockedBtn.hidden =self.lockFlag;
    } else {
    [self performSelector:@selector(HiddenLock) withObject:nil afterDelay:4];
    }
}

- (void)HiddenLock {
    _toppanel.hidden =_bottomPanel.hidden=_lockedBtn.hidden =_lockFlag;
}

- (void)playAction:(UIButton*)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(videoPlayAction)]) {
        sender.selected = !sender.selected;
        [self.delegate videoPlayAction];
    }
}

- (void)fullScreenAction:(UIButton*)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(fullScreenAction)]) {
        sender.selected = !sender.selected;
        [self.delegate fullScreenAction];
    }
}



- (void)refreshMediaControl
{
    
    // duration
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration/* + 0.5*/;
    if (intDuration > 0) {
        self.mediaProgressSlider.maximumValue = duration;
        self.totalTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        self.totalTimeLab.text = @"--:--";
        self.mediaProgressSlider.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.mediaProgressSlider.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
        
        if (intDuration > 0) {
            self.mediaProgressSlider.value = position;
        } else {
            self.mediaProgressSlider.value = 0.0f;
        }
    }
    
    NSInteger intPosition = position /*+ 0.5*/;
    self.beginTimeLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    
    // status
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    self.playBtn.selected =/*self.centerPlayerBtn.selected =*/ isPlaying;
//    _centerPlayBtn.hidden = (isPlaying || [self.activiteView isAnimating]);
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.bottomPanel.hidden && self.delegatePlayer) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.25];
    }
    
}

- (void)videobackAction:(UIButton*)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(KPIjkVideoToolsBackAction)]) {
        [self.delegate KPIjkVideoToolsBackAction];
    }
}

- (void)setShowActivite:(BOOL)showActivite
{
    _speedLab.hidden =YES;
    if (showActivite) {
        _speedLab.hidden =NO;
        _activityIndicator.hidden = NO;
        [[NowTimeSpeed shareNetworkSpeed] start];
        [NowTimeSpeed shareNetworkSpeed].downloadSpeed = ^(NSString * _Nonnull speed) {
            self.speedLab.text =speed;
        };
       
    }else{
        _activityIndicator.hidden = YES;
        [[NowTimeSpeed shareNetworkSpeed] stop];
        
    }
    
}

- (void)hide
{
    if (_isFullScreen) {
        self.bottomPanel.hidden =self.lockedBtn.hidden= self.toppanel.hidden = self.backBtn.hidden=YES;
    } else {
        self.bottomPanel.hidden =self.lockedBtn.hidden = self.backBtn.hidden = YES;
    }
    //    self.topPanel.hidden = YES;
    
    [self layoutSubviews];
}

- (void)failPlayVideo {
    //停止状态刷新
    [self cancelDelayedRefresh];
//    self.backBtn.hidden =NO;
    self.playBtn.selected=/*self.centerPlayerBtn = */NO;
//    self.showActivite = NO;
    /**
     *  移除手势响应
     */
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        [self removeGestureRecognizer:gesture];
    }
    
    /**
     *  禁用底部控制栏
     */
    self.bottomPanel.userInteractionEnabled = NO;
}

- (void)cancelDelayedRefresh
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}
#pragma mark-- SYMediaGesturesViewdelegate 代理
//移动
-(void)touchesMovedWith:(CGPoint)point{
    if (_lockFlag) {
        return;
    }
    [self touchesMoveWithPoint:point];
    
}
//开始
-(void)touchesBeganWith:(CGPoint)point{
    if (_lockFlag) {
        return;
    }
    //方向置为无
    self.direction = DirectionNone;
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是音量，右边是亮度
    if (self.startPoint.x <= self.frame.size.width / 2.0) {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    } else {
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    }
    
}


//手离开屏幕的时候把手势取消了
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (_lockFlag) {
        return;
    }
     if (self.direction ==DirectionLeftOrRight) {
        NSTimeInterval DragTime=(self.delegatePlayer.duration-self.delegatePlayer.currentPlaybackTime)*self.currentRate;
        self.delegatePlayer.currentPlaybackTime=(self.delegatePlayer.currentPlaybackTime+DragTime)<=0?0:(self.delegatePlayer.currentPlaybackTime+DragTime);
        
    }
    
}

//断网或者异常状态的时候把手势取消了

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_lockFlag) {
        return;
    }

}

- (void)touchesMoveWithPoint:(CGPoint)point {

    if (self.delegatePlayer==nil) {
        return;
    }
    if (_lockFlag) {
        return;
    }
    
    //得出手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //分析出用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
         } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
         }
    }
    
    
    if (self.direction ==DirectionLeftOrRight) {
        //进度
        CGFloat rate = self.startVideoRate + (panPoint.x /18.0 / 200.0);
        if (rate > 1) {
            rate = 1;
        } else if (rate < 0) {
            //            rate = 0;
        }
        
        NSLog(@"进度 条%f",rate);
        self.currentRate = rate;
        
        NSTimeInterval DragTime=(self.delegatePlayer.duration-self.delegatePlayer.currentPlaybackTime)*rate;
        //
        //        //获取缩略图的时间是dragtime +self.delegatePlayer.currentPlaybackTime
        //
        //        NSInteger currentNeedTime =DragTime +self.delegatePlayer.currentPlaybackTime;
        //        [self getThumbViewWith:DragTime currentTime:self.delegatePlayer.currentPlaybackTime];
        NSTimeInterval position;
        position = self.delegatePlayer.currentPlaybackTime;
        //获取缩略图的时间是dragtime +self.delegatePlayer.currentPlaybackTime
         
        
        NSLog(@"滑动获得的%f",self.delegatePlayer.currentPlaybackTime);
    } else {
        if (self.direction == DirectionNone) {
            return ;
        }
        //音量和亮度
        if (self.startPoint.x <= self.frame.size.width / 2.0) {
            //音量
            if (panPoint.y < 0) {
                //增大音量
                [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.startVB + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    [self.volumeViewSlider setValue:0.1 animated:NO];
                    [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                }
                
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
            }
            
        } else {
            
            //调节亮度
            if (panPoint.y < 0) {
                //增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
            } else {
                //减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
            }
        }
    }
}

@end





//######################################################################################################################################################################################################

@implementation KPIjkVideoView

-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate playUrl:(NSString*)PlayUrl title:(NSString*)title{
    self = [super initWithFrame:frame];
    self.backgroundColor =[UIColor blackColor];
    self.url =PlayUrl;
    self.title =title;
    self.delegate = delegate;
    return self;
}

- (void)setUpVideoUI:(NSString*)url {
    if (self.player) {
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
        
    }
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
    [options setOptionIntValue:0 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setOptionIntValue:60 forKey:@"max-fps" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setPlayerOptionIntValue:256 forKey:@"vol"];
    
    
    NSURL *playUrl  =[NSURL URLWithString:url];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:playUrl withOptions:options];
    
    [self.player setScalingMode:IJKMPMovieScalingModeFill];
    
    [self.player prepareToPlay];
    
    [self installMovieNotificationObservers];
    
    self.playVideoView = [self.player view];
    self.playVideoView.frame =self.bounds;
    [self insertSubview:self.playVideoView atIndex:0];
    
    self.toolsView =[KPIjkVideoToolsView new];
    self.toolsView.frame = self.bounds;
    self.toolsView.delegate = self;
    self.toolsView.delegatePlayer =self.player;
    [self addSubview:_toolsView];
   
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolsView.frame =self.frame;
    [self.player view].frame =self.frame;
}

//开始播放
- (void)play {
    [self.player play];
    [self.toolsView refreshMediaControl];
}



//切换当前播放器的链接
- (void)exChangePlayMthod{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(KPVideoPlayerDistory)]) {
        [self.delegate KPVideoPlayerDistory];
    }

}

////设置url 的方式和切换播放源的方式一样
-(void)setUrl:(NSString *)url {
    _url =url;
    [self setUpVideoUI:url];
}

#pragma mark --- tools delegate method
//返回的操作
- (void)KPIjkVideoToolsBackAction {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playerBackAction)]) {
        [self.delegate playerBackAction];
    }
}

- (void)videoPlayAction {
    if (_player) {
        if ([_player isPlaying]) {
            [_player pause];
        } else {
            [_player play];
        }
    }
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen =isFullScreen;
    if (_isFullScreen) {
        [self.toolsView.fullScreenBtn setImage:[UIImage imageNamed:@"ic_small"] forState:UIControlStateNormal];
    } else {
        [self.toolsView.fullScreenBtn setImage:[UIImage imageNamed:@"ic_big"] forState:UIControlStateNormal];
    }
}

- (void)fullScreenAction {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(videoScreenFullScreenOrNot:)]) {
        [self.delegate videoScreenFullScreenOrNot:!_isFullScreen];
    }
}

- (void)didSliderCancelValueChanged {
    self.player.currentPlaybackTime = self.toolsView.mediaProgressSlider.value;

}


- (void)didSliderTouchUpInside {
    self.player.currentPlaybackTime = self.toolsView.mediaProgressSlider.value;
    [self.toolsView endDragMediaSlider];
}


- (void)didSliderValueChanged {
    [self.toolsView continueDragMediaSlider];
}




#pragma mark--


#pragma mark- 给视频添加状态变化的通知

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayFirstVideoFrameRendered:)
                                                 name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}


#pragma mark-加载状态改变

- (void)loadStateDidChange:(NSNotification*)notification {
    
    [self.toolsView refreshMediaControl];

    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
        [self.toolsView setShowActivite:NO];
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self.toolsView setShowActivite:YES];
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

#pragma mark-播放状态改变
- (void)moviePlayBackFinish:(NSNotification*)notification {
    [self.toolsView refreshMediaControl];
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: 播放完毕: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            
#pragma mark-播放出现错误,需要添重新加载播放视频的按钮
            
            
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
    
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {

    if (self.player.playbackState==IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放的时候开启计时器
        
        
    }
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            
            [self.toolsView refreshMediaControl];
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void)moviePlayFirstVideoFrameRendered:(NSNotification*)notification
{
    NSLog(@"加载第一个画面！");
    [self.toolsView setShowActivite:NO];
    //    [self.toolsView performSelector:@selector(hide) withObject:nil afterDelay:2];
    
    if(![self.player isPlaying]){
        NSLog(@"检测的一次播放状态错误");
        [self.player play];
    }
    
    [self.toolsView refreshMediaControl];
    
}

- (void)failPlay
{
    if (self.player) {
        [self.player pause];
    }
    
    [self.toolsView failPlayVideo];
    
    
//    if ([self.delegate respondsToSelector:@selector(playerViewFailePlay:)]) {
//        [self.delegate playerViewFailePlay:self];
//    }
    
}


@end
