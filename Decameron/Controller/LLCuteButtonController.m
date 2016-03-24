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

#import "SVProgressHUD.h"

@interface LLCuteButtonController ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray<UIButton*> * buttonArray;
@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,assign)CGFloat lastOffSet;
@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,weak)UIButton * lastSelectedButton;

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
    BOOL isFrist = YES;
    for (UIButton * button in self.buttonArray) {
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = button.bounds;
        gradientLayer.locations = @[@(0.35),@(0.65)];
        if (isFrist) {
            gradientLayer.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor redColor].CGColor];
            self.lastSelectedButton = button;
            isFrist = NO;
        }
        else
        {
            gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor];
        }
        
        [button.layer addSublayer:gradientLayer];
        
        [button bringSubviewToFront:button.titleLabel];
    }

    WLog(@"contentSize--%@",NSStringFromCGSize(self.scrollView.contentSize));
}

-(void)cuteButtonTouch:(UIButton *)sender
{
    //button动画
//    CATransition *lldonghua = [CATransition animation];
//    lldonghua.duration = 1.0;
//    lldonghua.type = @"";
//    [sender.layer addAnimation:lldonghua forKey:nil];
    NSString * type;
    
    //跳转到相应控制器
    switch (sender.tag) {
        case 10:
            //全部
            type = @"1";
            break;
            case 11:
            //内涵图
            type = @"10";
            break;
            case 12:
            //段子
            type = @"29";
            break;
            case 13:
            //视频
            type = @"41";
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"筹备中，敬请期待"];
            return;
            break;
    }
    if (type) {
        self.presentClassBlock(type);
    }
    //改变颜色，使其认出被选中button
    for (CALayer * subLayer in sender.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAGradientLayer class]]) {
            CAGradientLayer * gradientLayer = (CAGradientLayer*)subLayer;
            gradientLayer.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor redColor].CGColor];
        }
    }
    for (CALayer * subLayer in self.lastSelectedButton.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAGradientLayer class]]) {
            CAGradientLayer * gradientLayer = (CAGradientLayer*)subLayer;
            gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor];
        }
    }

    self.lastSelectedButton = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.titleArray = @[@"全部",@"内涵图",@"段子",@"小视频",@"",@"",@"",@""];

    //果冻效果
    //四个button
    [self buttonArray];
}

-(void)hideHeaderWith:(CGFloat)y
{
//    WLog(@"y--%f  heightCuteView--%f",y,heightCuteView);
//    CGFloat scale = heightCuteView/y;
//    self.view.alpha = scale;
//    WLog(@"alpha--%f",scale);
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
