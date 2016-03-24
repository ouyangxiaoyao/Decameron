//
//  LLDecaVideoCell.m
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//
#import "LLDecaVideoCell.h"
#import "LLDSModel.h"
#import "SDWebImageDownloader.h"
#import "UIView+ViewController.h"
#import "VKVideoPlayerConfig.h"
#import "VKFoundation.h"
#import "VKVideoPlayerCaptionSRT.h"
#import "VKVideoPlayerAirPlay.h"
#import "VKVideoPlayerSettingsManager.h"
#import "VKVideoPlayerTrack.h"

#define NotificationName @"LLStopPlay"

@interface LLDecaVideoCell ()<VKVideoPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *brand;

@property(nonatomic,weak)UIView * llloadView;
@end


@implementation LLDecaVideoCell

-(VKVideoPlayer *)vkPlayer
{
    if (!_vkPlayer) {
        _vkPlayer = [[VKVideoPlayer alloc]init];
        [self.contentView addSubview:_vkPlayer.view];
        _vkPlayer.delegate = self;
        _vkPlayer.forceRotate = NO;
        
    }
    return _vkPlayer;
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    
    if (_vkPlayer) {
        _vkPlayer.view.hidden = YES;
    }

}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTouch:) name:NotificationName object:nil];

    //初始化DidSelectCellBlock
    __weak LLDecaVideoCell * weakSelf = self;
    [self setDidSelectCellBlock:^(void){
        //此处block只会执行一次，执行完成后视频播放页面覆盖cell，cell不相应手势
        [weakSelf postStopNotification];

        [weakSelf.vkPlayer.view setFrame:weakSelf.bounds];
        if (weakSelf.vkPlayer.view.hidden) {
            weakSelf.vkPlayer.view.hidden = NO;
            //清除前面印记
            [weakSelf.vkPlayer clearCaptions];
        }
        [weakSelf.vkPlayer loadVideoWithStreamURL:[NSURL URLWithString:weakSelf.data.videouri]];
        [weakSelf.contentView bringSubviewToFront:weakSelf.brand];

    }];
}

-(void)cellTouch:(NSNotification*)notificaton
{
    if (![notificaton.object isEqual:self]) {
        //停止播放
        [self.vkPlayer pauseContent:NO completionHandler:nil];
    }
}

-(void)setData:(LLDSModel *)data
{
    _data = data;
    //装载数据
    if ([data.type isEqualToString:@"41"])
    {
        [self llloadView];
        //视频
        
        //下载封面
        SDWebImageDownloader * downloader = [SDWebImageDownloader sharedDownloader];
        [downloader downloadImageWithURL:[NSURL URLWithString:data.image0] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            //
            self.layer.contents = (__bridge id _Nullable)(image.CGImage);
        }];
    }
}

- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event {
    if (event == VKVideoPlayerControlEventTapDone) {
        [self.vkPlayer pauseContent];
    }
    else if (event == VKVideoPlayerControlEventTapPlayerView)
    {
        if (self.vkPlayer.state == VKVideoPlayerStateContentPlaying) {
            [self.vkPlayer pauseContent];
        }
        else if (self.vkPlayer.state == VKVideoPlayerStateContentPaused)
        {
            [self.vkPlayer playContent];
            [self postStopNotification];
            
            [self.contentView bringSubviewToFront:self.brand];
        }
    }
    //全屏
    else if (event == VKVideoPlayerControlEventTapFullScreen)
    {

    }
}

-(void)postStopNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:self];
}

-(void)didMoveToSuperview
{
    [self.contentView bringSubviewToFront:self.brand];
}

#pragma mark 分享

- (IBAction)shareClick:(id)sender
{
    WLog(@"shareClick");

    __weak typeof(self) weakSelf = self;
    if (self.shareBlock) {
        self.shareBlock(weakSelf,self.data.weixin_url);
    }
}

- (IBAction)changePlayState
{
}
@end
