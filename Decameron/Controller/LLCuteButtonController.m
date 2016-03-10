//
//  LLCuteButtonController.m
//  Decameron
//
//  Created by 李璐 on 16/3/4.
//  Copyright © 2016年 李璐. All rights reserved.
//
#define widthCuteButton (WScreenWidth - WPedding * 5)/4
#define heightCuteView widthCuteButton + WStatusBarHeight //和LLDecaRootController宏耦合

#import "LLCuteButtonController.h"

@interface LLCuteButtonController ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray<UIButton*> * buttonArray;
@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,assign)CGFloat lastOffSet;
@property(nonatomic,strong)NSArray * titleArray;

@end


static int buttonCounter = 8;
@implementation LLCuteButtonController

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView * view = [[UIScrollView alloc]init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.delegate = self;
        view.showsHorizontalScrollIndicator = NO;
        
        _scrollView = view;
    }
    return _scrollView;
}

-(NSArray *)buttonArray
{
    if (!_buttonArray) {
        NSMutableArray * array = [NSMutableArray array];
        
        UIButton * lastButton;
        for (int i = 0; i < buttonCounter; i++) {
            UIButton * button = [[UIButton alloc]init];
            button.tag = i + 10;
            [button addTarget:self action:@selector(cuteButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [self.scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.scrollView.mas_left).offset(WPedding);
                }
                else
                {
                    make.left.equalTo(lastButton.mas_right).offset(WPedding);
                }
                make.bottom.equalTo(self.scrollView).offset(0);
                make.top.equalTo(self.scrollView).offset(0);
                make.height.width.equalTo(@(widthCuteButton));
                
                if (i == buttonCounter - 1) {
                    make.trailing.equalTo(self.scrollView).offset(-WPedding);
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
    
    //统一加上一个CAGradientLayer
    for (UIButton * button in self.buttonArray) {
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = button.bounds;
        gradientLayer.locations = @[@(0.35),@(0.65)];
        gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor];
        
        [button.layer addSublayer:gradientLayer];
        
        [button bringSubviewToFront:button.titleLabel];
    }

    WLog(@"contentSize--%@",NSStringFromCGSize(self.scrollView.contentSize));
}

-(void)cuteButtonTouch:(UIButton *)sender
{
    //button动画
    CATransition *lldonghua = [CATransition animation];
    lldonghua.duration = 1.0;
    lldonghua.type = @"rippleEffect";
    [sender.layer addAnimation:lldonghua forKey:nil];
    
    //跳转到相应控制器
    switch (sender.tag) {
        case 10:
            //全部
            break;
            case 11:
            //内涵图
            break;
            case 12:
            //段子
            break;
            case 13:
            //视频
            break;
            case 14:
            //地图加即时通讯
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.titleArray = @[@"全部",@"内涵图",@"段子",@"小视频",@"男男女女",@"惊喜",@"你猜",@""];

    //果冻效果
    //四个button
    [self buttonArray];
}

-(void)hideHeaderWith:(CGFloat)y
{
    WLog(@"y--%f  heightCuteView--%f",y,heightCuteView);
    CGFloat scale = heightCuteView/y;
    self.view.alpha = scale;
    WLog(@"alpha--%f",scale);
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //和lastoffsize比较得出速度
    CGFloat speed = scrollView.contentOffset.x - self.lastOffSet;
    
    self.lastOffSet = scrollView.contentOffset.x;
    
    speed = speed/60;
    //动画
    [UIView animateWithDuration:0.1 animations:^{
        for (UIButton * button in self.buttonArray) {
            CGAffineTransform old = button.transform;
            button.transform = CGAffineTransformRotate(old, -speed);
        }
    }];
}
@end
