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
#import "LLDSModel.h"
#import "LLDSManagerModel.h"
#import "QFNetHelp.h"
#import "MJExtension.h"
#import "LLDecaVideoCell.h"
#import "LLCuteButtonController.h"


@interface LLDecaRootController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property(nonatomic,weak)UIButton * all;
@property(nonatomic,weak)UIButton * picture;
@property(nonatomic,weak)UIButton * text;
@property(nonatomic,weak)UIButton * video;

@property(nonatomic,weak)UICollectionView * collectionView;

/*
 *lldsmodel
 */
@property(nonatomic,strong)NSArray * datasource;

@property(nonatomic,strong)LLDSManagerModel * infoModel;

@property(nonatomic,strong)NSString * type;

/*
 * 正在播放的cell
 */
@property(nonatomic,weak)LLDecaVideoCell * playCell;

/*
 * 正在播放的cell
 */
@property(nonatomic,weak)LLCuteButtonController * cuteContrl;
@end

@implementation LLDecaRootController


//懒加载

-(NSArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSArray array];
    }
    return _datasource;
}

-(UIButton *)all
{
    if (!_all) {
        UIButton * view = [[UIButton alloc]init];
        [self.view addSubview:view];
    }
    return _all;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(heightCuteView, 0, 10, 5);//和cutecontrl初始化耦合
        layout.headerHeight = 1;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        
        UICollectionView * view = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView = view;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LLDecaPictureCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LLDecaPictureCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LLDecaVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LLDecaVideoCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"test"];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
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
    if ([model.type isEqualToString:@"10"]) {
        LLDecaPictureCell * cellTmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLDecaPictureCell class]) forIndexPath:indexPath];
        cellTmp.data = model;
        
        cell = cellTmp;
    }
    else if ([model.type isEqualToString:@"41"])
    {
        LLDecaVideoCell * cellTmp = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLDecaVideoCell class]) forIndexPath:indexPath];
        cellTmp.data = model;
        
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
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    //讲正在播放的cell处理
    if (self.playCell) {
        self.playCell.didSelectCellBlock();
        if (![self.playCell isEqual:cell]) {
            //根据model的type取cell，赋值
            if ([cell isKindOfClass:[LLDecaVideoCell class]]) {
                LLDecaVideoCell * cellTmp = (LLDecaVideoCell*)cell;
                cellTmp.didSelectCellBlock();
                self.playCell = cellTmp;
            }
        }
        else
        {
            self.playCell = nil;
        }
    }
    else
    {
        if ([cell isKindOfClass:[LLDecaVideoCell class]]) {
            LLDecaVideoCell * cellTmp = (LLDecaVideoCell*)cell;
            cellTmp.didSelectCellBlock();
            self.playCell = cellTmp;
        }
    }

}


-(void)loadView
{
    [super loadView];
    /*
     界面设计，四个大圆button分为图片，段子，视频，全部，瀑布流设计
     button要有浮动的效果
     */
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    self.type = @"41";
    [self quest];
    
    //果冻效果
    [self setupCute];
}

#pragma mark 果冻效果
-(void)setupCute
{
    LLCuteButtonController * cuteContrl = [[LLCuteButtonController alloc]init];
    [self addChildViewController:cuteContrl];
    [self.view addSubview:cuteContrl.view];
    //这里要根据宽度决定cute view 的高度
    
    [cuteContrl.view setFrame:CGRectMake(0, 0, WScreenWidth, heightCuteView)];
    self.cuteContrl = cuteContrl;
}

#pragma mark 网络请求
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
            WLog(@"success");
            
            [self.collectionView reloadData];
            [self.view bringSubviewToFront:self.cuteContrl.view];
        }
        else
        {
            NSLog(@"error %@",result);
        }
    }];
    
}

@end
