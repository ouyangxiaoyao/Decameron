//
//  LLCuteButtonController.m
//  Decameron
//
//  Created by 李璐 on 16/3/4.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "LLCuteButtonController.h"

@interface LLCuteButtonController ()

@property(nonatomic,strong)NSArray<UIButton*> * buttonArray;

@end

@implementation LLCuteButtonController

-(NSArray *)buttonArray
{
    if (!_buttonArray) {
        NSMutableArray * array = [NSMutableArray array];
        CGFloat widthCuteButton = (WScreenWidth - WPedding * 5)/4;
        
        UIButton * lastButton;
        for (int i = 0; i < 4; i++) {
            UIButton * button = [[UIButton alloc]init];
            [button setBackgroundColor:WArcColor];
            [self.view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.view.mas_left).offset(WPedding);
                }
                else
                {
                    make.left.equalTo(lastButton.mas_right).offset(WPedding);
                    
                    make.width.equalTo(lastButton);
                }
                make.top.equalTo(self.view).offset(WStatusBarHeight);
                make.width.equalTo(button.mas_height);
                
                if (i == 3) {
                    make.trailing.equalTo(self.view).offset(-WPedding);
                }
            }];
            lastButton = button;
            
            button.layer.cornerRadius = widthCuteButton/2;
            button.clipsToBounds =YES;
            [array addObject:button];
        }//end for
        _buttonArray = array;
    }//end if
    return _buttonArray;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WLog(@"%@",NSStringFromCGRect([self.buttonArray firstObject].frame));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //果冻效果
    //四个button
    [self buttonArray];
}
@end
