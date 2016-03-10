//
//  LLDSModel.h
//  屌丝男女的日常
//
//  Created by 李璐 on 16/2/26.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDSModel : NSObject

//控制信息

@property(nonatomic,strong)NSString * is_gif;

@property(nonatomic,strong)NSString * type;

//需显示信息

//图片信息
@property(nonatomic,strong)NSString * image0;

@property(nonatomic,strong)NSString * image1;

@property(nonatomic,strong)NSString * image2;

//通用信息
@property(nonatomic,strong)NSString * created_at;

@property(nonatomic,strong)NSString * cdn_img;

@property(nonatomic,strong)NSString * ding;

@property(nonatomic,strong)NSString * cai;

@property(nonatomic,strong)NSString * repost;

@property(nonatomic,strong)NSString * text;

@property(nonatomic,strong)NSString * weixin_url;

@property(nonatomic,strong)NSString * width;

@property(nonatomic,strong)NSString * height;

@property(nonatomic,strong)NSString * comment;


//video信息
@property(nonatomic,strong)NSString * videotime;

@property(nonatomic,strong)NSString * videouri;

@property(nonatomic,strong)NSNumber * playcount;

@property(nonatomic,strong)NSNumber * playfcount;
//音频信息
@property(nonatomic,strong)NSString * voicetime;

@property(nonatomic,strong)NSString * voiceuri;

//gif信息
@property(nonatomic,strong)NSString * gifFistFrame;

//作者的信息
@property(nonatomic,strong)NSString * screen_name;

@property(nonatomic,strong)NSString * profile_image;

//计算cell高度
-(void)caculate;

////辅助显示数据
////比例
@property(nonatomic,assign)CGFloat scale;

@end
