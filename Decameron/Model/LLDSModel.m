//
//  LLDSModel.m
//  屌丝男女的日常
//
//  Created by 李璐 on 16/2/26.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "LLDSModel.h"
#import "NSString+Size.h"

#define zipHeight WScreenHeight

@interface LLDSModel ()

@end

@implementation LLDSModel

//准备工作
-(void)caculate
{
    self.scale = 0;
    if (self.height.floatValue > WScreenHeight) {
        //隔离
        CGFloat width = self.width.floatValue;
        CGFloat height = self.height.floatValue;
        self.scale = height/width;
        height = zipHeight;
        self.height = [NSString stringWithFormat:@"%f",height];
        
    }
}

@end
