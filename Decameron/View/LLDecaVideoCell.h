//
//  LLDecaVideoCell.h
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"

@class LLDSModel;
@class LLDecaVideoCell;


typedef void(^DidSelectCellBlock)(void);

@interface LLDecaVideoCell : UICollectionViewCell

@property(nonatomic,copy)DidSelectCellBlock didSelectCellBlock;

@property (weak, nonatomic) IBOutlet UIButton *playStateButton;

@property(nonatomic,strong)VKVideoPlayer * vkPlayer;


/*
 *先给avlayer赋值，再给data赋值
 */
@property(nonatomic,strong)LLDSModel * data;


@end
