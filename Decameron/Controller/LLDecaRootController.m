//
//  LLDecaRootController.m
//  Decameron
//
//  Created by 李璐 on 16/3/3.
//  Copyright © 2016年 李璐. All rights reserved.
//

#define widthCuteButton (WScreenWidth - WPedding * 5)/4
#define heightCuteView widthCuteButton + WStatusBarHeight //和collection view配置耦合


#import "LLDecaRootController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "LLDecaPictureCell.h"
#import "LLDecaTextCell.h"
#import "LLDSModel.h"
#import "LLDSManagerModel.h"
#import "QFNetHelp.h"
#import "MJExtension.h"
#import "LLDecaVideoCell.h"
#import "LLCuteButtonController.h"

#import "UIView+Screenshot.h"

#import "MJExtension.h"
#import "MJRefresh.h"
@interface LLDecaRootController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property(nonatomic,weak)UICollectionView * collectionView;

/*
 *lldsmodel
 */
@property(nonatomic,strong)NSArray * datasource;

@property(nonatomic,strong)LLDSManagerModel * infoModel;


/*
 * 正在播放的cell
 */
@property(nonatomic,weak)LLDecaVideoCell * playCell;

/*
 * 正在播放的cell
 */
@property(nonatomic,weak)LLCuteButtonController * cuteContrl;

/**
 * 控制动画适时停止的两个变量
 */
@property(nonatomic,assign)BOOL isTimeFull;
@property(nonatomic,assign)BOOL isRefreshComplish;

/**
 * 滚到头顶
 */
@property(nonatomic,assign)BOOL needScrollToTop;

@end

@implementation LLDecaRootController
#pragma mark 控制动画适时停止
-(void)setIsTimeFull:(BOOL)isTimeFull
{
    _isTimeFull = isTimeFull;
    
    if (_isRefreshComplish&&_isTimeFull) {
        CGRect frame = self.cuteContrl.view.frame;
        frame.origin.y += 10;
        self.cuteContrl.view.frame = frame;
        [self.cuteContrl.view.layer removeAllAnimations];
        _isRefreshComplish = NO;
        _isTimeFull = NO;
    }
}

-(void)setIsRefreshComplish:(BOOL)isRefreshComplish
{
    _isRefreshComplish = isRefreshComplish;
    
    if (_isRefreshComplish&&_isTimeFull) {
        CGRect frame = self.cuteContrl.view.frame;
        frame.origin.y += 10;
        self.cuteContrl.view.frame = frame;
        [self.cuteContrl.view.layer removeAllAnimations];
        _isRefreshComplish = NO;
        _isTimeFull = NO;
    }
}

//懒加载
#pragma mark 懒加载
-(NSArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSArray array];
    }
    return _datasource;
}


#pragma mark collectionview设置
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(heightCuteView, 0, 10, 5);//和cutecontrl初始化耦合
        layout.headerHeight = 1;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.columnCount = 1;
        
        
        UICollectionView * view = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView = view;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LLDecaPictureCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LLDecaPictureCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LLDecaVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LLDecaVideoCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"test"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LLDecaTextCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LLDecaTextCell class])];
        
        
        __weak typeof(self) weakSelf = self;
        MJRefreshStateHeader * header=[MJRefreshStateHeader headerWithRefreshingBlock:^{
            weakSelf.infoModel = nil;
            [weakSelf quest];
            [weakSelf cuteViewAnimateWhenHeadRefresh];
        }];
        header.lastUpdatedTimeText = ^NSString*(NSDate * text){
            return [NSString stringWithFormat:@"~屌丝女士为你刷新~"];
        };
        header.ignoredScrollViewContentInsetTop = -heightCuteView - 30;
        
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf quest];
            [weakSelf cuteViewAnimateWhenHeadRefresh];
        }];
        
        _collectionView.mj_footer = footer;
        _collectionView.mj_header = header;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark 头部刷新时cuteview的动画
-(void)cuteViewAnimateWhenHeadRefresh
{
    self.isRefreshComplish = NO;
    self.isTimeFull = NO;
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:0.5 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = self.cuteContrl.view.frame;
        frame.origin.y -= 10;
        self.cuteContrl.view.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
    
    //定时器，两秒后执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isTimeFull = YES;
    });
}

