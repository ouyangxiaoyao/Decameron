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
#import "LLVideoView.h"

@interface LLDecaVideoCell ()

@property(strong,nonatomic)AVPlayerItem * playerItem;
@property(weak,nonatomic)AVPlayerLayer * avlayer;
@property(weak,nonatomic)AVPlayer * player;

@end


@implementation LLDecaVideoCell

-(AVPlayer *)player
{
    if (!_player) {
        AVPlayer * player = [[AVPlayer alloc]init];
        
        self.avlayer.player = player;
        _player = player;
    }
    return _player;
}

- (void)awakeFromNib {
    //初始化DidSelectCellBlock
    __weak LLDecaVideoCell * weakSelf = self;
    [self setDidSelectCellBlock:^(void){
        if (![weakSelf.player.currentItem isEqual:weakSelf.playerItem]) {
            [weakSelf.player replaceCurrentItemWithPlayerItem:weakSelf.playerItem];
        }
        
        weakSelf.player.rate = !weakSelf.player.rate;
        
//        weakSelf.avlayer.player = weakSelf.player;

        
        if (weakSelf.player.rate) {
            //隐藏按钮
            weakSelf.playStateButton.hidden = YES;
            [weakSelf.player play];
        }
        else
        {
            [weakSelf.player pause];
            weakSelf.playStateButton.hidden = NO;
        }
 
    }];
}

-(AVPlayerLayer *)avlayer
{
    if (!_avlayer) {
        AVPlayerLayer * layer = [[AVPlayerLayer alloc] init];
        [self.contentView.layer addSublayer:layer];
        _avlayer = layer;
    }
    return _avlayer;
}

-(void)setData:(LLDSModel *)data
{
    _data = data;
    //装载数据
    if ([data.type isEqualToString:@"41"])
    {
        
        self.backgroundColor = WArcColor;
        
        //视频
        self.playerItem = nil;
        self.playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.data.videouri]];
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

-(void)didMoveToSuperview
{
    self.avlayer.frame = self.bounds;
}

- (IBAction)changePlayState
{
}
@end
