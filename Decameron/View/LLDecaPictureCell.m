//
//  LLDecaPictureCell.m
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "LLDecaPictureCell.h"
#import "LLDSModel.h"
#import "UIImage+Color.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FX.h"

@interface LLDecaPictureCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImage;

@end

@implementation LLDecaPictureCell

-(void)setData:(LLDSModel *)data
{
    _data = data;
    
    //装载数据
    if ([data.type isEqualToString:@"41"])
    {
        self.pictureView.image = [UIImage imageWithColor:WColorLightGray];
        
        self.gifImage.hidden = YES;
    }
    else if ([data.type isEqualToString:@"10"])
    {
        //图片
        
        //判断是否gif
        if ([data.is_gif isEqualToString:@"0"]) {
            self.gifImage.hidden = YES;
        }
        //调整空间
        [self ll_imageHander:data.image0 :data.cdn_img];
    }
    else if ([data.type isEqualToString:@"29"])
    {
        //文字，图片空间没有
    }
    else if ([data.type isEqualToString:@"31"])
    {
        //音频
    }
}

-(void)ll_imageHander:(NSString *)urlString1 :(NSString *)urlString2
{
    self.progressView.hidden = YES;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:urlString1] placeholderImage:[UIImage imageWithColor:WColorDarkGray] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //completed
        //显示progressview
        self.progressView.hidden = NO;
        
        //开始下载更高清的图
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:urlString2] placeholderImage:image options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat scale = receivedSize * 1.0 / expectedSize;
            self.progressView.progress = scale;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //隐藏progressview
            self.progressView.hidden = YES;
            
            
            //调整图片，使得某一节铺满image view
            //调整图片
            if (self.data.scale) {
                //需要调整
                CGFloat width = self.data.width.floatValue;
                CGFloat height = self.data.height.floatValue;
                CGSize size = image.size;
                if (width > WScreenWidth) {
                    //根据width调整height
                    WLog(@"height**%f  width**%f",height,width);
                    height = height/(width/WScreenWidth);
                }
                image = [image imageCroppedAndScaledToSize:CGSizeMake(image.size.width, height) contentMode:UIViewContentModeCenter padToFit:NO];
                WLog(@"width--%f  height--%f",size.width,height);
                [self.pictureView setImage:image];
            }
        }];
        
    }];
}



@end
