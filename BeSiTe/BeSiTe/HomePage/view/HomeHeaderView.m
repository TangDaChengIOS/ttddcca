//
//  HomeHeaderView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "HomeHeaderView.h"
#import "LMJScrollTextView.h"
#import "LastPlayCollectionViewCell.h"
#import "BannerADSModel.h"
#import "GamesModel.h"
#import "GamesMenuView.h"

#define kCollectionItemWidth 56

@interface HomeHeaderView  ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) LMJScrollTextView * scrollTextView;//滚动文字
@property (nonatomic,strong) UIImageView * scrollTextLeftImage;//滚动文字左边小图标
@property (nonatomic,strong) UICollectionView * collectionView;//
@property (nonatomic,strong) NSMutableArray * bannerDataSource;//轮播图数据源
@property (nonatomic,strong) NSMutableArray * bannerImagesArr;//轮播图图片

@property (nonatomic,strong) NSMutableArray * collectionViewDataSource;//最近游戏数据源
@property (nonatomic,assign) NSInteger totalFinishRequest;//记录完成几个接口的请求（失败、成功不管）
@property (nonatomic,copy) NSAttributedString * scrollText;
@end

@implementation HomeHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self.frame =CGRectMake(0, 0, MAXWIDTH, 300);
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, 167 * kPROPORTION) delegate:self placeholderImage:KIMAGE(@"commmon_home_pic")];
        if ([BSTSingle defaultSingle].adsRollTime > 0) {
            _bannerView.autoScrollTimeInterval = [BSTSingle defaultSingle].adsRollTime;
        }
        [self addSubview:_bannerView];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, _bannerView.maxY, 20, kCollectionItemWidth)];
        lab.numberOfLines = 4;
        lab.text = @"最\n近\n游\n戏";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.adjustsFontSizeToFitWidth = YES;
        lab.textColor = UIColorFromINTValue(83, 201, 214);
        lab.backgroundColor = UIColorFromINTValue(6, 68, 75);
        [self addSubview:lab];
        
        UICollectionViewFlowLayout * lay = [[UICollectionViewFlowLayout alloc]init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20,_bannerView.maxY, MAXWIDTH - 20, kCollectionItemWidth ) collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromINTValue(24, 101, 114);
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[LastPlayCollectionViewCell class] forCellWithReuseIdentifier:kLastPlayCollectionViewCellReuseID];
        [self addSubview:_collectionView];
        
        _scrollTextLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, _collectionView.maxY + 4.5, 15, 12)];
        _scrollTextLeftImage.image = KIMAGE(@"home_gameType_message_icon");
        [self addSubview:_scrollTextLeftImage];

        CGFloat leftMargin = _scrollTextLeftImage.maxX + 10;
        _scrollTextView = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(leftMargin,_collectionView.maxY , MAXWIDTH - leftMargin, 21) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        [self addSubview:_scrollTextView];
        self.height = _scrollTextView.maxY;
        [self setNeedsDisplay];
    }
    return self;
}

-(void)refreshData
{
    if (self.isRequestData) {
        return;
    }
    self.isRequestData = YES;
    _totalFinishRequest = 0;
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"ads" params:nil success:^(id JSON ,BOOL isSuccess) {
        weak_self.totalFinishRequest ++;
        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.bannerDataSource = [BannerADSModel jsonToArray:JSON];
        [weak_self.bannerImagesArr removeAllObjects];
        for (BannerADSModel * model in self.bannerDataSource) {
            [weak_self.bannerImagesArr addObject:model.imgUrl];
        }
        weak_self.bannerView.imageURLStringsGroup = weak_self.bannerImagesArr;
    } failure:^(NSError *error) {
        weak_self.totalFinishRequest ++;

    }];
    
    //最近游戏
    [RequestManager getManagerDataWithPath:@"lastGames" params:nil success:^(id JSON ,BOOL isSuccess) {
        weak_self.totalFinishRequest ++;

        if (!isSuccess) {
            TTAlert(JSON);
            return ;
        }
        weak_self.collectionViewDataSource = [GamesModel jsonToArray:JSON];
        [weak_self.collectionView reloadData];

    } failure:^(NSError *error) {
        weak_self.totalFinishRequest ++;

    }];
}

-(void)setTotalFinishRequest:(NSInteger)totalFinishRequest
{
    _totalFinishRequest = totalFinishRequest;
    if (_totalFinishRequest == 2) {
        self.isRequestData = NO;
        if (self.finishRequestBlock) {
            self.finishRequestBlock();
        }
    }
}

#pragma mark -- 处理滚屏公告
-(void)handleNotices{
    [self.scrollTextView startScrollWithAttributedString:[BSTSingle defaultSingle].notices];
}


#pragma mark -- 选中某一页轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerADSModel * model = self.bannerDataSource[index];
    if (model.type == 1)//普通H5
    {
        [self.viewController.navigationController pushViewController:[WebDetailViewController quickCreateWithUrl:model.webUrl] animated:YES];
    }else{//游戏
        if (model.game) {
            [GamesMenuView showWithModel:model.game];
        }
    }
}

#pragma mark -- collectionView delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewDataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LastPlayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLastPlayCollectionViewCellReuseID forIndexPath:indexPath];
    [cell setCellWithModel:self.collectionViewDataSource[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [GamesMenuView showWithModel:self.collectionViewDataSource[indexPath.row]];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, kCollectionItemWidth);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

-(UILabel *)createLabe{
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, kCollectionItemWidth)];
    lab.numberOfLines = 4;
    lab.text = @"最\n近\n游\n戏";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.adjustsFontSizeToFitWidth = YES;
    lab.textColor = UIColorFromINTValue(83, 201, 214);
    return lab;
}

#pragma mark -- 重绘部分背景、UI
-(void)drawRect:(CGRect)rect
{
    [kMainColor setFill];
    UIRectFill(CGRectMake(0, _collectionView.maxY, MAXWIDTH, 21));
    [_collectionView reloadData];
}

-(NSMutableArray *)bannerDataSource{
    if (!_bannerDataSource) {
        _bannerDataSource = [NSMutableArray array];
    }
    return _bannerDataSource;
}

-(NSMutableArray *)collectionViewDataSource{
    if (!_collectionViewDataSource) {
        _collectionViewDataSource = [NSMutableArray array];
    }
    return _collectionViewDataSource;
}
-(NSMutableArray *)bannerImagesArr{
    if (!_bannerImagesArr) {
        _bannerImagesArr = [NSMutableArray array];
    }
    return _bannerImagesArr;
}
@end
