//
//  LLDecaPictureCell.h
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLDSModel;

typedef void(^ShareBlock)(UICollectionViewCell * cell,NSString * shareUrl);
@interface LLDecaPictureCell : UICollectionViewCell

@property(nonatomic,strong)LLDSModel * data;
/**
 * 分享按钮点击调用
 */
@property(nonatomic,copy)ShareBlock shareBlock;

@end