#pragma mark collection数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;
    LLDSModel * model = self.datasource[indexPath.item];
    //根据model的type取cell，赋值
    __weak typeof(self) weakSelf = self;

    if ([model.type isEqualToString:@"10"]) {
        LLDecaPictureCell * cellTmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLDecaPictureCell class]) forIndexPath:indexPath];
        cellTmp.data = model;
        [cellTmp setShareBlock:^(UICollectionViewCell * clickedCell,NSString* shareUrl)
        {
            [weakSelf share:clickedCell url:shareUrl];
        }];
        
        cell = cellTmp;
    }
    else if ([model.type isEqualToString:@"41"])
    {
        LLDecaVideoCell * cellTmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLDecaVideoCell class]) forIndexPath:indexPath];
        cellTmp.data = model;
        [cellTmp setShareBlock:^(UICollectionViewCell * clickedCell,NSString* shareUrl)
         {
             [weakSelf share:clickedCell url:shareUrl];
         }];
        
        cell = cellTmp;
    }
    else if ([model.type isEqualToString:@"29"]){
        LLDecaTextCell * cellTmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLDecaTextCell class]) forIndexPath:indexPath];
        cellTmp.data = model;
        [cellTmp setBackgroundColor:WArcColor];
        
        cell = cellTmp;
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
        [cell setBackgroundColor:WArcColor];
    }
    
    return cell;
}

#pragma mark layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLDSModel * model = self.datasource[indexPath.item];
    return CGSizeMake(model.width.floatValue, model.height.floatValue);
}

#pragma mark collection代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[LLDecaVideoCell class]]) {
        LLDecaVideoCell * cellTmp = (LLDecaVideoCell*)cell;
        cellTmp.didSelectCellBlock();
        self.playCell = cellTmp;
    }
    else if ([cell isKindOfClass:[LLDecaPictureCell class]])
    {
        LLDecaPictureCell * cellTmp = (LLDecaPictureCell*)cell;
        //弹出放大图
    }
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LLDecaVideoCell class]]) {
        LLDecaVideoCell * cellTmp = (LLDecaVideoCell*)cell;
        [cellTmp.vkPlayer.view removeFromSuperview];
        cellTmp.vkPlayer = nil;
        self.playCell = cellTmp;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.cuteContrl hideHeaderWith:scrollView.contentOffset.y];
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //网络请求
    self.type = @"1";
    
    //果冻效果
    [self setupCute];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //初始化参数
    self.needScrollToTop = NO;
}


#pragma mark button控制器
-(void)setupCute
{
    LLCuteButtonController * cuteContrl = [[LLCuteButtonController alloc]init];
    [self addChildViewController:cuteContrl];
    [self.view addSubview:cuteContrl.view];
    __weak typeof(self) weakSelf = self;
    [cuteContrl setPresentClassBlock:^(NSString * type){
        weakSelf.type = type;
    }];
    //这里要根据宽度决定cute view 的高度
    
    [cuteContrl.view setFrame:CGRectMake(0, 0, WScreenWidth, heightCuteView)];
    self.cuteContrl = cuteContrl;
}

#pragma mark 网络请求
-(void)setType:(NSString *)type
{
    if (![_type isEqualToString:type]) {
        if (_type) {
            [self cuteViewAnimateWhenHeadRefresh];
            self.needScrollToTop = YES;
        }
        _type = type;
        
        self.datasource = nil;
        
        [self quest];

    }
}

-(void)quest
{
    //网络请求
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:@{@"a":@"list",@"c":@"data"}];
    [param setObject:self.type forKey:@"type"];
    if (self.infoModel) {
        //添加页数
        [param setObject:self.infoModel.maxtime forKey:@"maxtime"];
    }
    [QFNetHelp getDataWithParam:param andPath:@"api/api_open.php" andComplete:^(BOOL success, id result) {
        if (success) {
            id obj = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            self.infoModel = [LLDSManagerModel mj_objectWithKeyValues:[obj objectForKey:@"info"]];
            
            NSArray * arrayTmp = [LLDSModel mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"list"]];
            [arrayTmp makeObjectsPerformSelector:@selector(caculate)];
            self.datasource = [self.datasource arrayByAddingObjectsFromArray:arrayTmp];
            WLog(@"success type %@",self.type);
            
            [self.collectionView reloadData];
            if (self.needScrollToTop) {
//                NSIndexPath * topPath = [NSIndexPath indexPathForItem:0 inSection:0];
//                [self.collectionView scrollToItemAtIndexPath:topPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                self.collectionView.contentOffset = CGPointMake(0, -heightCuteView);
                self.needScrollToTop = NO;
            }
            self.collectionView.mj_header.state = MJRefreshStateIdle;
            self.collectionView.mj_footer.state = MJRefreshStateIdle;
            self.isRefreshComplish = YES;
            [self.view bringSubviewToFront:self.cuteContrl.view];
        }
        else
        {
            self.collectionView.mj_header.state = MJRefreshStateIdle;
            self.collectionView.mj_footer.state = MJRefreshStateIdle;
            self.isRefreshComplish = YES;
            NSLog(@"error %@",result);
        }
    }];
    
}

#pragma mark 分享功能
-(void)share:(UICollectionViewCell*)clickCell url:(NSString*)shareUrl
{
}
@end
