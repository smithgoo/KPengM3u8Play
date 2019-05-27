//
//  KPIjkVideoView.h
//
//
//  Created by kpeng on 23/4/19.
//  Copyright © 2019 1232. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "BrightnessVolumeView.h"
#import "BrightnessView.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

typedef NS_ENUM(NSUInteger,NetWork_State_Type) {
    NetWork_State_NoNet,
    NetWork_State_2G,
    NetWork_State_3G,
    NetWork_State_4G,
    NetWork_State_WiFi,
    NetWork_State_HotSpot
};


@protocol KPIjkVideoViewDelegate <NSObject>
//移动
-(void)touchesMovedWith:(CGPoint)point;
//开始
-(void)touchesBeganWith:(CGPoint)point;

@end

@interface KPIjkVideoGestures : UIView

@property(nonatomic,assign) id<KPIjkVideoViewDelegate>delegate;

@end

//######################################################################################################################################################################################################

@protocol KPIjkVideoToolsDelegate <NSObject>

- (void)KPIjkVideoToolsBackAction;

- (void)videoPlayAction;

- (void)fullScreenAction;

- (void)didSliderCancelValueChanged;

- (void)didSliderTouchUpInside;

- (void)didSliderValueChanged;

@end

@interface KPIjkVideoToolsView : UIView

@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;

@property (nonatomic, strong) UIView    *overlayPanel;

//放一个封面
@property (nonatomic,strong) UIImageView *imageCover;
//顶部工具栏
@property (nonatomic,strong) UIView *toppanel;
//底部工具栏
@property (nonatomic,strong) UIView *bottomPanel;

@property (nonatomic,assign) CGFloat width;

@property (nonatomic,assign) CGFloat height;
// 返回按钮
@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) UILabel *beginTimeLab;

@property (nonatomic,strong) UILabel *totalTimeLab;

@property (nonatomic,strong) UIButton *fullScreenBtn;

@property (nonatomic,assign) BOOL isFullScreen;

@property (nonatomic, strong) UISlider  *mediaProgressSlider;

@property (nonatomic,strong) UIButton *lockedBtn;

@property (nonatomic, assign) BOOL lockFlag;
//是否开始拖拽
@property (nonatomic, assign) BOOL  isMediaSliderBeingDragged;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) UILabel *speedLab;

//手势的view
@property (nonatomic,strong) KPIjkVideoGestures *gesturesView;


//亮度显示
@property (strong,nonatomic) BrightnessVolumeView *brightnessVolumeView;


//获取当前全局的滑块百分比的值
@property (nonatomic, assign) float globelSlideValue;

@property (nonatomic,assign) id<KPIjkVideoToolsDelegate> delegate;

/*****************************************************************////

//上下左右手势操作
@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) CGPoint startPoint;//手势触摸起始位置
@property (assign, nonatomic) CGFloat startVB;//记录当前音量/亮度
@property (assign, nonatomic) CGFloat startVideoRate;//开始进度
@property (strong, nonatomic) CADisplayLink *link;//以屏幕刷新率进行定时操作
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider *volumeViewSlider;//控制音量
@property (assign, nonatomic) CGFloat currentRate;//当期视频播放的进度

/*****************************************************************////



- (void)setShowActivite:(BOOL)showActivite;

- (void)hide;

- (void)failPlayVideo;

- (void)beginDragMediaSlider;

- (void)endDragMediaSlider;

@end

//######################################################################################################################################################################################################
@protocol KPVideoPlayerActionDelegate <NSObject>
//销毁当前播放器
- (void)KPVideoPlayerDistory;

- (void)playerBackAction;

- (void)videoScreenFullScreenOrNot:(BOOL)isFullScreen;

@end

@interface KPIjkVideoView : UIView<KPIjkVideoToolsDelegate>
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,strong) IJKFFMoviePlayerController *player;
@property (nonatomic,strong) UIView *playVideoView;
@property (nonatomic,assign) id <KPVideoPlayerActionDelegate> delegate;
//控制工具的view
@property (nonatomic,strong) KPIjkVideoToolsView *toolsView;
//初始化当前播放器顺带放入按钮
-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate playUrl:(NSString*)PlayUrl title:(NSString*)title;


//开始播放
- (void)play;


//切换当前播放器的链接
- (void)exChangePlayMthod;
@end

NS_ASSUME_NONNULL_END
