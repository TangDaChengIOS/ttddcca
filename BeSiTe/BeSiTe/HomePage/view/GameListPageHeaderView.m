//
//  GameListPageHeaderView.m
//  BeSiTe
//
//  Created by 汤达成 on 17/10/22.
//  Copyright © 2017年 Tang. All rights reserved.
//

#import "GameListPageHeaderView.h"
#import "LMJScrollTextView.h"
#import "LastPlayCollectionViewCell.h"

#define kCollectionItemWidth (56 *kPROPORTION)
#define kCollectionItemHeight (75 *kPROPORTION)

@interface GameListPageHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) LMJScrollTextView * scrollTextView;
@property (nonatomic,strong) UIImageView * scrollTextLeftImage;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UIButton * searchBtn;
@end

@implementation GameListPageHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self.frame =CGRectMake(0, 0, MAXWIDTH, 300);
    
        UICollectionViewFlowLayout * lay = [[UICollectionViewFlowLayout alloc]init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAXWIDTH, kCollectionItemHeight) collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromINTValue(24, 101, 114);
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[LastPlayCollectionViewCell class] forCellWithReuseIdentifier:kLastPlayCollectionViewCellReuseID2];
        [self addSubview:_collectionView];
        
        _scrollTextLeftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, _collectionView.maxY + 9, 15, 12)];
        _scrollTextLeftImage.image = KIMAGE(@"home_gameType_message_icon");
        [self addSubview:_scrollTextLeftImage];
        
        CGFloat leftMargin = _scrollTextLeftImage.maxX + 4;
        _scrollTextView = [[LMJScrollTextView alloc]initWithFrame:CGRectMake(leftMargin,_collectionView.maxY , MAXWIDTH - leftMargin - 104, 30) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        [self addSubview:_scrollTextView];
        [_scrollTextView startScrollWithAttributedString:[self getAttributeString:@"尊贵的XXX会员，贡献。会员。尊贵的。我爱你们啊 啊jhdbajdnkndkankjdajksndkasndiajsndknas"]];
        
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(_scrollTextView.maxX +10, _collectionView.maxY + 3, 90, 24)];
        UILabel * btnLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 66, 24)];
        btnLab.text = @"游戏搜索";
        btnLab.textColor = UIColorFromINTValue(142, 146, 149);
        btnLab.font = kFont(12);
        btnLab.textAlignment = NSTextAlignmentCenter;
        btnLab.backgroundColor = UIColorFromINTValue(60, 90, 95);
        [_searchBtn addSubview:btnLab];
        
        UIImageView * btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(66 + 4, 4, 16, 16)];
        btnImage.image = KIMAGE(@"home_gameType_title_search_icon");
        _searchBtn.layer.cornerRadius = 2.0f;
        _searchBtn.clipsToBounds = YES;
        [_searchBtn addSubview:btnImage];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchBtn];
   
        self.height = _scrollTextView.maxY ;
        [self setNeedsDisplay];
    }
    return self;
}
-(void)setSelectedItem:(NSInteger)selectedItem
{
    if (selectedItem > [BSTSingle defaultSingle].companysArray.count) {
        selectedItem =0 ;
    }
    _selectedItem = selectedItem;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectedItem inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}


-(void)searchBtnClick{
    if (self.gotoSearchBlock) {
        self.gotoSearchBlock();
    }
}

#pragma mark -- collectionView delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [BSTSingle defaultSingle].companysArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LastPlayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLastPlayCollectionViewCellReuseID2 forIndexPath:indexPath];
    [cell setCellWithCompanyModel:[BSTSingle defaultSingle].companysArray[indexPath.item]];
    if (indexPath.item == self.selectedItem) {
        [cell setSelected:YES];
    }
    else{
        [cell setSelected:NO];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedItem = indexPath.item;
    [self.collectionView reloadData];
    GamesCompanyModel * model = [BSTSingle defaultSingle].companysArray[indexPath.item];
    NSLog(@"%@",model.companyCode);
    if (self.selectGameCompanyBlock) {
        self.selectGameCompanyBlock(model.companyCode);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCollectionItemWidth ,kCollectionItemHeight);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
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
            
            NSAttributedString * aStr = [[NSAttributedString alloc]initWithString:[sourceString substringWithRange:range] attributes:@{NSForegroundColorAttributeName:UIColorFromINTValue(253, 192, 68),NSFontAttributeName:kFont(13)}];
            
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
    [UIColorFromINTValue(2, 40, 47) setFill];
    UIRectFill(CGRectMake(0, _collectionView.maxY, MAXWIDTH, 30));
    [UIColorFromINTValue(42, 74, 81) setFill];
    UIRectFill(CGRectMake(_scrollTextView.maxX + 66 + 10, _collectionView.maxY + 3, 24, 24));
    
    [_collectionView reloadData];
}
@end
