//
//  LLCuteButtonController.h
//  Decameron
//
//  Created by 李璐 on 16/3/4.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PresentClassBlock)(NSString* classString);
@interface LLCuteButtonController : UIViewController

@property(nonatomic,copy)PresentClassBlock presentClassBlock;

-(void)hideHeaderWith:(CGFloat)y;
@end
