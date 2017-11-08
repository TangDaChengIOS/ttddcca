//
//  HomeHeaderView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/20.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "HomeHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LMJScrollTextView.h"
#import "LastPlayCollectionViewCell.h"
#import "BannerADSModel.h"
#import "GamesModel.h"

#define kCollectionItemWidth 56

@interface HomeHeaderView  ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) SDCycleScrollView * bannerView;//轮播图
@property (nonatomic,strong) LMJScrollTextView * scrollTextView;//滚动文字
@property (nonatomic,strong) UIImageView * scrollTextLeftImage;//滚动文字左边小图标
@property (nonatomic,strong) UICollectionView * collectionView;//
@property (nonatomic,strong) NSMutableArray * bannerDataSource;//轮播图数据源
@property (nonatomic,strong) NSMutableArray * bannerImagesArr;//轮播图图片

@property (nonatomic,strong) NSMutableArray * collectionViewDataSource;//最近游戏数据源
@property (nonatomic,assign) NSInteger totalFinishRequest;//记录完成几个接口的请求（失败、成功不管）
@end

@implementation HomeHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self.frame =CGRectMake(0, 0, MAXWIDTH, 300);
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, 167 * kPROPORTION) delegate:self placeholderImage:nil];
        _bannerView.autoScrollTimeInterval = 4;
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
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey"];
        [_collectionView registerClass:[LastPlayCollectionViewCell class] forCellWithReuseIdentifier:kLastPlayCollectionViewCellReuseID];
        [self addSubview:_collectionView];
        
        _scrollTextLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, _collectionView.maxY + 4.5, 15, 12)];
        _scrollTextLeftImage.image = KIMAGE(@"home_gameType_message_icon");
        [self addSubview:_scrollTextLeftImage];

        CGFloat leftMargin = _scrollTextLeftImage.maxX + 10;
        _scrollTextView = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(leftMargin,_collectionView.maxY , MAXWIDTH - leftMargin, 21) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        [self addSubview:_scrollTextView];
        [_scrollTextView startScrollWithAttributedString:[self getAttributeString:@"尊贵的XXX会员，贡献。会员。尊贵的。我爱你们啊 啊jhdbajdnkndkankjdajksndkasndiajsndknas"]];
        self.height = _scrollTextView.maxY;
        [self setNeedsDisplay];
    }
    return self;
}

-(void)refreshData
{
    self.isRequestData = YES;
    _totalFinishRequest = 0;
    kWeakSelf
    [RequestManager getManagerDataWithPath:@"ads" params:nil success:^(id JSON) {
        weak_self.bannerDataSource = [BannerADSModel jsonToArray:JSON];
        [weak_self.bannerImagesArr removeAllObjects];
        for (BannerADSModel * model in self.bannerDataSource) {
            [weak_self.bannerImagesArr addObject:model.imgUrl];
        }
        weak_self.bannerView.imageURLStringsGroup = weak_self.bannerImagesArr;
        weak_self.totalFinishRequest ++;
    } failure:^(NSError *error) {
        weak_self.totalFinishRequest ++;

    }];
    
    //token
    [RequestManager getManagerDataWithPath:@"lastGames" params:nil success:^(id JSON) {
        weak_self.collectionViewDataSource = [GamesModel jsonToArray:JSON];
        [weak_self.collectionView reloadData];
        weak_self.totalFinishRequest ++;

    } failure:^(NSError *error) {
        weak_self.totalFinishRequest ++;

    }];
    [RequestManager getWithPath:@"notices" params:nil success:^(id JSON) {
        NSLog(@"%@",JSON);
        weak_self.totalFinishRequest ++;

    } failure:^(NSError *error) {
        weak_self.totalFinishRequest ++;
    }];
}

-(void)setTotalFinishRequest:(NSInteger)totalFinishRequest
{
    _totalFinishRequest = totalFinishRequest;
    NSLog(@"成功——————%ld",_totalFinishRequest);
    if (_totalFinishRequest == 3) {
        self.isRequestData = NO;
    }
}

#pragma mark -- 选中某一页轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

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
    
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionHeader ) {
//        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewkey" forIndexPath:indexPath];
//        view.backgroundColor = UIColorFromINTValue(6, 68, 75);
//        if (view.subviews.count ==0) {
//            [view addSubview:[self createLabe]];
//        }
//        return view;
//    }
//    return nil;
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, kCollectionItemWidth);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(20, kCollectionItemWidth);
//}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 10, 20, 10);
//}


-(UILabel *)createLabe{
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, kCollectionItemWidth)];
    lab.numberOfLines = 4;
    lab.text = @"最\n近\n游\n戏";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.adjustsFontSizeToFitWidth = YES;
    lab.textColor = UIColorFromINTValue(83, 201, 214);
    return lab;
}

#pragma mark -- 将滚动文字转为带属性的文字
-(NSAttributedString *)getAttributeString:(NSString *)sourceString
{
    NSRange  range1 = [sourceString rangeOfString:@"尊贵的" options:NSLiteralSearch];
    NSRange  range2 = [sourceString rangeOfString:@"会员" options:NSLiteralSearch];

    if (range1.length == 0 || range2.length == 0)
    {
        return [[NSAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kFont(13)}];
    }
    else
    {
        if (range2.location > (range1.location + range1.length))
        {
            NSRange range = NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length);
            
            NSMutableAttributedString * mAStr = [[NSMutableAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kFont(13)}];
            
            NSAttributedString * aStr = [[NSAttributedString alloc]initWithString:[sourceString substringWithRange:range] attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(0, 246, 17),NSFontAttributeName:kFont(13)}];
            
            [mAStr replaceCharactersInRange:range withAttributedString:aStr];
            return mAStr;
        }
        else
        {
            return [[NSAttributedString alloc]initWithString:sourceString attributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:kFont(13)}];
        }
    }
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